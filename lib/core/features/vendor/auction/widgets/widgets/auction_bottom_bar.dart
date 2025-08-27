// lib/pages/auction_detail/widgets/bottom_bar.dart
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final String auctionId;
  final double currentPrice;

  const BottomBar({
    super.key,
    required this.auctionId,
    required this.currentPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      color: Colors.white,
      child: ElevatedButton(
        onPressed: () {
          // TODO: integrasi ke backend untuk ikut bid
          print("Ikut Bid di $auctionId dengan harga $currentPrice");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          "Ikut Lelang Rp${currentPrice.toStringAsFixed(0)}",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
