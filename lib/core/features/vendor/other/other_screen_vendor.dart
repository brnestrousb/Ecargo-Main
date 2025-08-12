// vendor_other_screen.dart
import 'package:flutter/material.dart';

class VendorOtherScreen extends StatelessWidget {
  const VendorOtherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Halaman Lainnya untuk Vendor',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
