import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

// ignore: unused_element
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/icons/empty_state.svg',
            width: 180,
            height: 180,
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada aktivitas ditemukan',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
