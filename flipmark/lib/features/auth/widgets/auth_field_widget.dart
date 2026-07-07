import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  @override
  Widget build(BuildContext build) {
    return SizedBox(
      width: 250,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          //color: Colors.white.withValues(alpha: 0.1),
          color: Color(0xFFD5FFFF).withValues(alpha: 0.2),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.75),
            width: 1.0,
          ),
        ),
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            hintText: labelText,
            labelStyle: TextStyle(color: Colors.white),
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontWeight: FontWeight.w300,
            ),
          ),
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
        ),
      ),
    );
  }
}
