import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/view_models/auth_view_model.dart';
import 'package:petcare_planner_frontend/widgets/app_snackbar.dart';
// import 'package:petcare_planner_frontend/core/common/slide_fade_route.dart';
import 'package:petcare_planner_frontend/widgets/auth_text_field.dart';
import 'package:petcare_planner_frontend/widgets/action_button.dart';
// import 'package:petcare_planner_frontend/features/auth/presentation/view/login.dart';

class RegisterForm extends StatelessWidget {
  final VoidCallback? onRegisterSuccess;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final AuthViewModel authViewModel;

  const RegisterForm({
    Key? key,
    this.onRegisterSuccess,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
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
                        child: AuthTextField(
                          hint: "Username",
                          controller: usernameController,
                        ),
                      ),
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
                        child: AuthTextField(
                          hint: "Confirm Password",
                          controller: confirmPasswordController,
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
                        child: authViewModel.isLoading
                            ? const CircularProgressIndicator()
                            : ActionButton(
                                text: "Register",
                                onPressed: () async {
                                  await authViewModel.register(
                                    usernameController.text.trim(),
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                    confirmPasswordController.text.trim(),
                                  );

                                  if (authViewModel.errorMessage != null) {
                                    AppSnackBar.show(
                                      context,
                                      message: authViewModel.errorMessage!,
                                      type: SnackBarType.error,
                                    );
                                  } else {
                                    AppSnackBar.show(
                                      context,
                                      message: "Registered successfully!",
                                      type: SnackBarType.success,
                                    );
                                    if (onRegisterSuccess != null)
                                      onRegisterSuccess!();
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
