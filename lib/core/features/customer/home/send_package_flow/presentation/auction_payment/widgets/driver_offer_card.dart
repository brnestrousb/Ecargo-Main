import 'package:ecarrgo/core/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DriverOfferCard extends StatelessWidget {
  final String driverName;
  final double rating;
  final String eta;
  final String price;
  final String vendorLevel;
  final bool isSelected;
  final bool isConfirmed;
  final VoidCallback? onSelect;

  const DriverOfferCard({
    super.key,
    required this.driverName,
    required this.rating,
    required this.eta,
    required this.price,
    required this.vendorLevel,
    this.isConfirmed = false,
    this.isSelected = false,
    this.onSelect,
  });

  String _getVendorLevelAssetPath(String level) {
    switch (level.toLowerCase()) {
      case 'silver':
        return 'assets/images/icons/level/silver_icon.svg';
      case 'bronze':
      default:
        return 'assets/images/icons/level/bronze.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Jika sudah dikonfirmasi, anggap sebagai selected
    final bool showAsSelected = isSelected || isConfirmed;

    return Material(
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isConfirmed ? null : onSelect,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: showAsSelected ? AppColors.darkBlue : Colors.grey.shade400,
              width: showAsSelected ? 2.0 : 1.0,
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://i.pravatar.cc/150?img=3',
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            driverName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 2),
                              Text(
                                rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isConfirmed) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green),
                      ),
                      child: const Text(
                        'Dikonfirmasi',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  showAsSelected
                      ? Icon(
                          Icons.check_circle,
                          color:
                              isConfirmed ? Colors.green : AppColors.darkBlue,
                        )
                      : Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ETA
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Text(
                      //   "Estimasi tiba:",
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.w600,
                      //     fontSize: 13,
                      //     color: Colors.black54,
                      //   ),
                      // ),
                      // const SizedBox(height: 4),
                      // Text(
                      //   eta,
                      //   style: const TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 16,
                      //   ),
                      // ),
                    ],
                  ),
                  // Harga
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Harga yang ditawarkan:",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        price,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color:
                              isConfirmed ? Colors.green : AppColors.darkBlue,
                        ),
                      ),
                    ],
                  ),
                  // Level
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Level vendor:",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          SvgPicture.asset(
                            _getVendorLevelAssetPath(vendorLevel),
                            height: 18,
                            width: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            vendorLevel,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
