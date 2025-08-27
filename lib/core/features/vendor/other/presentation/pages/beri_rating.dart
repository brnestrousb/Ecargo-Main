// lib/pages/beri_rating_page.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BeriRatingPage extends StatelessWidget {
  const BeriRatingPage({super.key});

  Future<void> _launchPlayStore() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.example.yourapp'; // Ganti dengan package aslimu
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak dapat membuka Play Store.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beri Rating'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(
              Icons.star_rate_rounded,
              size: 100,
              color: Colors.amber,
            ),
            const SizedBox(height: 20),
            const Text(
              'Suka dengan aplikasi ini?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Bantu kami berkembang dengan memberikan rating di Play Store.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _launchPlayStore,
              icon: const Icon(Icons.open_in_new),
              label: const Text('Buka Play Store'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
