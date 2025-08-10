// date_time_selector_tile.dart
import 'package:flutter/material.dart';

class DateTimeSelectorTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor; // Tambahkan ini

  const DateTimeSelectorTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.grey, // Default
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            clipBehavior: Clip.hardEdge,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 12),
                Container(
                  width: 1,
                  height: 24,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: value.startsWith("Pilih")
                          ? Colors.grey.shade500
                          : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.grey.shade500),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
