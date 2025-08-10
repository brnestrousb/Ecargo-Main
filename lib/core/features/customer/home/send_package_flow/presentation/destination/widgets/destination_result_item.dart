import 'package:flutter/material.dart';

class DestinationResultItem extends StatelessWidget {
  final String shortTitle;
  final String fullAddress;
  final double? distanceKm;
  final String? distanceFormatted;
  final VoidCallback onTap;
  final VoidCallback onBookmarkPressed;

  const DestinationResultItem({
    super.key,
    required this.shortTitle,
    required this.fullAddress,
    this.distanceFormatted,
    this.distanceKm,
    required this.onTap,
    required this.onBookmarkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12, top: 4),
              child: Icon(
                Icons.place_outlined,
                size: 24,
                color: Colors.blueAccent,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shortTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (distanceKm != null)
                    Text(
                      distanceFormatted ?? '',
                      style: TextStyle(
                        color: Colors.yellow[700],
                        fontSize: 16,
                      ),
                    ),
                  Text(
                    fullAddress,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // IconButton(
            //   icon: const Icon(Icons.bookmark),
            //   color: Colors.blue,
            //   onPressed: onBookmarkPressed,
            // ),
          ],
        ),
      ),
    );
  }
}
