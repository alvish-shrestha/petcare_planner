import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class TaskTypeCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final bool selected;
  final VoidCallback onTap;

  const TaskTypeCard({
    super.key,
    required this.label,
    required this.imagePath,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        height: 93,
        width: 75,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0x40000000),
                    offset: const Offset(0, 4),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ]
              : [
                  BoxShadow(
                    color: const Color(0x19000000),
                    offset: const Offset(0, 2),
                    blurRadius: 12,
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 32, height: 32, fit: BoxFit.contain),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Poppins-Medium",
                fontSize: 12,
                color: selected
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
