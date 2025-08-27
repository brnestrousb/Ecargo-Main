// lib/pages/auction_detail/widgets/customer_info.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomerInfo extends StatelessWidget {
  final String name;
  final String avatar;

  const CustomerInfo({
    super.key,
    required this.name,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(avatar, width: 40, height: 40),
      title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("Pelelang"),
    );
  }
}
