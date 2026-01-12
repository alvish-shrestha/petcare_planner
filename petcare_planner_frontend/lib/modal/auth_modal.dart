// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/utils/app_colors.dart';
import 'package:petcare_planner_frontend/view_models/auth_view_model.dart';
import 'package:petcare_planner_frontend/widgets/app_snackbar.dart';
import 'package:petcare_planner_frontend/widgets/auth_text_field.dart';
import 'package:petcare_planner_frontend/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class AuthModals {
  // ---  Forgot Password Modal ---
  static void showForgotPassword(BuildContext context) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => _BaseAuthModal(
        title: "Forgot Password",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: const Text(
                "Enter your registered email\naddress to reset your password.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Poppins-Medium",
                  color: AppColors.textPrimary,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Email",
              style: TextStyle(
                fontFamily: "Poppins-Medium",
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
            CustomTextField(
              hint: "Enter registered email",
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 25),
            Consumer<AuthViewModel>(
              builder: (context, viewModel, child) {
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    onPressed: viewModel.isLoading
                        ? null
                        : () async {
                            if (emailController.text.isNotEmpty) {
                              try {
                                await viewModel.forgotPassword(
                                  emailController.text.trim(),
                                );
                                Navigator.pop(context);

                                showConfirmEmail(
                                  context,
                                  emailController.text.trim(),
                                );
                              } catch (e) {
                                AppSnackBar.show(
                                  context,
                                  message: e.toString(),
                                  type: SnackBarType.error,
                                );
                              }
                            } else {
                              AppSnackBar.show(
                                context,
                                message: "Please enter your email",
                                type: SnackBarType.info,
                              );
                            }
                          },
                    child: viewModel.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Send Reset Link",
                            style: TextStyle(
                              fontFamily: "Poppins-Medium",
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- Confirm Email Modal ---
  static void showConfirmEmail(BuildContext context, String email) {
    showDialog(
      context: context,
      builder: (context) => _BaseAuthModal(
        title: "Confirm Email",
        child: Column(
          children: [
            const Text(
              "We sent a verification link to your\nemail address",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Poppins-Medium",
                color: AppColors.textPrimary,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              email,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: "Poppins-Bold",
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: const Text(
                "Please check your inbox and\nclick the verification link to\ncontinue",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Poppins-Medium",
                  color: AppColors.textPrimary,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Consumer<AuthViewModel>(
              builder: (context, viewModel, child) {
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    onPressed: viewModel.isLoading
                        ? null
                        : () async {
                            try {
                              await viewModel.forgotPassword(email);

                              AppSnackBar.show(
                                context,
                                message:
                                    "Verification link resent successfully!",
                                type: SnackBarType.success,
                              );
                            } catch (e) {
                              AppSnackBar.show(
                                context,
                                message: "Failed to resend: $e",
                                type: SnackBarType.error,
                              );
                            }
                          },
                    child: viewModel.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Resend Verification Link",
                            style: TextStyle(
                              fontFamily: "Poppins-Medium",
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- 3. Reset Password Modal ---
  static void showResetPassword(BuildContext context, String token) {
    final passController = TextEditingController();
    final confirmPassController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => _BaseAuthModal(
        title: "Reset Password",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "New Password",
              style: TextStyle(
                fontFamily: "Poppins-Medium",
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
            AuthTextField(
              hint: "Enter new password",
              controller: passController,
              isPassword: true,
            ),
            const SizedBox(height: 10),
            const Text(
              "Confirm Password",
              style: TextStyle(
                fontFamily: "Poppins-Medium",
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
            AuthTextField(
              hint: "Enter new password",
              controller: confirmPassController,
              isPassword: true,
            ),
            const SizedBox(height: 25),
            Consumer<AuthViewModel>(
              builder: (context, viewModel, child) {
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    onPressed: viewModel.isLoading
                        ? null
                        : () async {
                            if (passController.text ==
                                confirmPassController.text) {
                              try {
                                await viewModel.resetPassword(
                                  token,
                                  passController.text,
                                  confirmPassController.text,
                                );
                                Navigator.pop(context);

                                AppSnackBar.show(
                                  context,
                                  message:
                                      "Password reset successfully. Please login.",
                                  type: SnackBarType.success,
                                );
                              } catch (e) {
                                AppSnackBar.show(
                                  context,
                                  message: e.toString(),
                                  type: SnackBarType.error,
                                );
                              }
                            } else {
                              // USE CUSTOM SNACKBAR - INFO/ERROR
                              AppSnackBar.show(
                                context,
                                message: "Passwords do not match",
                                type: SnackBarType.error,
                              );
                            }
                          },
                    child: viewModel.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Reset",
                            style: TextStyle(
                              fontFamily: "Poppins-Medium",
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// --- Internal Reusable Wrapper ---
class _BaseAuthModal extends StatelessWidget {
  final String title;
  final Widget child;

  const _BaseAuthModal({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: "Poppins-Bold",
                    fontSize: 20,
                    color: Color(0xFF5D4E4E),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(color: Colors.black, thickness: 1),
            const SizedBox(height: 20),
            // Content
            child,
          ],
        ),
      ),
    );
  }
}
