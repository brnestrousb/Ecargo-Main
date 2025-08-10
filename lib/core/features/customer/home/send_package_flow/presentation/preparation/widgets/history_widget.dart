import 'package:flutter/material.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/widgets/timeline_step.dart';

class HistoryWidget extends StatelessWidget {
  final List<Map<String, String>> history;

  const HistoryWidget({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('📜 History Data: $history');
    // Urutkan riwayat berdasarkan timestamp
    final sortedHistory = history
      ..sort((a, b) => DateTime.parse(a['timestamp']!)
          .compareTo(DateTime.parse(b['timestamp']!)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(thickness: 2),
        const SizedBox(height: 24),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Riwayat",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 16),

        // Tampilkan riwayat status
        if (sortedHistory.isEmpty)
          TimelineStep(
            label: 'Status: Menunggu Konfirmasi Ecarrgo',
            timestamp: DateTime.now(),
            isActive: false,
          )
        else
          ...sortedHistory.map((entry) {
            final status = entry['status'] ?? 'Tidak diketahui';
            final timestamp =
                entry['timestamp'] ?? DateTime.now().toIso8601String();
            return TimelineStep(
              label: 'Status: ${formatStatus(status)}',
              timestamp: DateTime.parse(timestamp),
              isActive: false,
            );
          }),
      ],
    );
  }

  String formatStatus(String status) {
    switch (status) {
      case 'draft':
        return 'Draft';
      case 'auction':
        return 'Lelang';
      case 'waiting_pickup':
        return 'Menunggu Penjemputan';
      case 'in_transit':
        return 'Dalam Perjalanan';
      case 'delivered':
        return 'Terkirim';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status.replaceAll('_', ' ').toUpperCase();
    }
  }
}
