import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/core/common/slide_fade_route.dart';
import 'package:petcare_planner_frontend/core/common/auth_text_field.dart';
import 'package:petcare_planner_frontend/core/common/widgets/action_button.dart';
import 'package:petcare_planner_frontend/features/auth/presentation/view/register.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7EDD9),
      body: SafeArea(
        child: Column(
          children: [
            /// --- Image Section with TextFields overlaid ---
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 392,
              child: Stack(
                children: [
                  // --- Image ---
                  Image.asset(
                    "assets/images/login.png",
                    width: MediaQuery.of(context).size.width,
                    height: 392,
                    fit: BoxFit.cover,
                  ),

                  // --- Text Fields ---
                  Align(
                    alignment: const Alignment(0, 2.9),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // SizedBox(height: 270),
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
                            height: 37,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  // TODO: Navigate to Forgot Password screen
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF000000),
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x4D000000),
                                  offset: const Offset(0, 4),
                                  blurRadius: 15,
                                  spreadRadius: 0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: ActionButton(
                              text: "Login",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  SlideFadeRoute(page: const RegisterForm()),
                                );
                              },
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
