import 'package:flutter/material.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step4/delivery_time_button.dart';

class DeliveryTimeSection extends StatelessWidget {
  final String formattedDate; // contoh: '24/6/2025'
  final String formattedTime;
  final VoidCallback onEditDeliveryTime;
  final bool readOnly; // tambah parameter ini

  const DeliveryTimeSection({
    super.key,
    required this.formattedDate,
    required this.formattedTime,
    required this.onEditDeliveryTime,
    this.readOnly = false, // default false
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Warning
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.info_outline, size: 16, color: Colors.black87),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Durasi lelang tidak bisa melebihi Waktu Pengiriman.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Time Cards (No Label, No Border)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TimeDisplayCard(
                  value: formattedDate,
                  icon: Icons.calendar_today,
                ),
                const SizedBox(width: 12),
                TimeDisplayCard(
                  value: formattedTime,
                  icon: Icons.access_time,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Edit Button
            DeliveryTimeButton(
              onPressed: readOnly ? null : onEditDeliveryTime,
              label: "Ubah Waktu Pengiriman",
            ),
          ],
        ),
      ),
    );
  }
}

class TimeDisplayCard extends StatelessWidget {
  final String value;
  final IconData icon;

  const TimeDisplayCard({
    super.key,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140, // Lebih lebar agar teks tidak terpotong
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
