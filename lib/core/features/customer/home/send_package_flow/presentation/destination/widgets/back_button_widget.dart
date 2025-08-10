import 'package:flutter/material.dart';
import 'package:ecarrgo/core/constant/colors.dart';

class BackButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const BackButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        color: AppColors.darkBlue,
        tooltip: 'Kembali',
        onPressed: onPressed,
      ),
    );
  }
}
