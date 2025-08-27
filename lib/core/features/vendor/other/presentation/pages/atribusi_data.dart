import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AtribusiDataPage extends StatelessWidget {
  const AtribusiDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ketentuan Layanan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                SvgPicture.asset(
                  "assets/images/icons/data.svg",
                  width: 60,
                  height: 60,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Ketentuan Layanan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Terakhir diperbarui: 26 Juni 2025',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const Text(
            'Aplikasi ini dapat menggunakan data dari berbagai sumber untuk meningkatkan pengalaman pengguna, menyediakan layanan secara akurat, dan memastikan transparansi. Kami berkomitmen untuk memberikan atribusi yang sesuai kepada penyedia data.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),

          // 1
          _buildSectionTitle('1. Sumber Data Pihak Ketiga'),
          const Text(
            'Beberapa data yang digunakan dalam aplikasi ini berasal dari layanan pihak ketiga, termasuk namun tidak terbatas pada:',
            style: TextStyle(fontSize: 16),
          ),
          _buildSectionBody([
            'Layanan Kurir & Logistik:\nInformasi pelacakan dan status pengiriman disediakan melalui API dari mitra kurir seperti JNE, J&T, SiCepat, dll.',
            'Pembayaran & Keuangan:\nData status pembayaran dan transaksi dapat berasal dari mitra pembayaran (misalnya: Midtrans, Xendit, DOKU).',
            'Geolokasi & Peta:\nAplikasi mungkin menggunakan Google Maps API atau penyedia peta lainnya untuk menunjukkan lokasi pengiriman atau kantor cabang.',
          ]),
          const SizedBox(height: 20),

          // 2
          _buildSectionTitle('2. Hak Cipta & Lisensi'),
          const Text(
            'Setiap data, ikon, grafik, dan teks yang digunakan dari pihak ketiga tunduk pada lisensi masing-masing pemiliknya. Kami memastikan penggunaan dilakukan sesuai dengan lisensi yang diberikan, baik itu lisensi terbuka (open license) maupun lisensi komersial.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),

          // 3
          _buildSectionTitle('3. Penafian'),
          const Text(
            'Kami tidak bertanggung jawab atas akurasi atau pembaruan data dari pihak ketiga. Kami hanya menampilkan data sebagaimana diberikan oleh penyedia data yang bersangkutan.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),

          // 4
          _buildSectionTitle('4. Kontak untuk Klaim atau Permintaan Atribusi Tambahan'),
          const Text(
            'Jika Anda adalah pemilik data yang merasa datanya digunakan tanpa atribusi yang memadai, silakan hubungi kami melalui menu Hubungi Kami di aplikasi. Kami akan merespons permintaan atribusi atau penghapusan dalam waktu 7 hari kerja.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  static Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  static Widget _buildSectionBody(List<String> bullets) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: bullets.map((text) {
        return Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(fontSize: 16)),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
