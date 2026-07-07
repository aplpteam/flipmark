import 'package:flutter/material.dart';

class SocialIconButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onPressed;

  const SocialIconButton({
    super.key,
    required this.assetPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(12.0), 
        child: Image.asset(
          assetPath,
          height: 32, 
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}