import 'package:ecarrgo/core/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConfirmPickupDialog extends StatelessWidget {
  final VoidCallback onConfirmed;
  final String alamatLengkap;

  const ConfirmPickupDialog({
    super.key,
    required this.onConfirmed,
    required this.alamatLengkap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          // Title
          Text(
            'Set Lokasi Titik Jemput',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Kotak alamat dengan ikon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/images/icons/map_pin_icon.svg',
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    alamatLengkap,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Tombol lanjut
          ElevatedButton(
            onPressed: onConfirmed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text("Lanjut"),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
