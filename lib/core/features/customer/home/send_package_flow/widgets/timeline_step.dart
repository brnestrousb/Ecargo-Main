import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimelineStep extends StatelessWidget {
  final String label;
  final DateTime timestamp;
  final bool isActive;

  const TimelineStep({
    super.key,
    required this.label,
    required this.timestamp,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final dateString = DateFormat('d MMM, y').format(timestamp);
    final timeString = DateFormat('HH:mm').format(timestamp);

    final dotColor = isActive ? Colors.blue : Colors.grey;
    final textColor = isActive ? Colors.blue : Colors.black87;
    final detailColor = Colors.black54;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timestamp kiri
        SizedBox(
          width: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(dateString,
                  style: TextStyle(fontSize: 13, color: detailColor)),
              const SizedBox(height: 2),
              Text(timeString,
                  style: TextStyle(fontSize: 13, color: detailColor)),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Titik dan garis (di tengah)
        Column(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 2,
              height: 48,
              color: Colors.grey.shade300,
            ),
          ],
        ),

        const SizedBox(width: 12),

        // Keterangan kanan
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}
