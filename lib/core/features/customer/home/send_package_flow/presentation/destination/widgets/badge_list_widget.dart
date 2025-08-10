import 'package:ecarrgo/core/constant/colors.dart';
import 'package:flutter/material.dart';

class BadgeModel {
  final IconData icon;
  final String name;

  BadgeModel({required this.icon, required this.name});
}

class BadgeListWidget extends StatelessWidget {
  final List<BadgeModel> badges;

  const BadgeListWidget({super.key, required this.badges});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: badges.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final badge = badges[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.lightGrayBlue, width: 0.5),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.green.shade100.withOpacity(0.5),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  badge.icon,
                  size: 24,
                  color: AppColors.lightGrayBlue,
                ),
                const SizedBox(width: 10),
                Text(
                  badge.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
