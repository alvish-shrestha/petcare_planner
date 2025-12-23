// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:petcare_planner_frontend/views/dashboard/dashboard.dart';
import 'package:petcare_planner_frontend/views/get_started/get_started_one.dart';
import 'package:petcare_planner_frontend/widgets/slide_fade_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petcare_planner_frontend/utils/app_colors.dart';
import 'package:petcare_planner_frontend/views/auth/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!mounted) return;

    if (isFirstLaunch) {
      await prefs.setBool('isFirstLaunch', false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GetStartedOne()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        SlideFadeRoute(
          page: isLoggedIn ? const DashboardScreen() : const AuthScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  "assets/lottie/pet_splash_screen.json",
                  height: 160,
                  repeat: true,
                  frameRate: FrameRate.max,
                ),

                const Text(
                  "PetCare Planner",
                  style: TextStyle(
                    fontFamily: "Poppins-Bold",
                    fontSize: 28,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Care. Track. Love.",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
