import 'package:ecarrgo/core/features/customer/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:ecarrgo/core/features/vendor/auction/presentation/pages/auction_screen.dart';
import 'package:ecarrgo/core/features/vendor/home/presentation/home_screen_vendor.dart';
import 'package:ecarrgo/core/features/vendor/other/presentation/pages/other_screen_vendor.dart';
import 'package:flutter/material.dart';

class VendorNavigation extends StatefulWidget {
  const VendorNavigation({super.key});

  @override
  State<VendorNavigation> createState() => _VendorNavigationState();
}

class _VendorNavigationState extends State<VendorNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    VendorHomeScreen(), // Halaman beranda vendor
    const AuctionScreen(), // Halaman lelang
    const VendorOtherScreen() // Halaman lainnya
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
     bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTap,
          isVendor: true, // tambahkan ini
        )
    );
  }
}
