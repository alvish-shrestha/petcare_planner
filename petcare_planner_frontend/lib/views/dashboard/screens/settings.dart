// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/modal/logout_modal.dart';
import 'package:petcare_planner_frontend/utils/app_colors.dart';
import 'package:petcare_planner_frontend/view_models/auth_view_model.dart';
import 'package:petcare_planner_frontend/view_models/pet_view_model.dart';
import 'package:petcare_planner_frontend/views/edit_profile/edit_profile_view.dart';
import 'package:petcare_planner_frontend/views/help_and_support/help_and_support.dart';
import 'package:petcare_planner_frontend/views/pet/add_pet.dart';
import 'package:petcare_planner_frontend/views/pet/edit_pet.dart';
import 'package:petcare_planner_frontend/widgets/my_pets_section.dart';
import 'package:petcare_planner_frontend/widgets/notification_card.dart';
import 'package:petcare_planner_frontend/widgets/profile_card.dart';
import 'package:petcare_planner_frontend/widgets/support_card.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Settings",
                    style: TextStyle(
                      fontFamily: "Poppins-Bold",
                      fontSize: 24,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x20000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.logout, color: AppColors.primary),
                      onPressed: () {
                        // Call the separated LogoutModal
                        showDialog(
                          context: context,
                          builder: (context) => const LogoutModal(),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              Consumer<AuthViewModel>(
                builder: (context, authVM, _) {
                  final user = authVM.user;
                  return ProfileCard(
                    name: user?.username ?? 'User',
                    email: user?.email ?? '',
                    profileImageUrl: user?.profileImageUrl,
                    onEdit: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => EditProfileScreen()),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 18),

              Text(
                "Notifications",
                style: TextStyle(
                  fontFamily: "Poppins-Bold",
                  fontSize: 18,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              NotificationSettingsCard(
                items: [
                  NotificationSwitchItem(
                    icon: Icons.notifications,
                    iconBg: const Color(0xFFFFCDD2),
                    iconColor: Colors.redAccent,
                    title: "Push Notifications",
                    subtitle: "Receive alerts for tasks and reminders",
                    value: true,
                    onChanged: (val) {
                      /* handle toggle */
                    },
                    activeTrackColor: Colors.redAccent,
                  ),
                  NotificationSwitchItem(
                    icon: Icons.assignment,
                    iconBg: const Color(0xFFC8E6C9),
                    iconColor: Colors.green,
                    title: "Task Reminders",
                    subtitle: "Get notified before scheduled tasks",
                    value: true,
                    onChanged: (val) {
                      /* handle toggle */
                    },
                    activeTrackColor: Colors.green,
                  ),
                  NotificationSwitchItem(
                    icon: Icons.volume_up,
                    iconBg: const Color(0xFFBBDEFB),
                    iconColor: Colors.blue,
                    title: "Sound & Vibration",
                    subtitle: "Enable notification sounds",
                    value: true,
                    onChanged: (val) {
                      /* handle toggle */
                    },
                    activeTrackColor: Colors.blue,
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Text(
                "My Pets",
                style: TextStyle(
                  fontFamily: "Poppins-Bold",
                  fontSize: 18,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              Consumer<PetViewModel>(
                builder: (context, petVM, _) {
                  if (petVM.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (petVM.pets.isEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "No pets found",
                          style: TextStyle(
                            fontFamily: "Poppins-Medium",
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AddPetScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text(
                              "Add New Pet",
                              style: TextStyle(
                                fontFamily: "Poppins-Medium",
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return MyPetsSection(
                    pets: petVM.pets,
                    onAddNewPet: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddPetScreen()),
                      );
                    },
                    onPetTap: (pet) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditPetScreen(pet: pet),
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 18),

              Text(
                "Support",
                style: TextStyle(
                  fontFamily: "Poppins-Bold",
                  fontSize: 18,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              SupportCard(
                icon: Icons.info_outline,
                iconBg: const Color(0xFFBBDEFB),
                iconColor: Colors.blue,
                title: "Help & Support",
                subtitle: "FAQs and contact us",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HelpSupportScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
