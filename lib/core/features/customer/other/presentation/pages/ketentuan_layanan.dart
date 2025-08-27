import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KetentuanLayananPage extends StatelessWidget {
  const KetentuanLayananPage({super.key});

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
                SvgPicture.asset("assets/images/icons/file.svg", width: 60, height: 60),
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
            'Selamat datang di aplikasi kami. Dengan mengakses dan menggunakan layanan kami, Anda menyetujui ketentuan yang tercantum di bawah ini. Harap baca dengan saksama.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),

          // 1
          _buildSectionTitle('1. Penggunaan Layanan'),
          _buildSectionBody([
            'Anda berusia minimal 18 tahun atau mendapatkan izin dari orang tua/wali.',
            'Anda memberikan informasi yang akurat dan lengkap saat mendaftar.',
            'Anda setuju untuk menggunakan layanan sesuai dengan hukum yang berlaku.',
          ]),
          const SizedBox(height: 20),

          // 2
          _buildSectionTitle('2. Akun Pengguna'),
          _buildSectionBody([
            'Anda bertanggung jawab penuh atas keamanan akun Anda, termasuk email dan kata sandi.',
            'Segala aktivitas yang terjadi melalui akun Anda menjadi tanggung jawab Anda.',
            'Kami berhak menangguhkan atau menonaktifkan akun jika terdeteksi penyalahgunaan atau pelanggaran.',
          ]),
          const SizedBox(height: 20),

          // 3
          _buildSectionTitle('3. Layanan Pengiriman dan Transaksi'),
          const Text(
            'Kami menyediakan platform untuk memfasilitasi transaksi, pengiriman, dan dukungan pelanggan.\n',
            style: TextStyle(fontSize: 16),
          ),
          _buildSectionBody([
            'Estimasi waktu pengiriman dapat bervariasi tergantung pada wilayah dan layanan kurir.',
            'Semua transaksi bersifat final, kecuali ditentukan lain melalui kebijakan pengembalian atau resolusi masalah.',
          ]),
          const SizedBox(height: 20),

          // 4
          _buildSectionTitle('4. Pembatasan Penggunaan'),
          _buildSectionBody([
            'Menyalahgunakan layanan untuk tindakan ilegal, penipuan, atau merusak sistem.',
            'Mengunggah konten yang melanggar hukum, tidak pantas, atau menyesatkan.',
            'Mengganggu keamanan atau stabilitas sistem aplikasi.',
          ]),
          const SizedBox(height: 20),

          // 5
          _buildSectionTitle('5. Penghentian Layanan'),
          const Text(
            'Kami berhak menghentikan atau membatasi akses Anda ke layanan kapan saja jika ditemukan pelanggaran terhadap ketentuan ini.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),

          // 6
          _buildSectionTitle('6. Perubahan Ketentuan'),
          const Text(
            'Kami dapat mengubah ketentuan ini sewaktu-waktu. Perubahan akan diberitahukan melalui aplikasi atau email. Penggunaan layanan setelah perubahan berarti Anda menyetujui ketentuan yang baru.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),

          // 7
          _buildSectionTitle('7. Kontak Bantuan'),
          const Text(
            'Untuk pertanyaan atau keluhan terkait layanan, silakan gunakan fitur Hubungi Kami di dalam aplikasi.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSectionBody(List<String> bullets) {
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
