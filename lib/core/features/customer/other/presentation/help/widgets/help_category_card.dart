import 'package:flutter/material.dart';

class HelpCategoryCard extends StatefulWidget {
  const HelpCategoryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.question,
  });
  final IconData icon;
  final String title;
  final List<String> question;

  @override
  State<HelpCategoryCard> createState() => _HelpCategoryCardState();
}

class _HelpCategoryCardState extends State<HelpCategoryCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    Icon(widget.icon, color: Colors.black),
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
                    children: widget.question.map((q) {
                      return Column(
                        children: [
                          const Divider(),
                          ListTile(
                            dense: true,
                            title: Text(
                              q,
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                              size: 18,
                            ),
                            onTap: () {
                              // TODO: handle klik pertanyaan
                            },
                          ),
                        ],
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
