import 'package:flutter/material.dart';

class OfferConfirmationPage extends StatelessWidget {
  const OfferConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Penawaran",
            style: TextStyle(
                fontSize: 16, fontVariations: [FontVariation.weight(700)])),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new, size: 20)),
      ),
      body: const Center(
        child: Text("Ini halaman Step 2 (Konfirmasi)"),
      ),
    );
  }
}
