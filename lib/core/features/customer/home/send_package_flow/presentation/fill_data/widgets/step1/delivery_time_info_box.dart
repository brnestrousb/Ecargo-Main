import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeliveryTimeInfoBox extends StatelessWidget {
  const DeliveryTimeInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0CD33),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0CD33)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/icons/warning_delivery_icon.svg',
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              Text(
                "Keterangan Waktu Pengiriman",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "• Waktu pickup dari jam 6 pagi hingga 12 siang akan dikirim di hari yang sama.",
            style: TextStyle(color: Colors.black87),
          ),
          const SizedBox(height: 4),
          const Text(
            "• Jika lebih dari jam 2 siang, pengiriman dilakukan di hari berikutnya.",
            style: TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
