import 'dart:convert';

import 'package:ecarrgo/core/constant/colors.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/auction_payment/widgets/payment_success.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/preparation/widgets/auction_details_page.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/preparation/widgets/history_widget.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/widgets/confirm_pickup_destination_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';

class EnRoutePage extends StatefulWidget {
  final int auctionId;
  final int shipmentId;
  final String status;
  final Map<String, dynamic>? auctionData;
  final String pickupAddress;
  final String destinationAddress;
  final String resiNumber;
  final Map<String, dynamic>? historyData;

  const EnRoutePage({
    super.key,
    required this.auctionId,
    required this.shipmentId,
    required this.status,
    required this.auctionData,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.resiNumber,
    this.historyData,
  });

  @override
  State<EnRoutePage> createState() => _EnRoutePageState();
}

class _EnRoutePageState extends State<EnRoutePage> {
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

  @override
  Widget build(BuildContext context) {
    final historyList = widget.historyData?['history'] as List<dynamic>? ?? [];
    final encoder = JsonEncoder.withIndent('  ');
    Logger().d('auctionData: ${encoder.convert(widget.auctionData)}');

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Truck icon center
            Container(
              margin: const EdgeInsets.symmetric(vertical: 24),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE0E0E0),
              ),
              padding: const EdgeInsets.all(24),
              child: SvgPicture.asset(
                'assets/images/icons/truck_icon.svg',
                width: 64,
                height: 64,
              ),
            ),

            (isPaymentPending())
                ? PaymentSuccessPage(
                    shipmentData: widget.auctionData?['shipment'],
                  )
                : // Info Pengiriman Button
                Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      title: const Text('Info Pengiriman'),
                      subtitle: Text('Nomor Resi: ${widget.resiNumber}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                  ),

            const SizedBox(height: 16),

            // Vendor Button
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Vendor:',
                            style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(
                          widget.auctionData?['vendor']?['name'] ??
                              'Belum ada vendor',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.phone),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.message),
                  ),
                ],
              ),
            ),

            // Riwayat dan Timeline
            HistoryWidget(
              history:
                  (widget.historyData?['data'] as List<dynamic>?)?.map((entry) {
                        return {
                          'status':
                              (entry['status'] ?? 'Tidak diketahui').toString(),
                          'timestamp': (entry['changed_at'] ??
                                  DateTime.now().toIso8601String())
                              .toString(),
                        };
                      }).toList() ??
                      [],
            ),

            const SizedBox(height: 32),

            // Butuh Bantuan section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Butuh bantuan?",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
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
                      'assets/images/icons/wa_icon.svg',
                      width: 20,
                      height: 20,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    label: const Text("WhatsApp"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
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
            const SizedBox(height: 32),

            // Confirm Pickup Destination Widget
            ConfirmPickupDestinationDialog(
              pickupAddress: widget.pickupAddress,
              destinationAddress: widget.destinationAddress,
              onEditPickup: () {},
              onEditDestination: () {},
              onConfirmed: () {},
            ),

            const SizedBox(height: 32),

            // Shipment ID and Rincian button
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: SelectableText(
                          'ID Kirim: ${widget.resiNumber}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: widget.shipmentId.toString()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('ID Kirim disalin')),
                          );
                        },
                        icon: const Icon(Icons.copy, size: 20),
                        tooltip: 'Salin ID',
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AuctionDetailsPage(
                          auctionId: widget.auctionId,
                          shipmentId: widget.shipmentId,
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
          ],
        ),
      ),
    );
  }
}
