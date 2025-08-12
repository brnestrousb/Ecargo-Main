import 'package:ecarrgo/core/constant/colors.dart';
import 'package:ecarrgo/core/features/customer/activity/presentation/widgets/activity_item_card.dart';
import 'package:fl_chart/fl_chart.dart';
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
                          InkWell(
                            onTap: () {
                              // Navigasi ke halaman semua aktivitas
                            },
                            child: Row(
                              children: [
                                const Text(
                                  'Lihat Semua',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white70,
                                  ),
                                ),
                                SvgPicture.asset(
                                    'assets/images/vendor/lihat.svg',
                                    fit: BoxFit.contain,
                                    width: 16,
                                    height: 16)
                              ],
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
                            horizontal: 12, vertical: 12),
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
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Bagian atas: 4 kotak

                              GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                childAspectRatio: 2.5,
                                children: [
                                  _buildTopItem(
                                      icon:
                                          "assets/images/vendor/level_silver.svg",
                                      title: "Level Saya",
                                      subtitle: "Vendor Silver",
                                      progress: null,
                                      dividerPosition: 0.7,
                                      onTap: () {} //Level Vendor
                                      ),
                                  _buildTopItem(
                                      title: "Paket berhasil terkirim",
                                      subtitle: "294",
                                      progress: 0.75,
                                      dividerPosition: 0.7),
                                  _buildTopItem(
                                      title: "Rating",
                                      subtitle: "4.9",
                                      progress: 0.85,
                                      dividerPosition: 0.7),
                                  _buildTopItem(
                                      title: "Penghasilan",
                                      subtitle: "Rp. 489.281.500",
                                      progress: 0.5,
                                      dividerPosition: 0.7),
                                ],
                              ),
                              const Divider(),
                              // Bagian bawah: 2 baris data
                              _buildBottomRow("Pengiriman", "293/", "300"),
                              const Divider(),
                              _buildBottomRow(
                                  "Total ikut lelang", "384/", "200"),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Penghasilan',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                    width: 320), //Jarak Penghasilan ke Detail
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: Text(
                                        'Detail',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF01518D),
                                            fontFeatures: const [
                                              FontFeature.liningFigures()
                                            ],
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor:
                                                const Color(0xFF01518D)),
                                      ),
                                    ),
                                    SvgPicture.asset(
                                        'assets/images/vendor/detail.svg',
                                        fit: BoxFit.contain,
                                        width: 16,
                                        height: 16)
                                  ],
                                ),
                              ],
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
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Total',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w900)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text('Bulan Ini',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w900)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  //const Divider(height: 24),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text('Rp 25.000.000',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text('Rp 7.500.000',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // const Divider(),
                                  const SizedBox(height: 24),
                                  Column(
                                    children: [
                                      Container(
                                        height: 150,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: LineChart(
                                          LineChartData(
                                            gridData: FlGridData(show: false),
                                            titlesData: FlTitlesData(
                                              leftTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: true,
                                                  reservedSize: 50,
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    final styles =
                                                        const TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    );
                                                    // Format angka ke dalam format ribuan
                                                    if (value == 0) {
                                                      return Text('0',
                                                          style: styles);
                                                    }
                                                    if (value >= 1000) {
                                                      return Text(
                                                          '${value.roundToDouble()}',
                                                          style: styles);
                                                    } else if (value >= 100) {
                                                      return Text(
                                                          '${value.roundToDouble()}',
                                                          style: styles);
                                                    }
                                                    return Text(
                                                        value.toString());
                                                  },
                                                ),
                                              ),
                                              rightTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                      showTitles: false)),
                                              topTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                      showTitles: false)),
                                              bottomTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: true,
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    final int years = 2025;
                                                    final styles =
                                                        const TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    );
                                                    // Contoh format tanggal
                                                    switch (value.toInt()) {
                                                      case 0:
                                                        return Column(
                                                          children: [
                                                            Text('15 Jan',
                                                                style: styles),
                                                            Text(
                                                                years
                                                                    .toString(),
                                                                style: styles),
                                                          ],
                                                        );
                                                      case 1:
                                                        return Column(
                                                          children: [
                                                            Text('17 Feb',
                                                                style: styles),
                                                            Text(
                                                                years
                                                                    .toString(),
                                                                style: styles),
                                                          ],
                                                        );
                                                      case 2:
                                                        return Column(
                                                          children: [
                                                            Text('16 Mar',
                                                                style: styles),
                                                            Text(
                                                                years
                                                                    .toString(),
                                                                style: styles),
                                                          ],
                                                        );
                                                      case 3:
                                                        return Column(
                                                          children: [
                                                            Text('15 Apr',
                                                                style: styles),
                                                            Text(
                                                                years
                                                                    .toString(),
                                                                style: styles),
                                                          ],
                                                        );
                                                      case 4:
                                                        return Column(
                                                          children: [
                                                            Text('17 May',
                                                                style: styles),
                                                            Text(
                                                                years
                                                                    .toString(),
                                                                style: styles),
                                                          ],
                                                        );
                                                    }
                                                    return const SizedBox
                                                        .shrink();
                                                  },
                                                ),
                                              ),
                                            ),
                                            borderData:
                                                FlBorderData(show: false),
                                            lineBarsData: [
                                              LineChartBarData(
                                                spots: const [
                                                  FlSpot(0, 300000),
                                                  FlSpot(1, 250000),
                                                  FlSpot(2, 200000),
                                                  FlSpot(3, 150000),
                                                  FlSpot(4, 300000),
                                                ],
                                                isCurved: true,
                                                color: const Color(
                                                    0xFF1565C0), // warna garis biru
                                                barWidth: 2,
                                                isStrokeCapRound: true,
                                                belowBarData: BarAreaData(
                                                  show: true,
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      const Color(0xFF1565C0)
                                                          // ignore: deprecated_member_use
                                                          .withOpacity(0.3),
                                                      const Color(0xFF1565C0)
                                                          // ignore: deprecated_member_use
                                                          .withOpacity(0.0),
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                  ),
                                                ),
                                                dotData: FlDotData(show: true),
                                              ),
                                            ],
                                            minY: 0,
                                          ),
                                        ),
                                      ),
                                    ],
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

  Widget _buildTopItem({
    final String? icon,
    final VoidCallback? onTap,
    required String title,
    required String subtitle,
    double? progress,
    required double dividerPosition,
  }) {
    return Padding(
      padding: const EdgeInsets.all(1.0), // kecilkan padding
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[SvgPicture.asset(icon)],
          const SizedBox(height: 3),
          Flexible(
            child: Text(title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          Flexible(
            child: Text(
              subtitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 3),
          if (progress != null) ...[
            const SizedBox(height: 2),
            Flexible(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final totalWidth = constraints.maxWidth;
                  final progressWidth = totalWidth * progress;
                  final dividerX = totalWidth * dividerPosition;

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        // Background
                        Container(
                          height: 12,
                          //width: progressWidth,
                          color: const Color(0xFFE8EEF4),
                        ),
                        // Progress
                        Container(
                          height: 12,
                          width: progressWidth,
                          color: const Color(0xFF59C788),
                        ),
                        // Divider diagonal
                        Positioned(
                          left: dividerX - 1,
                          top: 0,
                          bottom: 0,
                          child: Transform.rotate(
                            angle: 0.0, // rotasi miring
                            child: Container(
                              width: 3,
                              color: const Color(0xFF0B67AE),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomRow(String label, String value1, String value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(value1, style: const TextStyle(fontWeight: FontWeight.w900)),
              Text(value2,
                  style: const TextStyle(fontWeight: FontWeight.normal)),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildProgress(String title, double value, double max, Color color) {
  //   double percent = (value / max).clamp(0.0, 1.0);
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 12),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //             '$title (${value.toStringAsFixed(1)}/${max.toStringAsFixed(1)})'),
  //         const SizedBox(height: 4),
  //         LinearProgressIndicator(
  //           value: percent,
  //           backgroundColor: Colors.grey[300],
  //           color: color,
  //           minHeight: 8,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildStatLine(String title, int current, int total) {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 8),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(title),
  //         Text('$current / $total',
  //             style: const TextStyle(fontWeight: FontWeight.bold)),
  //       ],
  //     ),
  //   );
  // }
}
