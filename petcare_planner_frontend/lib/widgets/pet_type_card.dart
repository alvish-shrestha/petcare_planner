import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class PetTypeCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final bool selected;
  final VoidCallback onTap;

  const PetTypeCard({
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
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFE8E3) : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: selected ? null : null,
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
          children: [
            Image.asset(imagePath, width: 32, height: 32, fit: BoxFit.contain),
            const SizedBox(height: 18),
            Text(
              label,
              style: const TextStyle(
                fontFamily: "Poppins-SemiBold",
                fontSize: 14,
                color: Color(0xFF2C2C2C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
