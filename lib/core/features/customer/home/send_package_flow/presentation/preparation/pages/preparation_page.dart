import 'package:ecarrgo/core/constant/colors.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/preparation/widgets/history_widget.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/widgets/confirm_pickup_destination_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/preparation/widgets/auction_details_page.dart';

class PreparationPage extends StatefulWidget {
  final int auctionId;
  final int shipmentId;
  final String status;
  final String pickupAddress;
  final String destinationAddress;
  final String resiNumber;
  final Map<String, dynamic>? historyData;

  const PreparationPage({
    super.key,
    required this.auctionId,
    required this.shipmentId,
    required this.status,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.resiNumber,
    this.historyData,
  });

  @override
  State<PreparationPage> createState() => _PreparationPageState();
}

class _PreparationPageState extends State<PreparationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Cancel any pending operations
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              child: SvgPicture.asset(
                'assets/images/icons/cs_icon.svg',
                width: 48,
                height: 48,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Kami akan segera menghubungi Anda.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "CS kami akan mengonfirmasi data pribadi dan pengiriman Anda. Siapkan dokumen sambil menunggu kami menghubungi.",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Text(
              "Butuh bantuan?",
              style: TextStyle(fontWeight: FontWeight.w600),
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
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
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
            const SizedBox(height: 24),
            ConfirmPickupDestinationDialog(
              pickupAddress: widget.pickupAddress,
              destinationAddress: widget.destinationAddress,
              onEditPickup: () {},
              onEditDestination: () {},
              onConfirmed: () {},
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: SelectableText(
                          'Resi: ${widget.resiNumber}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: widget.resiNumber));

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Resi disalin')),
                              );
                            }
                          });
                        },
                        icon: const Icon(Icons.copy, size: 20),
                        tooltip: 'Salin Resi',
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
            // Gunakan widget HistoryWidget
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
          ],
        ),
      ),
    );
  }
}
