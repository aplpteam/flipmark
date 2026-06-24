import 'package:flutter/material.dart';

class NavigationText extends StatelessWidget {
  const NavigationText({
    super.key,
    required this.normalText,
    required this.buttonedText,
    required this.onPressed,
  });

  final String normalText;
  final String buttonedText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(normalText),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Text(
            buttonedText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.amber,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
