import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:petcare_planner_frontend/petcare_planner.dart';
import 'package:petcare_planner_frontend/view_models/auth_view_model.dart';
import 'package:petcare_planner_frontend/view_models/pet_view_model.dart';
import 'package:petcare_planner_frontend/view_models/task_view_model.dart';

import 'package:petcare_planner_frontend/repository/pet_repository.dart';
import 'package:petcare_planner_frontend/repository/task_repository.dart';

import 'package:petcare_planner_frontend/services/pet_service.dart';
import 'package:petcare_planner_frontend/services/task_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        /// --- User ---
        ChangeNotifierProvider(create: (_) => AuthViewModel()),

        /// --- Pet ---
        ChangeNotifierProvider(
          create: (_) => PetViewModel(PetRepository(PetService())),
        ),

        /// --- Task ---
        ChangeNotifierProvider(
          create: (_) => TaskViewModel(TaskRepository(TaskService())),
        ),
      ],
      child: const PetcarePlanner(),
    ),
  );
}
