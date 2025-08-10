import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecarrgo/core/features/customer/activity/data/datasources/auction_remote_data_source.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/data/datasouces/create_payment_datasource.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/data/datasouces/select_winner_datasoource.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/data/datasouces/tracking_datasource.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/data/datasouces/upload_payment_proof_remote_datasource.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/auction_payment/widgets/payment_confirmation_dialog.dart';
import 'package:ecarrgo/core/network/api_constants.dart';
import 'package:ecarrgo/core/network/storage/secure_storage_service.dart';
import 'package:ecarrgo/core/providers/shipment_progress_provider.dart';
import 'package:ecarrgo/main_customer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// Import halaman step
import 'preparation/pages/preparation_page.dart';
import 'auction_payment/pages/auction_payment_page.dart';
import 'en_route/pages/en_route_page.dart';
import 'order_arrived/pages/order_arrived_page.dart';

enum DataLoadState { loading, success, error }

class SendPackageFlowLayout extends StatefulWidget {
  final int auctionId;
  final int shipmentId;

  const SendPackageFlowLayout({
    super.key,
    required this.auctionId,
    required this.shipmentId,
  });

  @override
  State<SendPackageFlowLayout> createState() => _SendPackageFlowLayoutState();
}

class _SendPackageFlowLayoutState extends State<SendPackageFlowLayout> {
  int _currentStep = 0;
  Map<String, dynamic>? _shipmentData;
  Map<String, dynamic>? _myBids;
  Map<String, dynamic>? _historyData;
  String _shipmentStatus = 'waiting_approval'; // Add this field
  String _resiNumber = '';

  bool paymentConfirmed = false;
  bool hasSelectedDriver = false; // Tambahkan state ini
  int? selectedDriverIndex;
  bool _isLoading = true; // Add this to your state

  bool _hasSelectedVendor = false; // Tambahkan ini
  int? _selectedVendorId;

  final _dio = Dio(BaseOptions(
    baseUrl: '${ApiConstants.baseUrl}/api/v1',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
  ));

  void _mapStatusToCurrentStep() {
    debugPrint('Mapping status: $_shipmentStatus');
    switch (_shipmentStatus) {
      case 'waiting_approval':
        _currentStep = 0;
        break;
      case 'auction_started':
        _currentStep = 1;
        break;
      case 'shipping':
        _currentStep = 2;
        break;
      case 'completed':
        _currentStep = 3;
        break;
      default:
        _currentStep = 0;
    }

    // Update the UI if widget is mounted
    if (mounted) {
      setState(() {});
    }
    debugPrint('Mapped to step: $_currentStep');
  }

  Future<void> _loadShipmentData() async {
    setState(() => _isLoading = true);
    if (!mounted) {
      debugPrint('Not mounted, skipping data load');
      return;
    }

    final dio = Dio(BaseOptions(
      baseUrl: '${ApiConstants.baseUrl}/api/v1',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ));

    try {
      debugPrint(
          'Starting to load shipment data for auction ${widget.auctionId}');

      final response = await AuctionRemoteDataSourceImpl(dio)
          .getAuctionById(widget.auctionId);

      // final encoder = JsonEncoder.withIndent('  ');

      if (!mounted) {
        debugPrint('Widget unmounted during API call, aborting');
        return;
      }

      setState(() {
        _shipmentData = response['data'];
        _shipmentStatus = _shipmentData?['status'] ?? 'waiting_approval';
        _resiNumber = _shipmentData?['shipment']?['resi_number'] ?? '';
        debugPrint('Resi Number shipment: $_resiNumber');
        _mapStatusToCurrentStep();
        _isLoading = false; // Pastikan loading state diperbarui
      });
    } on DioException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Network error: ${e.message}')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadMyBids() async {
    try {
      final response = await AuctionRemoteDataSourceImpl(_dio).getMyBids();
      if (mounted) {
        setState(() {
          _myBids = response['data'];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load bids: $e')),
        );
      }
    }
  }

  Future<void> _fetchTrackingUpdates() async {
    try {
      final accessToken = await SecureStorageService().getToken();
      if (accessToken == null) {
        throw Exception('Anda harus login terlebih dahulu');
      }

      if (_resiNumber.isEmpty) {
        throw Exception('Nomor resi tidak tersedia');
      }

      debugPrint('Fetching tracking updates...');
      debugPrint('Resi Number di tracking: $_resiNumber');

      // Buat instance TrackingDataSource
      final trackingDataSource = TrackingDataSource();

      // Panggil metode getRealtimeTrackingUpdates
      final trackingUpdates =
          await trackingDataSource.getRealtimeTrackingUpdates(
        resiNumber: _resiNumber,
        accessToken: accessToken,
      );

      // Ambil status_history dari data API
      final statusHistory =
          trackingUpdates['data']?['status_history'] as List<dynamic>? ?? [];

      // Pretty print JSON response
      final encoder = JsonEncoder.withIndent('  ');
      final prettyJson = encoder.convert(trackingUpdates);
      debugPrint('Tracking Updates (Pretty JSON):\n$prettyJson');

      if (mounted) {
        setState(() {
          _historyData = {
            'data': statusHistory.map((entry) {
              return {
                'status': entry['status'] ?? 'Tidak diketahui',
                'timestamp':
                    entry['changed_at'] ?? DateTime.now().toIso8601String(),
              };
            }).toList(),
          };
        });
      }
    } on DioException catch (e) {
      debugPrint('Error fetching tracking updates: ${e.response?.data}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Gagal memuat pembaruan pelacakan: ${e.message}')),
        );
      }
    } catch (e) {
      debugPrint('Unexpected error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Don't immediately update from provider - wait for confirmation
    _currentStep = 0;
    paymentConfirmed = false;
    hasSelectedDriver = false;
    selectedDriverIndex = null;

    // Optional: Load from provider but verify confirmation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final progress = context.read<ShipmentProgressProvider>();
      if (progress.currentStep > 0 && !_isStepConfirmed(progress)) {
        // Reset if step was advanced without confirmation
        progress.resetProgress();
      }
    });

    // Muat data shipment terlebih dahulu
    _loadShipmentData().then((_) {
      // Setelah data shipment selesai dimuat, panggil fetch tracking updates
      _fetchTrackingUpdates();
    });
    _loadMyBids();
  }

  bool _isStepConfirmed(ShipmentProgressProvider progress) {
    // Add your confirmation logic here
    return progress.paymentConfirmed || progress.selectedDriverIndex != null;
  }

  List<Widget> get _pages {
    return [
      PreparationPage(
        auctionId: widget.auctionId,
        shipmentId: widget.shipmentId,
        status: _shipmentStatus,
        pickupAddress: _shipmentData?['shipment']?['pickup_address'] ??
            'Alamat jemput belum dipilih',
        destinationAddress: _shipmentData?['shipment']?['delivery_address'] ??
            'Alamat tujuan belum dipilih',
        resiNumber: _shipmentData?['shipment']?['resi_number'] ?? '-',
        historyData: _historyData,
      ),
      AuctionPaymentPage(
        auctionId: widget.auctionId,
        shipmentId: widget.shipmentId,
        auctionData: _shipmentData, // Kirim data ke AuctionPaymentPage
        myBids: _myBids,
        paymentConfirmed: paymentConfirmed,
        status: _shipmentStatus,
        hasSelectedVendor: _hasSelectedVendor,
        timestampStatus: _shipmentData?['shipment']?['created_at'] ?? '-',
        onDriverSelected: (hasSelected) {
          setState(() {
            _hasSelectedVendor = _shipmentData?['selected_vendor_id'] != null;
          });
        },
        onVendorSelected: _onVendorSelected,
      ),
      EnRoutePage(
        auctionId: widget.auctionId,
        shipmentId: widget.shipmentId,
        auctionData: _shipmentData,
        status: _shipmentStatus,
        pickupAddress: _shipmentData?['shipment']?['pickup_address'] ??
            'Alamat jemput belum dipilih',
        destinationAddress: _shipmentData?['shipment']?['delivery_address'] ??
            'Alamat tujuan belum dipilih',
        resiNumber: _shipmentData?['shipment']?['resi_number'] ?? '-',
        historyData: _historyData,
      ),
      OrderArrivedPage(
        auctionId: widget.auctionId,
        shipmentId: widget.shipmentId,
        status: _shipmentStatus,
        auctionData: _shipmentData,
        pickupAddress: _shipmentData?['shipment']?['pickup_address'] ??
            'Alamat jemput belum dipilih',
        destinationAddress: _shipmentData?['shipment']?['delivery_address'] ??
            'Alamat tujuan belum dipilih',
        resiNumber: _shipmentData?['shipment']?['resi_number'] ?? '-',
        historyData: _historyData,
      ),
    ];
  }

  final List<String> stepLabels = const [
    'Konfirmasi',
    'Lelang & Bayar',
    'Menuju Alamat',
    'Pesanan Tiba',
  ];

  final List<String> stepDescriptions = const [
    'Menunggu Konfirmasi ECargo',
    'Lelang dan Bayar',
    'Menuju Alamat Pengiriman',
    'Pesanan Telah Tiba',
  ];

  String get _currentDescription {
    switch (_shipmentStatus) {
      case 'waiting_approval':
        return 'Menunggu Konfirmasi ECargo';
      case 'auction_started':
        return 'Proses lelang sedang berlangsung';
      case 'shipping':
        return 'Paket sedang dalam perjalanan';
      case 'completed':
        return 'Paket telah sampai tujuan';
      default:
        return 'Menunggu Konfirmasi ECargo';
    }
  }

  Future<void> _selectVendor(int vendorId) async {
    try {
      final accessToken = await SecureStorageService().getToken();
      if (accessToken == null) {
        throw Exception('Anda harus login terlebih dahulu');
      }

      if (_selectedVendorId == null || _selectedVendorId == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih vendor terlebih dahulu')),
        );
        return;
      }

      // Panggil API select winner
      await SelectWinnerDataSource().selectWinner(
        auctionId: widget.auctionId,
        vendorId: _selectedVendorId ?? 0,
        accessToken: accessToken,
      );

      if (mounted) {  
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vendor berhasil dipilih')),
        );

        // Perbarui state jika diperlukan
        setState(() {
          _hasSelectedVendor = true;
        });

        // Refresh data setelah vendor dipilih
        _loadShipmentData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memilih vendor: $e')),
        );
      }
    }
  }

  void _onVendorSelected(int vendorId) {
    setState(() {
      _selectedVendorId = vendorId != 0 ? vendorId : null;
      _hasSelectedVendor = _selectedVendorId != null;
    });
  }

  Future<void> uploadPaymentProof({required File imageFile}) async {
    try {
      // Simulate upload delay
      await Future.delayed(const Duration(seconds: 2));
      debugPrint('Uploading file: ${imageFile.path}');
    } catch (e) {
      debugPrint('Upload error: $e');
      rethrow; // propagate the error
    }
  }

  Future<void> _showPaymentConfirmationDialog(BuildContext context) async {
    if (_shipmentData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data pengiriman tidak tersedia')),
      );
      return;
    }

    final bidsList = _shipmentData?['bids'];
    if (bidsList is! List || bidsList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada penawaran ditemukan')),
      );
      return;
    }

    final firstBid = bidsList[0] as Map<String, dynamic>? ?? {};
    final vendor = firstBid['user'] ?? {};
    final paymentDetails = _shipmentData?['payment_details'] ?? {};

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PaymentConfirmationDialog(
        onConfirm: (imageFile) async {
          try {
            // Tampilkan loading
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );

            final accessToken = await SecureStorageService().getToken();
            if (accessToken == null) {
              Navigator.of(context).pop(); // Tutup loading
              throw Exception('Anda harus login terlebih dahulu');
            }

            // 1. Upload Payment Proof
            await UploadPaymentProofDataSource(_dio).uploadPaymentProof(
              shipmentId: widget.shipmentId,
              filePath: imageFile.path,
              accessToken: accessToken,
            );

            // 2. Select Winner
            await SelectWinnerDataSource().selectWinner(
              auctionId: widget.auctionId,
              vendorId: vendor['id'] ?? 0,
              accessToken: accessToken,
            );

            // 3. Create Payment
            final amount =
                double.tryParse(firstBid['bid_amount']?.toString() ?? '0') ??
                    0.0;
            await CreatePaymentDataSource(_dio).createPayment(
              shipmentId: widget.shipmentId,
              userId: vendor['id'] ?? 0,
              amount: amount,
              paymentMethod: 'bank_transfer',
              filePath: imageFile.path,
              accessToken: accessToken,
            );

            setState(() {
              paymentConfirmed = true;
            });

            Navigator.of(context).pop(); // Tutup loading
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Bukti pembayaran berhasil diunggah')),
            );
          } catch (e) {
            Navigator.of(context).pop(); // Tutup loading
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal memproses pembayaran: $e')),
            );
          }
        },
        amount:
            'Rp ${NumberFormat("#,##0", "id_ID").format(int.tryParse(firstBid['bid_amount']?.toString() ?? '0') ?? 0)}',
        driverName: vendor['name'] ?? 'Tidak diketahui',
        driverAvatar: 'assets/images/users/default.png',
        bankName: paymentDetails['bank_name'] ?? 'BANK BNI',
        accountNumber: paymentDetails['account_number'] ?? '2313123131321',
        accountHolder: paymentDetails['account_holder'] ?? 'ECARRGO INDONESIA',
      ),
    );

    if (result == true && mounted) {
      if (!hasSelectedDriver) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih driver terlebih dahulu')),
        );
        return;
      }

      setState(() {
        paymentConfirmed = true;
      });
    }
  }

  // Example methods for button actions
  Future<void> _cancelAuction() async {
    try {
      // Implement cancel auction API call
      debugPrint('Cancelling auction...');
      // Show confirmation dialog first
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Batalkan Lelang'),
          content: const Text('Anda yakin ingin membatalkan lelang ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Ya'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        // Call API to cancel auction
        final response = await _dio.post(
          '/auctions/${widget.auctionId}/cancel',
          options: Options(headers: {
            'Authorization': 'Bearer ${await SecureStorageService().getToken()}'
          }),
        );

        if (response.statusCode == 200) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Lelang berhasil dibatalkan')),
            );
            // Refresh data
            _loadShipmentData();
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membatalkan: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _continuePayment() async {
    // Implement payment continuation logic
    await _showPaymentConfirmationDialog(context);
  }

  Future<void> _confirmDelivery() async {
    try {
      // Implement delivery confirmation API call
      final response = await _dio.post(
        '/shipments/${widget.shipmentId}/complete',
        options: Options(headers: {
          'Authorization': 'Bearer ${await SecureStorageService().getToken()}'
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pengiriman telah dikonfirmasi')),
          );

          // Refresh data
          _loadShipmentData();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengkonfirmasi: ${e.toString()}')),
        );
      }
    }
  }

  Widget _buildConfirmationButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            // Add confirmation logic here
            // _confirmDelivery();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const CustomerNavigation(initialIndex: 1),
              ),
              (route) => false,
            );
          },
          child: const Text(
            'Konfirmasi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Button for waiting_approval status
  Widget _buildCancelAuctionButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            // Add cancel auction logic here
            _cancelAuction();
          },
          child: const Text(
            'Batalkan Lelang',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

// Button for auction_started status
  Widget _buildContinuePaymentButton() {
    if (paymentConfirmed) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _hasSelectedVendor ? Colors.blue : Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _hasSelectedVendor && _selectedVendorId != null
              ? () {
                  _continuePayment();
                }
              : null,
          child: const Text(
            'Lanjutkan Pembayaran',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          _shipmentData?['shipment']?['delivery_address'] ??
              'Alamat tujuan belum dipilih',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const CustomerNavigation(initialIndex: 1),
              ),
              (route) => false,
            );
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadShipmentData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  StepIndicator(
                    currentStep: _currentStep,
                    stepLabels: stepLabels,
                    stepDescription: _currentDescription,
                  ),
                  Expanded(
                    child: _pages[_currentStep],
                  ),
                  if (_shipmentStatus == 'waiting_approval')
                    _buildCancelAuctionButton(),
                  if (_shipmentStatus == 'auction_started' && !paymentConfirmed)
                    _buildContinuePaymentButton(),
                  if (_shipmentStatus == 'completed')
                    _buildConfirmationButton(),
                ],
              ),
      ),
    );
  }
}

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> stepLabels;
  final String stepDescription; // Changed from List<String>

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.stepLabels,
    required this.stepDescription,
  });

  @override
  Widget build(BuildContext context) {
    const Color activeColor = Color(0xFFFFC107);
    const Color inactiveColor = Colors.grey;
    final int totalSteps = stepLabels.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label besar di atas
          Text(
            stepDescription,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 24),

          // Baris indikator dan garis
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(totalSteps * 2 - 1, (index) {
                  if (index.isOdd) {
                    // Garis antar titik
                    int lineIndex = (index - 1) ~/ 2;
                    bool passed = lineIndex < currentStep;
                    return Expanded(
                      child: Container(
                        height: 2,
                        color: passed
                            ? activeColor
                            // ignore: deprecated_member_use
                            : inactiveColor.withOpacity(0.3),
                      ),
                    );
                  } else {
                    // Titik step
                    int stepIndex = index ~/ 2;
                    bool isCompleted = stepIndex <= currentStep;

                    return Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isCompleted ? activeColor : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCompleted ? activeColor : inactiveColor,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(Icons.check,
                                size: 16, color: Colors.white)
                            : null,
                      ),
                    );
                  }
                }),
              ),
              const SizedBox(height: 8),
              // Label di bawah titik
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: stepLabels
                    .map((label) => SizedBox(
                          width: 70,
                          child: Text(
                            label,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ))
                    .toList(),
              )
            ],
          ),
        ],
      ),
    );
  }
}
