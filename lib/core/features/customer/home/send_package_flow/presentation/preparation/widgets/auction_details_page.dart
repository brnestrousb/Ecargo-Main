import 'package:dio/dio.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step1/address_input_group_with_dots.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step1/delivery_date_time_selector.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step1/step_title.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step2/item_detail_inputs.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step2/item_type_selector.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step3/dash_border_painter.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step3/shipping_package_card.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step4/price_input_field.dart';
import 'package:ecarrgo/core/network/api_constants.dart';
import 'package:ecarrgo/core/network/storage/secure_storage_service.dart';
import 'package:ecarrgo/core/providers/fill_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

class AuctionDetailsPage extends StatefulWidget {
  final bool readonly;
  final int auctionId;
  final int shipmentId;
  const AuctionDetailsPage(
      {super.key,
      this.readonly = true,
      required this.auctionId,
      required this.shipmentId});

  @override
  State<AuctionDetailsPage> createState() => _AuctionDetailsPageState();
}

class ProtectionOptionCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String description;
  final String price;
  final bool selected;
  final bool readOnly;

  const ProtectionOptionCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.description,
    required this.price,
    this.selected = false,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: selected ? Colors.blue : Colors.grey.shade300,
          width: selected ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildNoProtectionSelected() {
  return Stack(
    children: [
      CustomPaint(
        painter: DashedBorderPainter(
          color: Colors.grey.shade300,
          borderRadius: 12,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/icons/proteksi_icon.svg',
                width: 48,
                height: 48,
              ),
              const SizedBox(height: 12),
              const Text(
                'Tidak ada proteksi dipilih',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class _AuctionDetailsPageState extends State<AuctionDetailsPage> {
  late TextEditingController weightController;
  late TextEditingController valueController;
  late TextEditingController dimensionController;
  late TextEditingController descriptionController;

  late TextEditingController _startingPriceController;

  final logger = Logger();
  final Dio _dio = Dio(BaseOptions(
    baseUrl: '${ApiConstants.baseUrl}/api/v1',
    connectTimeout: const Duration(seconds: 30),
  ));

  int? _auctionDurationValue;
  String? _auctionDurationUnit;
  DateTime? _deliveryDateTime;
  String? _protectionName; // Hanya menyimpan nama proteksi

  Map<String, dynamic>? _shipmentData;
  bool _isLoading = false;
  String? _errorMessage;

  String _getProtectionIcon(String protectionName) {
    switch (protectionName.toLowerCase()) {
      case 'blue protection':
        return 'assets/images/icons/protection/blue_protection_icon.svg';
      case 'gold protection':
        return 'assets/images/icons/protection/gold_protection_icon.svg';
      case 'silver protection':
        return 'assets/images/icons/protection/silver_protection_icon.svg';
      default:
        return 'assets/images/icons/proteksi_icon.svg';
    }
  }

  String _getProtectionDescription(String protectionName) {
    switch (protectionName.toLowerCase()) {
      case 'blue protection':
        return 'Proteksi dasar untuk kerusakan kecil';
      case 'gold protection':
        return 'Proteksi menengah termasuk kehilangan parsial';
      case 'platinum protection':
        return 'Proteksi lengkap untuk semua risiko';
      default:
        return 'Paket proteksi standar';
    }
  }

  String _getProtectionPrice(String protectionName) {
    switch (protectionName.toLowerCase()) {
      case 'blue protection':
        return 'Rp 50.000';
      case 'gold protection':
        return 'Rp 100.000';
      case 'platinum protection':
        return 'Rp 200.000';
      default:
        return 'Rp 0';
    }
  }

  String _getShippingTypeIcon(String? shippingType) {
    if (shippingType == null) {
      return 'assets/images/icons/default_shipping_icon.svg';
    }

    final type = shippingType.toLowerCase();

    if (type.contains('ekspres')) {
      return 'assets/images/icons/dalam_kota_icon.svg';
    } else if (type.contains('reguler')) {
      return 'assets/images/icons/regular_icon.svg';
    } else if (type.contains('hemat')) {
      return 'assets/images/icons/hemat_icon.svg'; // Asumsikan ada asset ini
    }

    return 'assets/images/icons/default_shipping_icon.svg';
  }

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    weightController = TextEditingController();
    valueController = TextEditingController();
    dimensionController = TextEditingController();
    descriptionController = TextEditingController();
    _startingPriceController = TextEditingController();

    // Load shipment data
    _loadShipmentData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<FillDataProvider>();
      provider.auctionDurationUnit = 'jam';
    });
  }

  Future<void> _loadShipmentData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _dio.get(
        '/auctions/${widget.auctionId}',
        options: Options(headers: {
          'Authorization': 'Bearer ${await SecureStorageService().getToken()}'
        }),
      );

      if (mounted) {
        if (response.statusCode == 200 && response.data['success'] == true) {
          final data = response.data['data'] ?? response.data;

          // Ekstrak data durasi lelang dari API
          final auction = data['data'] ?? data;
          final auctionDuration = auction['auction_duration'] as String?;

          // Parsing durasi lelang (contoh format: "12 Jam")
          if (auctionDuration != null) {
            final parts = auctionDuration.split(' ');
            if (parts.length >= 2) {
              _auctionDurationValue = int.tryParse(parts[0]);
              _auctionDurationUnit = parts[1];
            }
          }

          // Simpan data pengiriman
          final shipment = auction['shipment'] ?? {};
          if (shipment['delivery_datetime'] != null) {
            _deliveryDateTime = DateTime.parse(shipment['delivery_datetime']);
          }

          // Tambahkan delay sebelum menampilkan data
          await Future.delayed(const Duration(milliseconds: 500));

          setState(() {
            _shipmentData = data;
            _protectionName = shipment['protection'];
          });
        } else {
          throw Exception('Invalid response: ${response.statusCode}');
        }
      }
    } on DioException catch (e) {
      logger.e("Error loading shipment data: ${e.message}");
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal memuat data: ${e.message}';
        });
      }
    } catch (e) {
      logger.e("Unexpected error: $e");
      if (mounted) {
        setState(() {
          _errorMessage = 'Terjadi kesalahan';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // _fillData.removeListener(_updateControllersFromProvider);

    weightController.dispose();
    valueController.dispose();
    dimensionController.dispose();
    descriptionController.dispose();
    _startingPriceController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage!),
              ElevatedButton(
                onPressed: _loadShipmentData,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (_shipmentData == null) {
      return const Center(child: Text('Data pengiriman tidak tersedia'));
    }

    // Extract data from API response
    final auction = _shipmentData?['data'] ?? _shipmentData;
    final shipment = auction?['shipment'] ?? {};
    final originCity = shipment['originCity'] ?? {};
    final destinationCity = shipment['destinationCity'] ?? {};

    // Format delivery datetime
    final deliveryDateTime = shipment['delivery_datetime'] != null
        ? DateTime.parse(shipment['delivery_datetime'])
        : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Detail Lelang Pengiriman",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // kembali ke halaman sebelumnya
          },
        ),
      ),
      body: IgnorePointer(
        ignoring: widget.readonly,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step 1 - Alamat
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const StepTitle(title: "Rute Pengiriman"),
                      const SizedBox(height: 16),
                      AddressInputGroupWithDots(
                        pickupTitle: "${originCity['name']}",
                        pickupDetail: "${shipment['pickup_address']}",
                        destinationTitle: "${destinationCity['name']}",
                        destinationDetail: "${shipment['delivery_address']}",
                        onEditPickup: null,
                        onEditDestination: null,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                // Separator
                Container(height: 10, color: Colors.grey[200]),
                const SizedBox(height: 24),

                // Step 2 - Tanggal Pengiriman
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const StepTitle(title: "Tanggal Pengiriman"),
                      const SizedBox(height: 16),
                      DeliveryDateTimeSelector(
                        selectedDate: deliveryDateTime,
                        selectedTime: deliveryDateTime != null
                            ? TimeOfDay.fromDateTime(deliveryDateTime)
                            : null,
                        onDateSelected: null,
                        onTimeSelected: null,
                        readOnly: true,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                // Separator
                Container(height: 10, color: Colors.grey[200]),
                const SizedBox(height: 24),

                // Step 3 - Jenis dan Detail Barang
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const StepTitle(title: "Jenis Barang"),
                      const SizedBox(height: 16),
                      ItemTypesSelector(
                        selectedTypes: [shipment['item_types'] ?? ''],
                        readOnly: true,
                        onItemTypesSelected: (_) {},
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                // Separator
                Container(height: 10, color: Colors.grey[200]),
                const SizedBox(height: 24),

                // Step 4 - Detail Barang
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const StepTitle(title: "Detail Barang"),
                      const SizedBox(height: 16),
                      ItemDetailInputs(
                        readOnly: true,
                        weightController: TextEditingController(
                            text: "${shipment['item_weight_ton']}"),
                        valueController: TextEditingController(
                            text: "${shipment['item_value_rp']}"),
                        dimensionController: TextEditingController(
                            text: "${shipment['item_volume_m3']}"),
                        descriptionController: TextEditingController(
                            text: "${shipment['item_description']}"),
                        onChanged: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Separator
                Container(height: 10, color: Colors.grey[200]),
                const SizedBox(height: 24),

                // Step 5 - Shipping card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const StepTitle(title: "Paket Pengiriman"),
                      const SizedBox(height: 16),
                      ShippingPackageCard(
                        svgIconPath: _getShippingTypeIcon(
                            shipment['shipping_type']), // Use a helper function
                        title: "${shipment['shipping_type']}",
                        method: "Express Delivery",
                        description: "Pengiriman cepat dalam 1-2 hari",
                        timeEstimate: "1-2 Hari",
                        priceEstimate:
                            "Rp ${auction?['auction_starting_price']}",
                        selected: true,
                        readOnly: true,
                      )
                    ],
                  ),
                ),

                // Protection Options Section
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const StepTitle(title: 'Paket Proteksi'),
                      const SizedBox(height: 12),

                      // Tampilkan proteksi yang dipilih
                      if (_protectionName != null)
                        ProtectionOptionCard(
                          iconPath: _getProtectionIcon(_protectionName!),
                          title: _protectionName!,
                          description:
                              _getProtectionDescription(_protectionName!),
                          price: _getProtectionPrice(_protectionName!),
                          selected: true,
                          readOnly: widget.readonly,
                        )
                      else
                        _buildNoProtectionSelected(),
                    ],
                  ),
                ),

                // Separator
                Container(height: 10, color: Colors.grey[200]),
                const SizedBox(height: 24),

                // STEP 6 - Pengaturan Lelang
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const StepTitle(title: 'Pengaturan Lelang'),
                      const SizedBox(height: 12),
                      PriceInputField(
                        controller: TextEditingController(
                            text: "${auction?['auction_starting_price']}"),
                        label: 'Harga Awal',
                        hintText: 'Masukkan harga',
                        readOnly: true,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            'Durasi Lelang:',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_auctionDurationValue ?? '-'} ${_auctionDurationUnit ?? '-'}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Final separator
                Container(height: 10, color: Colors.grey[200]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    // Konten utama halaman
    final auction = _shipmentData?['data'] ?? _shipmentData;
    final shipment = auction?['shipment'] ?? {};
    final originCity = shipment['originCity'] ?? {};
    final destinationCity = shipment['destinationCity'] ?? {};

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step 1 - Alamat
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StepTitle(title: "Rute Pengiriman"),
                const SizedBox(height: 16),
                AddressInputGroupWithDots(
                  pickupTitle: "${originCity['name']}",
                  pickupDetail: "${shipment['pickup_address']}",
                  destinationTitle: "${destinationCity['name']}",
                  destinationDetail: "${shipment['delivery_address']}",
                  onEditPickup: null,
                  onEditDestination: null,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          // Konten lainnya...
        ],
      ),
    );
  }
}
