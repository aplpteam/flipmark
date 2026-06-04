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
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          labelText: labelText,
        ),
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
      ),
    );
  }
}