import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/features/auth/presentation/view/auth_text_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7EDD9),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 45),

            /// --- Title Section ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Text(
                    "PetCare Planner",
                    style: TextStyle(
                      fontFamily: "Poppins-Bold",
                      fontSize: 36,
                      color: Color(0xFF725E5E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 0),

            /// --- Image Section with TextFields overlaid ---
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 600,
              child: Stack(
                children: [
                  // --- Image ---
                  Image.asset(
                    "assets/images/register.png",
                    width: MediaQuery.of(context).size.width,
                    height: 392,
                    fit: BoxFit.cover,
                  ),

                  // --- Text Fields ---
                  Align(
                    alignment: const Alignment(0, 0.45),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          SizedBox(
                            width: 300,
                            child: AuthTextField(hint: "Username"),
                          ),
                          SizedBox(
                            width: 300,
                            child: AuthTextField(hint: "Email"),
                          ),
                          SizedBox(
                            width: 300,
                            child: AuthTextField(
                              hint: "Password",
                              isPassword: true,
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: AuthTextField(
                              hint: "Confirm Password",
                              isPassword: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
