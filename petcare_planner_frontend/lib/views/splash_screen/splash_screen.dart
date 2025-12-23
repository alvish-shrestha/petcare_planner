// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/views/auth/auth_screen.dart';
import 'package:petcare_planner_frontend/views/dashboard/dashboard.dart';
import 'package:petcare_planner_frontend/views/get_started/get_started_one.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // optional splash delay

    if (!seenOnboarding) {
      // First time user
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GetStartedOne()),
      );
    } else if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
