import 'dart:ui';

import 'package:ecarrgo/core/constant/colors.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/destination/destination_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(
    initialPage: 1000000 ~/ 2,
    viewportFraction: 0.82,
  );

  final List<String> bgAssets = [
    'assets/images/slider_home/bg1.png',
    'assets/images/slider_home/bg2.png',
  ];

  // Data untuk carousel
  final List<Map<String, String>> carouselData = [
    {
      'slogan': 'Kirim barang lebih mudah dan cepat',
      'image': '🚚', // Ganti dengan path gambar/icon sebenarnya
    },
    {
      'slogan': 'Harga terbaik untuk pengiriman Anda',
      'image': '💰', // Ganti dengan path gambar/icon sebenarnya
    },
    {
      'slogan': 'Layanan pengiriman ke seluruh Indonesia',
      'image': '🇮🇩', // Ganti dengan path gambar/icon sebenarnya
    },
  ];

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Stack(
        children: [
          // Layer background biru gradasi fleksibel melebihi konten
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
                top: 60, // atur posisi SVG
                left: 50,
                child: SvgPicture.asset(
                  'assets/images/vector/line-ecarrgo-home-mobile.svg', // pastikan file SVG sudah ada di folder assets
                  width: 150,
                  height: 150,
                ),
              ),
            ],
          ),

          // Layer konten utama
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Carousel
                Column(
                  children: [
                    const SizedBox(height: 75), // Jarak dari atas layar

                    SizedBox(
                      height: 130,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          // Logo di atas, rata kiri
                          Positioned(
                            top: 0,
                            left: 18, // sejajarkan dengan carousel
                            child: Image.asset(
                              'assets/images/logo/ECarrgo_Company_Profile-White.png',
                              width: 108,
                              height: 14,
                              fit: BoxFit.contain,
                            ),
                          ),

                          // Carousel di bawah logo
                          Positioned(
                            top: 20,
                            left: 0,
                            right: 0,
                            height: 110,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount:
                                  1000000, // untuk simulasi infinite loop
                              itemBuilder: (context, index) {
                                final currentIndex =
                                    index % carouselData.length;

                                return Container(
                                  margin: const EdgeInsets.only(
                                    left: 0, // sejajar dengan logo
                                    right: 10,
                                    top: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      // Background Image
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(28),
                                        child: Image.asset(
                                          bgAssets[
                                              currentIndex % bgAssets.length],
                                          fit: BoxFit.cover,
                                        ),
                                      ),

                                      // Foreground content dibagi 2
                                      Row(
                                        children: [
                                          // Kiri (teks dengan background putih blur/transparan)
                                          Expanded(
                                            flex: 2,
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(28),
                                                bottomLeft: Radius.circular(28),
                                              ),
                                              child: Stack(
                                                children: [
                                                  // Blur background
                                                  BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 15.0,
                                                        sigmaY: 15.0),
                                                    child: Container(
                                                      // Warna putih semi-transparan
                                                      decoration: BoxDecoration(
                                                        color: Colors.white
                                                            // ignore: deprecated_member_use
                                                            .withOpacity(
                                                                0.3), // ini yg memberi warna putih tipis
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  28),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  28),
                                                        ),
                                                        border: Border.all(
                                                          color: Colors.white
                                                              // ignore: deprecated_member_use
                                                              .withOpacity(0.4),
                                                          width: 1.0,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12.0),
                                                          child: Text(
                                                            carouselData[
                                                                    currentIndex]
                                                                ['slogan']!,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black87,
                                                              shadows: [
                                                                Shadow(
                                                                  color: Colors
                                                                      .white24,
                                                                  offset:
                                                                      Offset(
                                                                          0, 1),
                                                                  blurRadius: 1,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          // Kanan (kosong, hanya background image terlihat)
                                          Expanded(
                                            flex: 2,
                                            child:
                                                Container(), // biarkan kosong, hanya untuk tampilan
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                        height: 16), // Jarak antara carousel dan indikator

                    // Dot indicator
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: carouselData.length,
                      effect: const WormEffect(
                        dotHeight: 10,
                        dotWidth: 10,
                        spacing: 8,
                        activeDotColor: Colors.blue,
                        dotColor: Colors.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24), // Tambah spasi dari atas layar

                // Kontainer utama dengan border radius
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
                      // Input Section
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  // ignore: deprecated_member_use
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const DestinationAddressScreen(),
                                    ),
                                  );
                                },
                                child: AbsorbPointer(
                                  child: TextField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      hintText:
                                          'Kemana Anda ingin mengirimkan barang?',
                                      hintStyle: const TextStyle(fontSize: 14),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: SvgPicture.asset(
                                          'assets/images/icons/destination_location_icon.svg',
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ),

                      // Button Options
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton.icon(
                                icon: Image.asset(
                                  'assets/images/icons/home_tambah_lokasi_icon.png',
                                  width: 24,
                                  height: 24,
                                ),
                                label: const Text(
                                  'Tambah Lokasi',
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextButton.icon(
                                icon: Image.asset(
                                  'assets/images/icons/home_lokasi_favorit_icon.png',
                                  width: 24,
                                  height: 24,
                                ),
                                label: const Text(
                                  'Lokasi Favorit',
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: const [
                            Expanded(
                              child: Divider(
                                height: 2,
                                thickness:
                                    0.5, // tambahkan ketebalan agar lebih jelas
                                color: Colors
                                    .grey, // warna bisa diatur sesuai keinginan
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Card List Section
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            ServiceCard(
                              imagePath:
                                  'assets/images/icons/dalam_kota_icon.svg',
                              title: 'Dalam Kota',
                              description:
                                  'Instant atau SameDay, waktu lebih cepat dan lebih banyak partisipan lelang.',
                            ),
                            ServiceCard(
                              imagePath:
                                  'assets/images/icons/luar_kota_icon.svg',
                              title: 'Antar Kota',
                              description:
                                  'Kirim barang ke luar kota. Banyak opsi dan harga dari lelang kami.',
                            ),
                          ],
                        ),
                      ),

                      // Jelajahi Lainnya Section
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Jelajahi lainnya',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 150,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.all(16),
                          children: [
                            ExploreCard(
                              text:
                                  "Lihat bagaimana kami bekerja untuk menjadi mitra terbaik Anda",
                              imagePath:
                                  'assets/images/jelajahi_images/bg1.png',
                            ),
                            const SizedBox(width: 10),
                            ExploreCard(
                              text: "Pelajari cara mendapatkan harga terbaik",
                              imagePath:
                                  'assets/images/jelajahi_images/bg2.png',
                            ),
                            const SizedBox(width: 10),
                            ExploreCard(
                              text: "Tips pengemasan barang yang aman",
                              imagePath:
                                  'assets/images/jelajahi_images/bg3.png',
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
      )),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const ServiceCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SvgPicture.asset(
            imagePath,
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
                  style: const TextStyle(
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}

class ExploreCard extends StatelessWidget {
  final String text;
  final String imagePath;

  const ExploreCard({
    super.key,
    required this.text,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.6),
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.2),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            // Text
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
