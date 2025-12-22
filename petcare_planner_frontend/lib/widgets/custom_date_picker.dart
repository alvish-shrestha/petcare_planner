import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateField extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime>? onDateChanged;
  final bool enabled;
  final String hint;
  final String imageAssetPath;

  const CustomDateField({
    super.key,
    this.initialDate,
    this.onDateChanged,
    this.enabled = true,
    this.hint = "Select date",
    required this.imageAssetPath,
  });

  @override
  State<CustomDateField> createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  Future<void> _pickDate() async {
    if (!widget.enabled) return;

    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onDateChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String displayText = _selectedDate != null
        ? DateFormat('MMM dd, yyyy').format(_selectedDate!)
        : widget.hint;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: _pickDate,
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
                    color: _selectedDate != null
                        ? Colors.black
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
