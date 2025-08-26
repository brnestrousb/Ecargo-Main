import 'package:ecarrgo/core/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isVendor; // parameter tambahan

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isVendor = false,
  });

  static const List<String> _customerIconPaths = [
    'assets/images/icons/bottom_navigation/home.svg',
    'assets/images/icons/bottom_navigation/aktivitas.svg',
    'assets/images/icons/bottom_navigation/notifikasi.svg',
    'assets/images/icons/bottom_navigation/lainnya.svg',
  ];

  static const List<String> _customerLabels = [
    'Home',
    'Aktivitas',
    'Notifikasi',
    'Lainnya',
  ];

  static const List<String> _vendorIconPaths = [
    'assets/images/icons/bottom_navigation/home.svg',
    'assets/images/icons/bottom_navigation/lelang.svg', // ikon lelang vendor
    'assets/images/icons/bottom_navigation/aktivitas.svg',
    'assets/images/icons/bottom_navigation/notifikasi.svg',
    'assets/images/icons/bottom_navigation/lainnya.svg',
  ];

  static const List<String> _vendorLabels = [
    'Home',
    'Lelang',
    'Aktivitas',
    'Notifikasi',
    'Lainnya',
  ];

  @override
  Widget build(BuildContext context) {
    final iconPaths = isVendor ? _vendorIconPaths : _customerIconPaths;
    final labels = isVendor ? _vendorLabels : _customerLabels;

    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white, // container tetap putih
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.1), // shadow tipis
              offset: const Offset(0, -3), // arah shadow ke atas
              blurRadius: 6, // bikin shadow halus
              spreadRadius: 0,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          onTap: onTap,
          selectedLabelStyle: const TextStyle(color: AppColors.blue),
          unselectedLabelStyle: const TextStyle(color: AppColors.gray),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          items: List.generate(iconPaths.length, (index) {
            final isSelected = index == currentIndex;
            return BottomNavigationBarItem(
              label: labels[index],
              icon: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isSelected ? null : AppColors.offWhite1,
                  borderRadius: BorderRadius.circular(12),
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFF008CC8), Color(0xFF01518D)],
                        )
                      : null,
                ),
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(
                  iconPaths[index],
                  width: 24,
                  height: 24,
                  // ignore: deprecated_member_use
                  color: isSelected ? Colors.white : AppColors.lightGrayBlue,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
