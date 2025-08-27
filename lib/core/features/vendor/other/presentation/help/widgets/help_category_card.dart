import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HelpCategoryCard extends StatefulWidget {
  const HelpCategoryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.question,
    required this.onTap,
  });
  final SvgPicture icon;
  final String title;
  final String question;
  final VoidCallback? onTap;

  @override
  State<HelpCategoryCard> createState() => _HelpCategoryCardState();
}

class _HelpCategoryCardState extends State<HelpCategoryCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 1.5,
      child: InkWell(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: 24, height: 24, child: widget.icon),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.black54,
                    ),
                  ],
                ),
                if (isExpanded) const SizedBox(height: 12),
                if (isExpanded)
                  Column(
                    children: [
                      const Divider(),
                      ListTile(
                        dense: true,
                        title: Text(
                          widget.question,
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: const Icon(Icons.chevron_right, size: 18),
                        onTap: () {
                          widget.onTap!();
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
