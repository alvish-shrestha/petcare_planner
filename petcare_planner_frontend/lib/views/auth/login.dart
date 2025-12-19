import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/view_models/auth_view_model.dart';
import 'package:petcare_planner_frontend/widgets/app_snackbar.dart';
// import 'package:petcare_planner_frontend/core/common/slide_fade_route.dart';
import 'package:petcare_planner_frontend/widgets/auth_text_field.dart';
import 'package:petcare_planner_frontend/widgets/action_button.dart';
// import 'package:petcare_planner_frontend/features/auth/presentation/view/register.dart';

class LoginForm extends StatelessWidget {
  final VoidCallback? onLoginSuccess;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final AuthViewModel authViewModel;

  const LoginForm({
    Key? key,
    this.onLoginSuccess,
    required this.emailController,
    required this.passwordController,
    required this.authViewModel,
  }) : super(key: key);

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
                "assets/images/login.png",
                width: MediaQuery.of(context).size.width,
                height: 392,
                fit: BoxFit.cover,
              ),

              // --- Text Fields ---
              Align(
                alignment: const Alignment(0, 0.82),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // SizedBox(height: 270),
                      SizedBox(
                        width: 300,
                        child: AuthTextField(
                          hint: "Email",
                          controller: emailController,
                        ),
                      ),

                      SizedBox(
                        width: 300,
                        child: AuthTextField(
                          hint: "Password",
                          controller: passwordController,
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
                        child: authViewModel.isLoading
                            ? const CircularProgressIndicator()
                            : ActionButton(
                                text: "Login",
                                onPressed: () async {
                                  await authViewModel.login(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  );

                                  if (authViewModel.errorMessage != null) {
                                    AppSnackBar.show(
                                      context,
                                      message: authViewModel.errorMessage!,
                                      type: SnackBarType.error,
                                    );
                                  } else if (authViewModel.user != null) {
                                    AppSnackBar.show(
                                      context,
                                      message: "Login Successful!",
                                      type: SnackBarType.success,
                                    );

                                    if (onLoginSuccess != null)
                                      onLoginSuccess!();
                                  }
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
