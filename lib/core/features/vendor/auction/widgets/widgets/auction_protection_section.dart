// lib/pages/auction_detail/widgets/protection_package.dart
import 'package:flutter/material.dart';

class ProtectionPackage extends StatelessWidget {
  final String package;

  const ProtectionPackage({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Proteksi Barang"),
      subtitle: Text(package),
    );
  }
}
