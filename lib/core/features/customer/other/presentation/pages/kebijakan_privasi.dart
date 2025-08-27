import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class KebijakanPrivasiPage extends StatelessWidget {
  const KebijakanPrivasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kebijakan Privasi'),
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
                  "assets/images/icons/shield.svg",
                  width: 60,
                  height: 60,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Kebijakan Privasi',
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
            'Kami menghargai dan melindungi privasi Anda. Kebijakan privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan menjaga informasi pribadi Anda saat menggunakan aplikasi kami.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),

          // 1
          _buildSectionTitle('1. Informasi yang Kami Kumpulkan'),
          _buildSectionBody([
            'Informasi Pribadi seperti nama, alamat email, nomor telepon, dan alamat pengiriman.',
            'Informasi Transaksi: riwayat pesanan, metode pembayaran, dan informasi pengiriman.',
            'Informasi Teknis seperti alamat IP, jenis perangkat, sistem operasi, dan data penggunaan aplikasi.',
          ]),
          const SizedBox(height: 20),

          // 2
          _buildSectionTitle('2. Bagaimana Kami Menggunakan Informasi Anda'),
          _buildSectionBody([
            'Memproses dan mengelola pesanan.',
            'Memberikan layanan pelanggan dan bantuan teknis.',
            'Mengirimkan notifikasi terkait pesanan atau promo.',
            'Meningkatkan kinerja dan pengalaman pengguna di aplikasi.',
          ]),
          const SizedBox(height: 20),

          // 3
          _buildSectionTitle('3. Keamanan Data'),
          const Text(
            'Kami menggunakan berbagai langkah pengamanan teknis dan organisasi untuk menjaga data pribadi Anda dari akses tidak sah, kehilangan, atau penyalahgunaan.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),

          // 4
          _buildSectionTitle('4. Pembagian Informasi ke Pihak Ketiga'),
          const Text(
            'Kami tidak menjual atau menyewakan data pribadi Anda kepada pihak ketiga. Namun, kami dapat membagikan informasi dengan:',
            style: TextStyle(fontSize: 16),
          ),
          _buildSectionBody([
            'Mitra logistik (kurir) untuk keperluan pengiriman.',
            'Penyedia layanan pihak ketiga yang membantu operasional kami (misalnya layanan pembayaran, sistem keamanan).',
          ]),
          const SizedBox(height: 20),

          // 5
          _buildSectionTitle('5. Hak Pengguna'),
          _buildSectionBody([
            'Mengakses dan memperbarui informasi pribadi Anda.',
            'Meminta penghapusan akun dan data pribadi Anda.',
            'Menolak komunikasi pemasaran langsung dari aplikasi.',
          ]),
          const SizedBox(height: 20),

          // 6
          _buildSectionTitle('6. Perubahan Kebijakan Privasi'),
          const Text(
            'Kebijakan ini dapat diperbarui dari waktu ke waktu. Setiap perubahan akan diumumkan melalui aplikasi atau email. Kami menyarankan Anda untuk meninjau kebijakan ini secara berkala.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),

          // 7
          _buildSectionTitle('7. Hubungi Kami'),
          const Text(
            'Jika Anda memiliki pertanyaan atau permintaan terkait kebijakan privasi ini, silakan hubungi menu Help di aplikasi.',
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
