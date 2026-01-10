// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/utils/app_colors.dart';
import 'package:petcare_planner_frontend/views/help_and_support/help_and_support.dart';
import 'package:petcare_planner_frontend/widgets/my_pets_section.dart';
import 'package:petcare_planner_frontend/widgets/notification_card.dart';
import 'package:petcare_planner_frontend/widgets/profile_card.dart';
import 'package:petcare_planner_frontend/widgets/support_card.dart';

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
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              ProfileCard(name: "Alvish", email: "alvish@gmail.com"),

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

              MyPetsSection(
                pets: [
                  Pet(
                    name: "Dolli",
                    breed: "Golden Retriever",
                    age: 3,
                    imageUrl: "https://placedog.net/100/100",
                  ),
                  Pet(
                    name: "Max",
                    breed: "Bulldog",
                    age: 2,
                    imageUrl: "https://placedog.net/101/101",
                  ),
                ],
                onPetTap: (pet) {
                  print("Tapped pet: ${pet.name}");
                  // Navigate or do something here
                },
                onAddNewPet: () {
                  print("Add New Pet pressed");
                  // Navigate to add pet screen or open dialog
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
