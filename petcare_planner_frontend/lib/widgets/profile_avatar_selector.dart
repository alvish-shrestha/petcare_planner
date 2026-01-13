// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/widgets/app_colors.dart';
import 'package:petcare_planner_frontend/utils/user_api_utils.dart';

class ProfileAvatarSelector extends StatelessWidget {
  final String? profileImageUrl;
  final VoidCallback? onAvatarTap;

  const ProfileAvatarSelector({
    super.key,
    this.profileImageUrl,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // --- The Avatar Circle ---
          GestureDetector(
            onTap: onAvatarTap,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipOval(
                child: profileImageUrl != null
                    ? Image.network(
                        UserApiUtils.getFullImageUrl(profileImageUrl!),
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_outlined,
                            size: 40,
                            color: Colors.black54,
                          );
                        },
                      )
                    : const Icon(
                        Icons.image_outlined,
                        size: 40,
                        color: Colors.black54,
                      ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // --- Change Photo Button ---
          InkWell(
            onTap: onAvatarTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                "Change Photo",
                style: TextStyle(
                  fontFamily: "Poppins-Medium",
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
