import 'package:flutter/material.dart';
import 'payment_proof_page.dart'; // Pastikan file ini diimpor

class PaymentSuccessPage extends StatelessWidget {
  final Map<String, dynamic>? shipmentData;
  const PaymentSuccessPage({super.key, this.shipmentData});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline,
                size: 80, color: Colors.green),
            const SizedBox(height: 24),
            const Text(
              'Pembayaran Berhasil',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'CS kami akan mengonfirmasi pembayaran Anda. Siapkan dokumen sambil menunggu kami menghubungi.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                // Navigasi ke halaman PaymentProofPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentProofPage(
                      shipmentData: shipmentData,
                    ),
                  ),
                );
              },
              child: const Text(
                'Lihat Bukti Pembayaran',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline, // Tambahkan underline
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
