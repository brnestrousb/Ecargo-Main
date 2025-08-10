import 'package:flutter/material.dart';
import 'package:ecarrgo/core/constant/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _backgroundColorAnimation;
  late Animation<double> _logoOpacityBlue;
  late Animation<double> _logoOpacityWhite;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Background: Putih ke Biru
    _backgroundColorAnimation = ColorTween(
      begin: Colors.white,
      end: AppColors.blue, // Biru
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
    ));

    // Logo Biru tampil dulu, lalu menghilang
    _logoOpacityBlue = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
    ));

    // Logo Putih muncul saat background biru
    _logoOpacityWhite = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
    ));

    _controller.forward().then((_) async {
      await Future.delayed(const Duration(seconds: 1)); // Tambahan delay
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _backgroundColorAnimation.value ?? Colors.white,
          body: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: _logoOpacityBlue.value,
                  child: Image.asset(
                    'assets/images/logo/ECarrgo_Company_Profile-Blue.png',
                    width: 180,
                  ),
                ),
                Opacity(
                  opacity: _logoOpacityWhite.value,
                  child: Image.asset(
                    'assets/images/logo/ECarrgo_Company_Profile-White.png',
                    width: 180,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
