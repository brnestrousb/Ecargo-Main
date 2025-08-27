import 'package:flutter/material.dart';

class BottomActionSection extends StatelessWidget {
  final String buttonLabel;
  final VoidCallback? onPressed;
  final String? categoryLabel;
  final IconData? categoryIcon;

  const BottomActionSection({
    Key? key,
    required this.buttonLabel,
    required this.onPressed,
    this.categoryLabel,
    this.categoryIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Jika ada kategori, tampilkan di atas button
          if (categoryLabel != null) ...[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  if (categoryIcon != null)
                    Icon(categoryIcon, color: Colors.amber),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Kategori penawaran Anda:"),
                      Text(
                        categoryLabel!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.help_outline, color: Colors.grey),
                ],
              ),
            ),
          ],

          // Button utama
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF01518D),
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                buttonLabel,
                style: const TextStyle(
                  color: Color(0xFFF6F8F9),
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
