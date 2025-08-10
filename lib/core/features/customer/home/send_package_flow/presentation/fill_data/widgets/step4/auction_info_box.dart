import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuctionInfoBox extends StatelessWidget {
  final VoidCallback? onTap;

  const AuctionInfoBox({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF0CD33),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF0CD33)),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/images/icons/warning_delivery_icon.svg',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Pelajari lebih lanjut tentang lelang di sini",
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }
}
