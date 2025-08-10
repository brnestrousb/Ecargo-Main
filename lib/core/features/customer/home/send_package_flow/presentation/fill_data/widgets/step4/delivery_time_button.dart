// widgets/delivery_time_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecarrgo/core/constant/colors.dart';

class DeliveryTimeButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const DeliveryTimeButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkBlue,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/images/icons/bookmark_icon.svg',
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
