import 'package:flutter/material.dart';

class PetcarePlanner extends StatelessWidget {
  const PetcarePlanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Petcare Planner"),
          backgroundColor: Color(0xFFFDF2DC),
        ),
        body: Center(child: Text("Hello Pet Owner")),
        backgroundColor: Color(0xFFFDF2DC),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
