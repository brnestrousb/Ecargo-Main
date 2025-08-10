import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/preparation/widgets/auction_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderArrivedPage extends StatefulWidget {
  final int auctionId;
  final int shipmentId;
  final String status;
  final Map<String, dynamic>? auctionData;
  final String pickupAddress;
  final String destinationAddress;
  final String resiNumber;
  final Map<String, dynamic>? historyData;

  const OrderArrivedPage({
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
  State<OrderArrivedPage> createState() => _OrderArrivedPageState();
}

class _OrderArrivedPageState extends State<OrderArrivedPage> {
  int selectedRating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Icon truk
            Container(
              margin: const EdgeInsets.symmetric(vertical: 24),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE0E0E0),
              ),
              padding: const EdgeInsets.all(24),
              child: SvgPicture.asset(
                'assets/images/icons/arrive_icon.svg',
                width: 64,
                height: 64,
              ),
            ),

            // Info Pengiriman
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: const Text('Info Pengiriman'),
                subtitle: Text('Nomor Resi: ${widget.resiNumber}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ),

            // Vendor Card + Rating
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          widget.auctionData?['vendor']?['avatar'] != null
                              ? 'https://yourdomain.com/${widget.auctionData?['vendor']?['avatar']}'
                              : 'https://i.pravatar.cc/150?img=3',
                        ),
                        radius: 24,
                      ),
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
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
                  const SizedBox(height: 16),

                  // Beri Penilaian (interaktif)
                  // const Text(
                  //   'Beri Penilaian Anda',
                  //   style: TextStyle(fontWeight: FontWeight.w600),
                  // ),
                  // const SizedBox(height: 8),
                  // Row(
                  //   children: List.generate(5, (index) {
                  //     final isSelected = index < selectedRating;
                  //     return IconButton(
                  //       onPressed: () {
                  //         setState(() {
                  //           selectedRating = index + 1;
                  //         });
                  //       },
                  //       icon: Icon(
                  //         isSelected ? Icons.star : Icons.star_border,
                  //         color: Colors.amber,
                  //       ),
                  //     );
                  //   }),
                  // ),
                ],
              ),
            ),

            // Butuh bantuan
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Butuh bantuan?",
                  style: TextStyle(fontWeight: FontWeight.w600)),
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
                          borderRadius: BorderRadius.circular(16)),
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
                          borderRadius: BorderRadius.circular(16)),
                      foregroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Buat Tiket Bantuan"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // ID Kirim dan Rincian
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
                              ClipboardData(text: widget.resiNumber));
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
                    backgroundColor: const Color(0xFF003366),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: const Text("Rincian"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
