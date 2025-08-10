import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecarrgo/core/constant/colors.dart';

class ShippingPackageCard extends StatelessWidget {
  final String svgIconPath;
  final String title;
  final String method;
  final String description;
  final String timeEstimate;
  final String priceEstimate;
  final bool selected;
  final bool readOnly;
  final VoidCallback? onTap;

  const ShippingPackageCard({
    super.key,
    required this.svgIconPath,
    required this.title,
    required this.method,
    required this.description,
    required this.timeEstimate,
    required this.priceEstimate,
    required this.selected,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: selected ? AppColors.darkBlue : Colors.grey.shade300,
          width: selected ? 2 : 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: readOnly ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected
                                ? AppColors.darkBlue
                                : Colors.grey.shade400,
                            width: 2,
                          ),
                          color: selected ? AppColors.darkBlue : Colors.white,
                        ),
                        child: selected
                            ? const Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                  const SizedBox(width: 12),
                  SvgPicture.asset(
                    svgIconPath,
                    width: 48,
                    height: 48,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: selected ? AppColors.darkBlue : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          method,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          description,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 1),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn(
                    "Estimasi Waktu",
                    timeEstimate,
                    Icons.access_time,
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.grey.shade300,
                  ),
                  _buildInfoColumn(
                    "Estimasi Harga Lelang",
                    priceEstimate,
                    Icons.attach_money,
                    isPrice: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(
    String title,
    String value,
    IconData icon, {
    bool isPrice = false,
  }) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isPrice ? Colors.green.shade700 : Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
