// lib/pages/auction_detail/widgets/shipping_package.dart
import 'package:flutter/material.dart';

class ShippingPackage extends StatelessWidget {
  final String package;

  const ShippingPackage({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Paket Pengiriman"),
      subtitle: Text(package),
    );
  }
}
