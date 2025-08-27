// lib/pages/auction_detail/widgets/auction_price.dart
import 'package:flutter/material.dart';

class AuctionPrice extends StatelessWidget {
  final double price;
  final double minIncrement;

  const AuctionPrice({
    super.key,
    required this.price,
    required this.minIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Harga Tertinggi: Rp${price.toStringAsFixed(0)}"),
      subtitle: Text("Kelipatan Bid: Rp${minIncrement.toStringAsFixed(0)}"),
    );
  }
}
