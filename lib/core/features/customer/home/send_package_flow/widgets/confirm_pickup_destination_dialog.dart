import 'package:ecarrgo/core/features/customer/home/send_package_flow/widgets/address_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConfirmPickupDestinationDialog extends StatelessWidget {
  final String pickupAddress;
  final String destinationAddress;
  final VoidCallback onEditPickup;
  final VoidCallback onEditDestination;
  final VoidCallback onConfirmed;

  const ConfirmPickupDestinationDialog({
    super.key,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.onEditPickup,
    required this.onEditDestination,
    required this.onConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                        color: Colors.grey,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge: Alamat Penjemputan
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Alamat Penjemputan',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                AddressRow(address: pickupAddress, onEdit: onEditPickup),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1, thickness: 0.5),
                ),

                // Badge: Alamat Tujuan
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Alamat Tujuan',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.yellow.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                AddressRow(
                    address: destinationAddress, onEdit: onEditDestination),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
