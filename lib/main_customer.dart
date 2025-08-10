import 'package:ecarrgo/core/features/customer/notifcation/presentation/pages/notification.dart';
import 'package:ecarrgo/core/features/customer/other/presentation/pages/other_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecarrgo/core/features/customer/home/presentation/pages/home_screen.dart';
import 'package:ecarrgo/core/features/customer/activity/presentation/pages/activity_screen.dart';
import 'package:ecarrgo/core/features/customer/presentation/widgets/custom_bottom_navigation_bar.dart';

class CustomerNavigation extends StatefulWidget {
  final int initialIndex;

  const CustomerNavigation({super.key, this.initialIndex = 0});

  @override
  State<CustomerNavigation> createState() => _CustomerNavigationState();
}

class _CustomerNavigationState extends State<CustomerNavigation> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; // Gunakan initialIndex
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeScreen(),
          ActivityScreen(),
          NotificationScreen(),
          OtherScreen(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
