import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriceInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool readOnly; // sudah ada parameter ini

  const PriceInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.validator,
    this.onChanged,
    this.readOnly = false,
  });

  String _formatRupiah(String value) {
    final number = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0);
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Colors.grey),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16,
            ),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hintText,
            border: border,
            enabledBorder: border,
            focusedBorder: border,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
            prefixIcon: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Rp',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),
          onChanged: readOnly
              ? null
              : (value) {
                  final formatted = _formatRupiah(value);
                  controller.value = TextEditingValue(
                    text: formatted,
                    selection:
                        TextSelection.collapsed(offset: formatted.length),
                  );
                  if (onChanged != null) {
                    onChanged!(formatted);
                  }
                },
          validator: validator,
        ),
      ],
    );
  }
}
