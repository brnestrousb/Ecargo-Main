import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class ActivityItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final NumberFormat currencyFormatter;
  final Logger logger = Logger();

  ActivityItemCard({
    super.key,
    required this.item,
    required this.currencyFormatter,
  });

  String _formatDate(dynamic dateInput) {
    if (dateInput is String && dateInput.isNotEmpty) {
      try {
        final date = DateTime.parse(dateInput);
        return '${date.month}/${date.day}/${date.year}';
      } catch (e) {
        debugPrint('Error formatting date: $e');
      }
    }
    return 'Tanggal tidak valid';
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Dalam Proses';
      case 'completed':
        return 'Selesai';
      case 'draft':
        return 'Draf';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'draft':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Icons.access_time;
      case 'completed':
        return Icons.check_circle;
      case 'draft':
        return Icons.drafts;
      default:
        return Icons.info;
    }
  }

  double _parsePrice(dynamic price) {
    if (price is num) {
      return price.toDouble();
    } else if (price is String) {
      final cleanString = price.replaceAll('.', '').replaceAll(',', '.');
      return double.tryParse(cleanString) ?? 0;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatDate(item['date']);
    final status = _getStatusText(item['status'] ?? '');
    final statusColor = _getStatusColor(item['status'] ?? '');
    final price = _parsePrice(item['price']);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   'ID: ${item['shipment_id']}', // Tampilkan ID
            //   style: const TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // Icon on the left
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Image.asset(
                item['category'] == 'Dalam Kota'
                    ? 'assets/images/icons/home_dalam_kota_icon.png'
                    : 'assets/images/icons/home_luar_kota_icon.png',
                width: 60, // Reduced size
                height: 60, // Reduced size
              ),
            ),

            // Main content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Date and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          formattedDate,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          currencyFormatter.format(price),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Address
                  Text(
                    item['address'] ?? 'Alamat tidak tersedia',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Badges
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // Category badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: item['category'] == 'Dalam Kota'
                              ? Colors.blue.shade50
                              : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['category'] ?? 'Kategori',
                          style: TextStyle(
                            color: item['category'] == 'Dalam Kota'
                                ? Colors.blue
                                : Colors.green,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getStatusIcon(item['status'] ?? ''),
                              color: statusColor,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              status,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
