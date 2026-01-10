// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/utils/app_colors.dart';
import 'package:petcare_planner_frontend/widgets/custom_toggle.dart';

class NotificationSettingsCard extends StatelessWidget {
  final List<NotificationSwitchItem> items;

  const NotificationSettingsCard({super.key, required this.items});

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.098),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(NotificationSwitchItem item) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.background,
          shape: BoxShape.circle,
        ),
        child: Icon(item.icon, color: AppColors.primary, size: 22),
      ),
      title: Text(
        item.title,
        style: TextStyle(
          fontFamily: "Poppins-Medium",
          fontSize: 15,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        item.subtitle,
        style: TextStyle(
          fontFamily: "Poppins",
          fontSize: 12,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: Transform.scale(
        scale: 0.8,
        child: CustomToggle(
          initialValue: item.value,
          onChanged: item.onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: _cardDecoration(),
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                _buildSwitchTile(items[i]),
                if (i != items.length - 1)
                  const Divider(
                    height: 1,
                    indent: 70,
                    endIndent: 20,
                    color: Color(0xFFEEEEEE),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class NotificationSwitchItem {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeTrackColor;

  NotificationSwitchItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    this.onChanged,
    this.activeTrackColor,
  });
}
