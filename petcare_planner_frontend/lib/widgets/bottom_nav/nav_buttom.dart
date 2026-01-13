import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/models/nav_items.dart';
import 'package:petcare_planner_frontend/widgets/app_colors.dart';
import '../app_animations.dart';

class NavButton extends StatelessWidget {
  final NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const NavButton({
    super.key,
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  IconData get _icon {
    switch (item) {
      case NavItem.home:
        return Icons.home_outlined;
      case NavItem.calendar:
        return Icons.calendar_today_outlined;
      case NavItem.rewards:
        return Icons.card_giftcard_outlined;
      case NavItem.settings:
        return Icons.settings_outlined;
    }
  }

  String get _label {
    switch (item) {
      case NavItem.home:
        return "Home";
      case NavItem.calendar:
        return "Calendar";
      case NavItem.rewards:
        return "Rewards";
      case NavItem.settings:
        return "Settings";
    }
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth;
    if (!isActive) {
      buttonWidth = 70;
    } else {
      switch (item) {
        case NavItem.calendar:
          buttonWidth = 140;
          break;
        default:
          buttonWidth = 120;
      }
    }
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppAnimations.navDuration,
        curve: AppAnimations.navCurve,
        width: buttonWidth,
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF8FB8A8) : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              _icon,
              color: isActive ? Color(0xFFFDFDFD) : AppColors.primary,
              size: isActive ? 18 : 18,
            ),
            if (isActive) ...[
              const SizedBox(width: 2),
              Flexible(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isActive ? 1 : 0,
                  child: Text(
                    _label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFFDFDFD),
                      fontSize: 14,
                      fontFamily: "Poppins-Medium",
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
