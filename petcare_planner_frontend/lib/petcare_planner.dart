import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/views/get_started/get_started_one.dart';

class PetcarePlanner extends StatelessWidget {
  const PetcarePlanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetStartedOne(),
      debugShowCheckedModeBanner: false,
    );
  }
}
