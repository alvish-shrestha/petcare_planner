// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/utils/app_colors.dart';

class DeleteModal extends StatelessWidget {
  const DeleteModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: AppColors.background,
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Section ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Confirm Delete',
                  style: TextStyle(
                    fontFamily: "Poppins-Bold",
                    fontSize: 20,
                    color: AppColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.textPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // --- Divider ---
            const Divider(
              color: AppColors.textPrimary,
              thickness: 1.5,
              height: 1,
            ),

            const SizedBox(height: 20),

            // --- Body Text ---
            const Text(
              'Are you sure you want to delete?',
              style: TextStyle(
                fontFamily: "Poppins-Medium",
                fontSize: 16,
                height: 1.4,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 30),

            // --- Action Buttons ---
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    textStyle: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                    ),
                  ),
                  child: const Text('Cancel'),
                ),

                const SizedBox(width: 16),

                // Delete Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    elevation: 4,
                    shadowColor: AppColors.primary.withOpacity(0.4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
