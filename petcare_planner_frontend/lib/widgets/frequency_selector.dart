import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/utils/app_colors.dart';

class FrequencySelector extends StatelessWidget {
  FrequencySelector({super.key});

  final ValueNotifier<String> selectedFrequency = ValueNotifier("None");

  final List<String> options = ["None", "Daily", "Weekly", "Monthly"];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: selectedFrequency,
      builder: (context, selected, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: options.map((option) {
            final isSelected = selected == option;
            return GestureDetector(
              onTap: () => selectedFrequency.value = option,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
                width: 80,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x19000000),
                      offset: Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: 13,
                      color: isSelected
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
