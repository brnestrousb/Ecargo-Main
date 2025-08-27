// lib/pages/auction_detail/widgets/item_detail.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ItemDetail extends StatelessWidget {
  final String itemName;
  final String itemImage;
  final String description;

  const ItemDetail({
    super.key,
    required this.itemName,
    required this.itemImage,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(itemImage, height: 150),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(itemName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(description),
          ),
        ],
      ),
    );
  }
}
