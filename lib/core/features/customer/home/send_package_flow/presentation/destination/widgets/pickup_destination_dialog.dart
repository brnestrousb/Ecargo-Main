import 'package:ecarrgo/core/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PickupDestinationDialog extends StatelessWidget {
  final String pickupAddress;
  final String destinationAddress;
  final VoidCallback onEditPickup;
  final VoidCallback onEditDestination;
  final VoidCallback onConfirmed;

  const PickupDestinationDialog({
    super.key,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.onEditPickup,
    required this.onEditDestination,
    required this.onConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icons + dots (left column)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/images/icons/current_location_icon.svg',
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 30,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            6,
                            (index) => Container(
                              width: 2,
                              height: 2,
                              color: AppColors.lightGrayBlue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SvgPicture.asset(
                        'assets/images/icons/destination_location_icon.svg',
                        width: 24,
                        height: 24,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Address content (right column)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _AddressRow(
                        address: pickupAddress,
                        onEdit: onEditPickup,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(
                          height: 1,
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      _AddressRow(
                        address: destinationAddress,
                        onEdit: onEditDestination,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onConfirmed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text("Lanjut"),
          ),
        ],
      ),
    );
  }
}

class _AddressRow extends StatelessWidget {
  final String address;
  final VoidCallback onEdit;

  const _AddressRow({
    required this.address,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            address,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          onPressed: onEdit,
          icon: SvgPicture.asset(
            'assets/images/icons/btn_edit.svg',
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }
}
