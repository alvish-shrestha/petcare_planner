// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/utils/app_colors.dart';

// The new ProfileCard component
class ProfileCard extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback? onEdit;

  const ProfileCard({
    super.key,
    required this.name,
    required this.email,
    this.onEdit,
  });

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.098),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  offset: const Offset(0, 2),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFFFDF6E3),
              child: Icon(Icons.image, size: 30, color: AppColors.primary),
            ),
          ),

          const SizedBox(width: 20),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontFamily: "Poppins-Bold",
                  fontSize: 20,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                email,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, color: AppColors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
