import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class RupiahInputFormatter extends TextInputFormatter {
  final NumberFormat formatter = NumberFormat.decimalPattern('id_ID');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Hapus semua karakter non-digit
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Format ke Rupiah
    String formatted = formatter.format(int.parse(newText));

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
