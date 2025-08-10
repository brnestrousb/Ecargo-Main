import 'package:ecarrgo/core/constant/colors.dart';
import 'package:ecarrgo/core/features/customer/activity/presentation/widgets/activity_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  final PageController _pageController = PageController(
    initialPage: 1000000 ~/ 2,
    viewportFraction: 0.82,
  );

  final List<String> bgAssets = [
    'assets/images/slider_home/bg1.png',
    'assets/images/slider_home/bg2.png',
  ];

  // Data dummy aktivitas
  final List<Map<String, dynamic>> activityData = [
    {
      'date': '2025-06-24',
      'price': 25000,
      'category': 'Dalam Kota',
      'status': 'Dalam Proses',
      'address': 'Binus University, Anggrek Campus',
      'resi': 'RESI12345678'
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background layer
            Stack(
              children: [
                Container(
                  height: 400,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF01518D),
                        Color(0xFF008CC8),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 50,
                  child: SvgPicture.asset(
                    'assets/images/vector/line-ecarrgo-home-mobile.svg',
                    width: 150,
                    height: 150,
                  ),
                ),
              ],
            ),

            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 75),
                SizedBox(
                  height: 50,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Positioned(
                        top: 0,
                        left: 18,
                        child: Image.asset(
                          'assets/images/logo/ECarrgo_Company_Profile-White.png',
                          width: 108,
                          height: 14,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Aktivitas Terakhir',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigasi ke halaman semua aktivitas
                            },
                            child: const Text(
                              'Lihat Semua',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: activityData.map((data) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: ActivityItemCard(
                              item: activityData.first,
                              currencyFormatter: NumberFormat.currency(
                                  locale: 'id_ID', symbol: 'Rp '),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.offWhite2,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Tambahan Container 1: Level Saya
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Level Saya',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              _buildProgress(
                                  'Berhasil Kirim', 120, 150, Colors.blue),
                              _buildProgress('Rating', 4.5, 5.0, Colors.green),
                              _buildProgress('Penghasilan', 7500000, 10000000,
                                  Colors.orange),
                              const SizedBox(height: 12),
                              _buildStatLine('Total Pengiriman', 209, 300),
                              _buildStatLine('Total Ikut Lelang', 120, 200),
                            ],
                          ),
                        ),
                      ),
                      // Tambahan Container 2: Penghasilan
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Penghasilan',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    // ignore: deprecated_member_use
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text('Total',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text('Rp 25.000.000'),
                                    ],
                                  ),
                                  const Divider(height: 24),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text('Bulan Ini',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text('Rp 7.500.000'),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    height: 150,
                                    color:
                                        Colors.grey[200], // Placeholder grafik
                                    alignment: Alignment.center,
                                    child: const Text('Grafik per Tanggal'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgress(String title, double value, double max, Color color) {
    double percent = (value / max).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              '$title (${value.toStringAsFixed(1)}/${max.toStringAsFixed(1)})'),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.grey[300],
            color: color,
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildStatLine(String title, int current, int total) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text('$current / $total',
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
