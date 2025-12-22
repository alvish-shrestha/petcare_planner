import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/utils/app_colors.dart';

class ReminderToggle extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const ReminderToggle({super.key, this.initialValue = true, this.onChanged});

  @override
  State<ReminderToggle> createState() => _ReminderToggleState();
}

class _ReminderToggleState extends State<ReminderToggle> {
  late bool isOn;

  @override
  void initState() {
    super.initState();
    isOn = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE1B3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_none, color: Colors.black),
          ),

          const SizedBox(width: 12),

          // --- Texts ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Set Reminder",
                  style: TextStyle(
                    fontFamily: "Poppins-Medium",
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Get notified 15 min before",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12,
                    color: Color(0xFF8B7355),
                  ),
                ),
              ],
            ),
          ),

          // --- Toggle ---
          Switch(
            value: isOn,
            onChanged: (value) {
              setState(() => isOn = value);
              widget.onChanged?.call(value);
            },
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFF7BAF9E),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Color(0xFFA8D5BA),
          ),
        ],
      ),
    );
  }
}
