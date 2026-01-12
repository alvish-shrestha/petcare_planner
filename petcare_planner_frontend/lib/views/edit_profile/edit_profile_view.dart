// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/utils/app_colors.dart';
import 'package:petcare_planner_frontend/view_models/auth_view_model.dart';
import 'package:petcare_planner_frontend/widgets/action_button.dart';
import 'package:petcare_planner_frontend/widgets/app_snackbar.dart';
import 'package:petcare_planner_frontend/widgets/custom_text_field.dart';
import 'package:petcare_planner_frontend/widgets/profile_avatar_selector.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    final user = context.read<AuthViewModel>().user;

    _usernameController = TextEditingController(text: user?.username ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // --- Header ---
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                size: 18,
                                color: AppColors.textPrimary,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                        Text(
                          "Edit Profile",
                          style: TextStyle(
                            fontFamily: "Poppins-Bold",
                            fontSize: 24,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // --- Profile Image ---
                    Consumer<AuthViewModel>(
                      builder: (context, authVM, _) {
                        final user = authVM.user;
                        return ProfileAvatarSelector(
                          profileImageUrl: user?.profileImageUrl,
                          onAvatarTap: () async {
                            try {
                              await authVM.pickAndUploadProfileImage();
                              AppSnackBar.show(
                                context,
                                message: "Profile Image Uploaded",
                                type: SnackBarType.success,
                              );
                            } catch (e) {
                              AppSnackBar.show(
                                context,
                                message: "Failed to update profile image: $e",
                                type: SnackBarType.error,
                              );
                            }
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    // --- Fields ---
                    _buildLabel("Username"),
                    CustomTextField(
                      hint: "Username",
                      controller: _usernameController,
                    ),

                    const SizedBox(height: 15),

                    _buildLabel("Email"),
                    CustomTextField(
                      hint: "Email",
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 35),

                    // --- Change Password ---
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.20),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.098),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Change Password",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 15,
                                    color: AppColors.black,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: AppColors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            /// --- Save Button ---
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 4),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: ActionButton(
                  text: "Save",
                  onPressed: () async {
                    final authVM = context.read<AuthViewModel>();

                    try {
                      await authVM.updateProfile(
                        username: _usernameController.text.trim(),
                        email: _emailController.text.trim(),
                      );

                      AppSnackBar.show(
                        context,
                        message: "Profile updated successfully",
                        type: SnackBarType.success,
                      );

                      Navigator.pop(context);
                    } catch (e) {
                      AppSnackBar.show(
                        context,
                        message: e.toString(),
                        type: SnackBarType.error,
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 5),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: "Poppins-Medium",
          fontSize: 14,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
