import 'package:flutter/material.dart';

class CustomToggle extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const CustomToggle({super.key, this.initialValue = true, this.onChanged});

  @override
  State<CustomToggle> createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle> {
  late bool isOn;

  @override
  void initState() {
    super.initState();
    isOn = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isOn,
      onChanged: (value) {
        setState(() => isOn = value);
        widget.onChanged?.call(value);
      },
      activeThumbColor: Colors.white,
      activeTrackColor: const Color(0xFF7BAF9E),
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: const Color(0xFFA8D5BA),
    );
  }
}
