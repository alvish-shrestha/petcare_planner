import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petcare_planner_frontend/utils/app_colors.dart';

class CustomTimeField extends StatefulWidget {
  final TimeOfDay? initialTime;
  final ValueChanged<TimeOfDay>? onTimeChanged;
  final bool enabled;
  final String hint;
  final String imageAssetPath;

  const CustomTimeField({
    super.key,
    this.initialTime,
    this.onTimeChanged,
    this.enabled = true,
    this.hint = "Select time",
    required this.imageAssetPath,
  });

  @override
  State<CustomTimeField> createState() => _CustomTimeFieldState();
}

class _CustomTimeFieldState extends State<CustomTimeField> {
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
  }

  Future<void> _pickTime() async {
    if (!widget.enabled) return;

    final TimeOfDay now = TimeOfDay.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? now,
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      widget.onTimeChanged?.call(picked);
    }
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return widget.hint;
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _formatTime(_selectedTime);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: _pickTime,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color(0x19000000),
                offset: Offset(0, 2),
                blurRadius: 8,
              ),
            ],
            borderRadius: BorderRadius.circular(18),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Image.asset(
                widget.imageAssetPath,
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  displayText,
                  style: TextStyle(
                    fontFamily: "Poppins-Medium",
                    fontSize: 14,
                    color: _selectedTime != null
                        ? AppColors.textPrimary
                        : Colors.grey.shade400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
