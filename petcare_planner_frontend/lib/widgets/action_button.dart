import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;

  const ActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 300,
    this.height = 44,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7BAF9E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: "Poppins-Bold",
            fontSize: 16,
            color: Color(0xFFFDFDFD),
          ),
        ),
      ),
    );
  }
}
