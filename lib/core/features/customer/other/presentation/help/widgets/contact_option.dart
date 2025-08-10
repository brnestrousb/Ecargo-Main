import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactOption extends StatelessWidget {
  final String iconPath;
  final String label;

  const ContactOption({
    super.key,
    required this.iconPath,
    required this.label,
  });

  String _normalizeLabel(String label) {
    if (!label.contains('\n')) {
      return '$label\n';
    }
    return label;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Bungkus SVG dengan kotak lingkaran fix
            Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // invisible background
              ),
              child: SvgPicture.asset(
                iconPath,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _normalizeLabel(label),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
