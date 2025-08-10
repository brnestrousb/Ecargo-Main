import 'package:flutter/material.dart';

class CustomTabNavigation extends StatelessWidget {
  final List<String> tabs;
  final String selectedTab;
  final Function(String) onTabSelected;
  final Map<String, int>? tabCounts;

  const CustomTabNavigation({
    super.key,
    required this.tabs,
    required this.selectedTab,
    required this.onTabSelected,
    this.tabCounts,
  });

  @override
  Widget build(BuildContext context) {
    assert(tabs.length <= 3, 'Maximum of 3 tabs allowed.');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = tab == selectedTab;
          final count = tabCounts?[tab] ?? 0;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                borderRadius: BorderRadius.circular(11),
                onTap: () => onTabSelected(tab),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF01518D)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Center(
                    child: FittedBox(
                      // 🛡️ Prevent overflow
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tab,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          if (count > 0) ...[
                            const SizedBox(width: 6),
                            // Container(
                            //   padding: const EdgeInsets.symmetric(
                            //       horizontal: 6, vertical: 2),
                            //   decoration: BoxDecoration(
                            //     color: isSelected
                            //         ? Colors.white
                            //         : const Color(0xFF01518D),
                            //     borderRadius: BorderRadius.circular(12),
                            //   ),
                            //   child: Text(
                            //     count.toString(),
                            //     style: TextStyle(
                            //       color: isSelected
                            //           ? const Color(0xFF01518D)
                            //           : Colors.white,
                            //       fontSize: 12,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            // )
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
