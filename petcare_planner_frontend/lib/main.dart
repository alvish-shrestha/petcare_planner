import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/petcare_planner.dart';
import 'package:provider/provider.dart';
import 'package:petcare_planner_frontend/view_models/auth_view_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: const PetcarePlanner(),
    ),
  );
}
