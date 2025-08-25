// lib/pages/auction_detail/widgets/delivery_date.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DeliveryDate extends StatelessWidget {
  final DateTime date;

  const DeliveryDate({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Estimasi Tanggal Kirim"),
      subtitle: Text(DateFormat('dd MMMM yyyy').format(date)),
    );
  }
}
