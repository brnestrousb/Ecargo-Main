import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final Widget? prefixIcon;     // bisa Text("Rp.") atau Icon(Icons.money)
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  const CustomInputField({
    super.key,
    this.prefixIcon,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null
            ? Container(
                margin: const EdgeInsets.only(left: 12, right: 8),
                alignment: Alignment.center,
                child: prefixIcon,
              )
            : null,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      ),
    );
  }
}
