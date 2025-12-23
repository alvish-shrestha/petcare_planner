import 'package:flutter/material.dart';
// import 'package:petcare_planner_frontend/views/get_started/get_started_one.dart';
import 'package:petcare_planner_frontend/views/splash_screen/splash_screen.dart';

class PetcarePlanner extends StatelessWidget {
  const PetcarePlanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SplashScreen(), debugShowCheckedModeBanner: false);
  }
}
