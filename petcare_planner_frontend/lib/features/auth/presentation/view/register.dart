import 'package:flutter/material.dart';
// import 'package:petcare_planner_frontend/core/common/slide_fade_route.dart';
import 'package:petcare_planner_frontend/core/common/auth_text_field.dart';
import 'package:petcare_planner_frontend/core/common/widgets/action_button.dart';
// import 'package:petcare_planner_frontend/features/auth/presentation/view/login.dart';

class RegisterForm extends StatelessWidget {
  final VoidCallback? onRegisterSuccess;

  const RegisterForm({Key? key, this.onRegisterSuccess}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// --- Image Section with TextFields overlaid ---
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 550,
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
                alignment: const Alignment(0, 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 300,
                        child: AuthTextField(hint: "Username"),
                      ),
                      SizedBox(width: 300, child: AuthTextField(hint: "Email")),
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

                      const SizedBox(height: 24),

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
                          text: "Register",
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   SlideFadeRoute(page: const LoginForm()),
                            // );
                            if (onRegisterSuccess != null) {
                              onRegisterSuccess!();
                            }
                            print("Register pressed");
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
    );
  }
}
