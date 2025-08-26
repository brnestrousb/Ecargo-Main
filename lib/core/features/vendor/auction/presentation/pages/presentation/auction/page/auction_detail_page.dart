// ignore_for_file: must_be_immutable
import 'package:ecarrgo/core/features/vendor/auction/presentation/pages/model/auction/auction_model.dart';
import 'package:ecarrgo/core/features/vendor/auction/presentation/pages/presentation/auction/page/auction_list_page.dart';
import 'package:ecarrgo/core/features/vendor/auction/presentation/pages/presentation/auction/service/map_auction_service.dart';
import 'package:ecarrgo/core/features/vendor/auction/presentation/pages/presentation/auction/page/auction_map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

// ================== PAGE ==================
class AuctionDetailPage extends StatelessWidget {
  final MapAuctionService service = MapAuctionService();
  final currencyFormat = NumberFormat.currency(
    locale: "id",
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  AuctionDetailPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: FutureBuilder<AuctionDetail>(
          future: service.fetchAuctionDetail(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData) {
              return const Center(child: Text("Tidak ada data"));
            }

            final detail = snapshot.data!;

            return Column(
              children: [
                // ✅ AppBar custom tetap di atas
                PreferredSize(
                  preferredSize: const Size.fromHeight(200), // lebih tinggi
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: const Color(0xFF0168A4),
                    elevation: 0,
                    flexibleSpace: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Baris pertama: Back button + alamat
                            Row(
                              children: [
                                IconButton(
                                  icon: SvgPicture.asset(
                                    'assets/images/icons/arrow_back.svg',
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    detail.destinationAddress,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Card putih di bawah judul
                            Container(
                              width: double.maxFinite,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 3),
                              decoration: BoxDecoration(
                                // ignore: deprecated_member_use
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/vendor/blue_box.svg',
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Pengiriman ${detail.deliveryType}",
                                      style: TextStyle(
                                        color: Color(0xFF0168A4),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // aksi info
                                    },
                                    icon: const Icon(Icons.help_outline,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ✅ Sisanya jadi scrollable
                Expanded(
                  child: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      children: [
                        const SizedBox(height: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Customer info
                            Row(
                              children: [
                                SvgPicture.asset(
                                    'assets/images/icons/profile.svg',
                                    width: 36,
                                    height: 36),
                                const SizedBox(width: 5),
                                Text(detail.customerName,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                const Text(" (Customer)",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                            const SizedBox(height: 15),
                            const Divider(thickness: 0.7),

                            // Minimal Lelang
                            const Text("Minimal lelang:",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal)),
                            Text(currencyFormat.format(detail.minBid),
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF0168A4))),
                            const SizedBox(height: 15),

                            // Badge Info
                            Wrap(
                              spacing: 8, // jarak horizontal
                              runSpacing: 8, // jarak vertical jika pindah baris
                              children: [
                                _buildTag(
                                    detail.deliveryType,
                                    const Color(0xFFE8EEF4),
                                    const Color(0xFF01518D)),
                                _buildTag(detail.distance, Colors.white,
                                    Colors.black),
                                _buildTag(
                                    detail.weight, Colors.white, Colors.black),
                                _buildTag(
                                    detail.category, Colors.white, Colors.black,
                                    icon: 'assets/images/vendor/food.svg'),
                              ],
                            ),
                            const SizedBox(height: 15),
                            const Divider(thickness: 0.7),
                          ],
                        ),

                        // Badge Info
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Alamat Penjemputan
                            _buildAddressCard(
                              label: "Alamat Penjemputan",
                              title: detail.pickupAddress,
                              subtitle: detail.detailPickupAddress,
                              iconPath: "assets/images/vendor/blue_flag.svg",
                              badgeColor: Color(0xFF01518D),
                            ),

                            // Alamat Tujuan
                            _buildAddressCard(
                              label: "Alamat Tujuan",
                              title: detail.destinationAddress,
                              subtitle: detail.detailDestinationAddress,
                              iconPath: "assets/images/vendor/orange_map.svg",
                              badgeColor: Color(0xFFA68B13),
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Catatan:",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Kolom catatan
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F7F8), // abu-abu muda
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                "-", // default isi catatan
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Tombol simulasi
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFF0168A4), // warna biru
                                  foregroundColor:
                                      Colors.white, // teks dan ikon putih
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AuctionMapPage(detail: detail)));
                                  // Aksi tombol simulasi
                                },
                                icon: SvgPicture.asset(
                                    'assets/images/vendor/map.svg'),
                                label: const Text(
                                  "Simulasi dari lokasi Anda",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),

                        // Tanggal & Jam
                        // Tanggal Pengiriman
                        _buildSectionTitle("Tanggal Pengiriman"),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInputBox(
                                "Tanggal",
                                "${detail.deliveryDate.toLocal()}"
                                    .split(" ")[0],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildInputBox("Jam", detail.deliveryTime),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Detail Barang
                        _buildSectionTitle("Detail Barang"),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInputBox(
                                "Berat total (Kg)",
                                "${detail.itemWeight} Kg",
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildInputBox(
                                "Nilai Barang (Rp)",
                                currencyFormat.format(detail.itemValue),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildInputBox(
                            "Dimensi m³", "${detail.itemDimension} m³"),
                        const SizedBox(height: 8),
                        _buildInputBox(
                            "Deskripsi Barang", detail.itemDescription),
                        const SizedBox(height: 16),

                        // Paket Pengiriman
                        // Paket Pengiriman
                        _buildSectionTitle("Paket Pengiriman"),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0XFF01518D)),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Ganti dengan SvgPicture.asset kalau ada icon custom
                                  SvgPicture.asset(
                                      'assets/images/vendor/send_packet.svg'),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          detail.shippingType,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black87),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          detail.modelDelivery,
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFFA68B13),
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          detail.shippingDesc,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Estimasi Waktu Pengiriman",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54)),
                                        Text(
                                          detail.shippingEstimate,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Estimasi Harga Lelang",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54)),
                                        Text(
                                          currencyFormat
                                              .format(detail.shippingPrice),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Paket Proteksi
                        _buildSectionTitle("Paket Proteksi"),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF01518D)),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Ikon di sebelah kiri
                                  SvgPicture.asset(
                                    'assets/images/vendor/protection.svg',
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(width: 12),

                                  // Bagian teks di kanan ikon
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              detail.protectionType,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFE8EEF4),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                currencyFormat.format(
                                                    detail.protectionPrice),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF01518D),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                detail.protectionDesc,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 80),
                      ]),
                )
              ],
            );
          },
        ),

        // ✅ BottomAppBar tetap di Scaffold utama
        bottomNavigationBar: FutureBuilder<AuctionDetail>(
          future: service.fetchAuctionDetail(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            final detail = snapshot.data!;

            return SafeArea(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white, // container tetap putih
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.1), // shadow tipis
                      offset: const Offset(0, -3), // arah shadow ke atas
                      blurRadius: 6, // bikin shadow halus
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // penting biar tidak overflow
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFFE8EEF4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              // Badge angka
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0168A4),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  detail.totalBids.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Penawaran (${detail.remainingTime})",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Color(0xFF0168A4),
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.chevron_right,
                              color: Color(0xFF082337)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(thickness: 0.7),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AuctionListPage()));
                            },
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 3),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                backgroundColor: Color(0Xff01518D)),
                            child: const Text("Buat Penawaran",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 3),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                      'assets/images/vendor/likes.svg'),
                                  const SizedBox(width: 5),
                                  const Text("Simpan",
                                      style: TextStyle(
                                          color: Color(0xFF6D7882),
                                          fontWeight: FontWeight.normal)),
                                ],
                              )),
                        ),
                        const SizedBox(height: 16)
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor,
      {String? icon}) {
    Color? dynamicTextColor;
    if (text.toLowerCase() == "reguler") {
      dynamicTextColor = const Color(0xFF01518D);
    } else if (text.toLowerCase() == "silver" ||
        text.toLowerCase() == "prioritas") {
      dynamicTextColor = Colors.white;
    } else {
      dynamicTextColor = textColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400, width: 1)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[SvgPicture.asset(icon)],
          const SizedBox(width: 1),
          Text(text,
              style: TextStyle(
                  color: dynamicTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildAddressCard({
    required String label,
    required String title,
    required String subtitle,
    required String iconPath,
    required Color badgeColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon di kiri
          Column(
            children: [
              SvgPicture.asset(
                iconPath,
                width: 20,
                height: 20,
                // ignore: deprecated_member_use
                color: badgeColor,
              ),
              if (label == "Alamat Penjemputan")
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  width: 2,
                  height: 50,
                  color: Colors.grey.shade300,
                ),
            ],
          ),
          const SizedBox(width: 12),

          // Konten alamat di kanan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: badgeColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: badgeColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const Divider(thickness: 0.6, height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk section title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
      ),
    );
  }

// Helper untuk input box gaya readonly
  Widget _buildInputBox(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6D7882),
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.maxFinite,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Color(0xFFF6F8F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6D7882),
                fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}
