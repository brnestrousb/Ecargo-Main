import 'package:ecarrgo/core/constant/colors.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/auction_payment/widgets/driver_offer_card.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/auction_payment/widgets/payment_success.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/preparation/widgets/history_widget.dart';
import 'package:ecarrgo/core/features/customer/presentation/widgets/custom_tab_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/widgets/confirm_pickup_destination_dialog.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/widgets/timeline_step.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/preparation/widgets/auction_details_page.dart';
import 'package:logger/logger.dart';

class AuctionPaymentPage extends StatefulWidget {
  final Map<String, dynamic>? auctionData;
  final Map<String, dynamic>? myBids;
  final int auctionId; // Tambahkan ini
  final int shipmentId;
  final bool paymentConfirmed;
  final String timestampStatus;
  final Function(bool hasSelectedDriver)? onDriverSelected; // Tambahkan ini
  final String status;
  final bool hasSelectedVendor;
  final Function(int vendorId)? onVendorSelected;

  const AuctionPaymentPage(
      {super.key,
      required this.paymentConfirmed,
      required this.auctionData,
      this.myBids,
      required this.auctionId,
      required this.shipmentId,
      required this.timestampStatus,
      this.onDriverSelected,
      required this.hasSelectedVendor,
      this.onVendorSelected,
      required this.status});

  @override
  State<AuctionPaymentPage> createState() => _AuctionPaymentPageState();
}

class _AuctionPaymentPageState extends State<AuctionPaymentPage> {
  String selectedTab = 'Terendah';
  final List<String> tabs = ['Terendah', 'Tinggi', 'Terbaru'];
  Map<String, dynamic>? auctionData;
  final bool _hasSelectedVendor = false;
  int? selectedDriverIndex;
  int? selectedVendorId; // Tambahkan ini

  @override
  void initState() {
    super.initState();

    // Periksa apakah ada pembayaran dengan status "pending"
    final payments = widget.auctionData?['shipment']?['payments'] ?? [];
    if (payments is List && payments.isNotEmpty) {
      final pendingPayment = payments.firstWhere(
        (payment) => payment['status'] == 'pending',
        orElse: () => null,
      );

      if (pendingPayment != null) {
        // Cari driver berdasarkan user_id dari pembayaran
        final bids = widget.auctionData?['bids'] ?? [];
        final selectedBidIndex = bids.indexWhere(
          (bid) => bid['user_id'] == pendingPayment['user_id'],
        );

        if (selectedBidIndex != -1) {
          setState(() {
            selectedDriverIndex = selectedBidIndex;
          });
        }
      }
    }
  }

  void _handleDriverSelection(int? index, int? vendorId) {
    setState(() {
      selectedDriverIndex = index;
      selectedVendorId = vendorId; // Simpan vendorId yang dipilih
      widget.onDriverSelected?.call(index != null);
    });
  }

  @override
  Widget build(BuildContext context) {
    // final encoder = JsonEncoder.withIndent('  ');
    final auction = widget.auctionData;
    final String? expiresAtStr = auction?['expires_at'];
    Logger().i(widget.paymentConfirmed);
    DateTime? endDate;
    if (expiresAtStr != null) {
      try {
        endDate = DateTime.parse(expiresAtStr);
      } catch (_) {
        endDate = null;
      }
    }

    String getPickupAddress(Map<String, dynamic>? data) {
      if (data == null) return '-';
      try {
        return data['shipment']?['pickup_address'] ?? '-';
      } catch (e) {
        return '-';
      }
    }

    String getDeliveryAddress(Map<String, dynamic>? data) {
      if (data == null) return '-';
      try {
        return data['shipment']?['delivery_address'] ?? '-';
      } catch (e) {
        return '-';
      }
    }

    String getResiNumber(Map<String, dynamic>? auctionData) {
      if (auctionData == null) return 'No Resi';
      if (auctionData['shipment'] == null) return 'No Resi';
      return auctionData['shipment']['resi_number'] ?? 'No Resi';
    }

// Penggunaan:
    final resiNumber = getResiNumber(auction);

    final pickupAddress = getPickupAddress(auction);
    final deliveryAddress = getDeliveryAddress(auction);

    final String formattedDate =
        endDate != null ? DateFormat('dd/MM/yyyy').format(endDate) : '-';
    final String formattedTime =
        endDate != null ? DateFormat('HH:mm').format(endDate) : '-';

    bool isPaymentPending() {
      final payments = widget.auctionData?['shipment']?['payments'] ?? [];
      if (payments is List && payments.isNotEmpty) {
        final pendingPayment = payments.firstWhere(
          (payment) => payment['status'] == 'pending',
          orElse: () => null,
        );
        return pendingPayment != null;
      }
      return false;
    }

    // Optional: Hitung waktu mundur
    final Duration remaining =
        endDate != null ? endDate.difference(DateTime.now()) : const Duration();
    final int days = remaining.inDays;
    final int hours = remaining.inHours.remainder(24);
    final int minutes = remaining.inMinutes.remainder(60);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (widget.paymentConfirmed && isPaymentPending())
                ? PaymentSuccessPage()
                : Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                          ),
                          child: SvgPicture.asset(
                            'assets/images/icons/started_lelang_icon.svg',
                            width: 48,
                            height: 48,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Lelang Dimulai",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _CountdownItem(
                                label: 'Hari',
                                value: days.toString().padLeft(2, '0')),
                            _CountdownItem(
                                label: 'Jam',
                                value: hours.toString().padLeft(2, '0')),
                            _CountdownItem(
                                label: 'Menit',
                                value: minutes.toString().padLeft(2, '0')),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text("Lelang berakhir pada:"),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.date_range, size: 20),
                                const SizedBox(width: 4),
                                Text(formattedDate),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 20),
                                const SizedBox(width: 4),
                                Text(formattedTime),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            const SizedBox(height: 24),
            const Text(
              "Pilih harga yang paling sesuai menurut anda dibawah ini",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            CustomTabNavigation(
              tabs: tabs,
              selectedTab: selectedTab,
              onTabSelected: (tab) {
                setState(() => selectedTab = tab);
              },
            ),
            const SizedBox(height: 16),
            Column(
              children: List.generate(widget.auctionData?['bids']?.length ?? 0,
                  (index) {
                final bid = widget.auctionData?['bids'][index];

                final int bidAmount = bid?['bid_amount'] ?? 0;
                final String vendorName = bid?['user']?['name'] ?? 'Vendor';
                final String auctionDuration =
                    bid?['auction_duration'] ?? '1 jam';
                final String vendorCompany =
                    bid?['user']?['company'] ?? 'Unknown';
                final String priceFormatted =
                    'Rp ${NumberFormat("#,##0", "id_ID").format(bidAmount)}';
                final vendorId = bid?['user']?['id'];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DriverOfferCard(
                    driverName: vendorName,
                    rating: 5.0,
                    eta: auctionDuration,
                    price: priceFormatted,
                    vendorLevel: vendorCompany,
                    isSelected: selectedDriverIndex == index,
                    isConfirmed:
                        widget.paymentConfirmed && selectedDriverIndex == index,
                    onSelect: () {
                      if (!widget.paymentConfirmed) {
                        if (selectedDriverIndex == index) {
                          _handleDriverSelection(null, null);
                          widget.onVendorSelected
                              ?.call(0); // Reset vendor di parent
                        } else {
                          _handleDriverSelection(index, vendorId);
                          widget.onVendorSelected
                              ?.call(vendorId); // Kirim vendorId ke parent
                        }
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.grey.shade700, // Teks abu-abu
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: const Text("Lihat Semua"),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "Butuh bantuan?",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Tombol WhatsApp - Hijau dengan ikon
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF439D6A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: SvgPicture.asset(
                      'assets/images/icons/wa_icon.svg', // ✅ icon baru
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: const Text("WhatsApp"),
                  ),
                ),
                const SizedBox(width: 12),

                // Tombol Buat Tiket - Outline tanpa ikon
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      foregroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Buat Tiket Bantuan"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(height: 12, color: Colors.grey[200]),
            const SizedBox(height: 24),
            ConfirmPickupDestinationDialog(
              pickupAddress: pickupAddress,
              destinationAddress: deliveryAddress,
              onEditPickup: () {},
              onEditDestination: () {},
              onConfirmed: () {},
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: SelectableText(
                    'Resi: $resiNumber',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: resiNumber));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Resi disalin')),
                    );
                  },
                  icon: const Icon(Icons.copy, size: 20),
                  tooltip: 'Salin Resi',
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AuctionDetailsPage(
                          auctionId:
                              widget.auctionId, // Add this required parameter
                          shipmentId: widget.shipmentId, // Add if needed
                          readonly: false,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.darkBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: const Text("Rincian"),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(height: 12, color: Colors.grey[200]),
            const SizedBox(height: 24),
            HistoryWidget(
              history: [
                {
                  'status': widget.status,
                  'timestamp': widget.timestampStatus,
                },
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _CountdownItem extends StatelessWidget {
  final String label;
  final String value;

  const _CountdownItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
