import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddressInputGroupWithDots extends StatelessWidget {
  final String pickupTitle;
  final String pickupDetail;
  final String destinationTitle;
  final String destinationDetail;
  final VoidCallback? onEditPickup;
  final VoidCallback? onEditDestination;

  const AddressInputGroupWithDots({
    super.key,
    required this.pickupTitle,
    required this.pickupDetail,
    required this.destinationTitle,
    required this.destinationDetail,
    this.onEditPickup,
    this.onEditDestination,
  });

  Widget _buildAddressItem({
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required String shortAddress,
    required String fullDetail,
    VoidCallback? onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label (misal: Alamat Penjemputan)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                // Alamat singkat (pickupTitle)
                Text(
                  shortAddress,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),

                // Detail lengkap (pickupDetail)
                Text(
                  fullDetail,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          if (onEdit != null)
            IconButton(
              onPressed: onEdit,
              icon: SvgPicture.asset(
                'assets/images/icons/btn_edit.svg',
                width: 20,
                height: 20,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: 'Edit',
            ),
        ],
      ),
    );
  }


  Widget _buildIconWithDots() {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/images/icons/map_pin_icon.svg',
          width: 34,
          height: 34,
        ),
        const SizedBox(height: 4),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              6,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Container(
                  width: 3,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade300,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        SvgPicture.asset(
          'assets/images/icons/destination_pin_icon.svg',
          width: 34,
          height: 34,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian kiri: Icon + dots
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              height: 160,
              child: _buildIconWithDots(),
            ),
          ),
          // Bagian kanan: Address Items
          Expanded(
            child: Column(
              children: [
                _buildAddressItem(
                  label: 'Alamat Penjemputan',
                  backgroundColor: Colors.blue[50]!,
                  textColor: Colors.blue[700]!,
                  shortAddress: pickupTitle,
                  fullDetail: pickupDetail,
                  onEdit: onEditPickup,
                ),
                const SizedBox(height: 16),
                _buildAddressItem(
                  label: 'Alamat Tujuan',
                  backgroundColor: Colors.yellow[50]!,
                  textColor: Colors.yellow[700]!,
                  shortAddress: destinationTitle,
                  fullDetail: destinationDetail,
                  onEdit: onEditDestination,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
