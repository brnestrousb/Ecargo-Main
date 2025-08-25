import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuctionHeader extends StatelessWidget {
  final String title;

  const AuctionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset('assets/icons/auction.svg', width: 32, height: 32),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
