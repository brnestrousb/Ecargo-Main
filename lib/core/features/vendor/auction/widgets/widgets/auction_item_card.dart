import 'package:ecarrgo/core/features/customer/activity/data/models/auction_model.dart';
//import 'package:ecarrgo/core/features/vendor/auction/presentation/pages/model/auction/auction_page_model.dart';
import 'package:flutter/material.dart';

class AuctionItemCard extends StatefulWidget {
  final AuctionModel item;
  final VoidCallback? onTap;

  const AuctionItemCard({super.key, required this.item, this.onTap});

  @override
  State<AuctionItemCard> createState() => _AuctionItemCardState();
}

class _AuctionItemCardState extends State<AuctionItemCard> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200, width: 1),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + Favorite
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.shipment.deliveryAddress, // contoh: "Binus University, Anggrek Campus"
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    onTap: () => setState(() => isLiked = !isLiked),
                    child: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border_outlined,
                      color: isLiked ? Colors.red : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Harga & Info tambahan
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabelValue("Penawaran terbaik:", 
                      "Rp ${item.auctionStartingPrice}",
                      valueStyle: const TextStyle(
                        color: Color(0xFF002D72),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  _buildLabelValue("Waktu tersisa:", item.shipment.deliveryDatetime.toString()), // bisa diganti ke countdown
                  _buildLabelValue("Penawaran:", "12"), // sementara hardcode
                ],
              ),
              const SizedBox(height: 12),

              // Badges
              Wrap(
                spacing: 8,
                children: [
                  _buildTag(item.shipment.shippingType, Colors.blue.shade50, Colors.blue.shade900),
                  _buildTag("230Km", Colors.grey.shade100, Colors.black87),
                  _buildTag("120Kg", Colors.grey.shade100, Colors.black87),
                  _buildTag("Makanan", Colors.grey.shade100, Colors.black87),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget untuk Label + Value
  Widget _buildLabelValue(String label, String value, {TextStyle? valueStyle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(value,
            style: valueStyle ??
                const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black)),
      ],
    );
  }

  /// Widget untuk Tag
  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
