import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/models/nav_items.dart';
import 'package:petcare_planner_frontend/utils/app_colors.dart';
import 'package:petcare_planner_frontend/widgets/bottom_nav/nav_buttom.dart';

class CustomBottomNav extends StatelessWidget {
  final NavItem current;
  final ValueChanged<NavItem> onChanged;

  const CustomBottomNav({
    super.key,
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
      child: Container(
        height: 58,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 6),
              color: Colors.black.withValues(alpha: 0.18),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: NavItem.values.map((item) {
            return NavButton(
              item: item,
              isActive: item == current,
              onTap: () => onChanged(item),
            );
          }).toList(),
        ),
      ),
    );
  }
}
