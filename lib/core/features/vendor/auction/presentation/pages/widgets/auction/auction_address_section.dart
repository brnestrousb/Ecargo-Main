// lib/pages/auction_detail/widgets/address_section.dart
import 'package:flutter/material.dart';

class AddressSection extends StatelessWidget {
  final String address;

  const AddressSection({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Alamat Pengiriman"),
      subtitle: Text(address),
    );
  }
}
