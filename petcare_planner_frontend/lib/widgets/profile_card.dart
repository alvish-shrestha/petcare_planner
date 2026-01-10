// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/utils/app_colors.dart';
import 'package:petcare_planner_frontend/utils/user_api_utils.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String email;
  final String? profileImageUrl;
  final VoidCallback? onEdit;
  final VoidCallback? onAvatarTap;

  const ProfileCard({
    super.key,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.onEdit,
    this.onAvatarTap,
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
          GestureDetector(
            onTap: onAvatarTap,
            child: Container(
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
              child: CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.background,
                backgroundImage: profileImageUrl != null
                    ? NetworkImage(
                        UserApiUtils.getFullImageUrl(profileImageUrl!),
                      )
                    : null,

                child: profileImageUrl == null
                    ? const Icon(
                        Icons.image,
                        size: 30,
                        color: AppColors.primary,
                      )
                    : null,
              ),
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
              const SizedBox(height: 4),
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
