import 'package:flutter/material.dart';

class GitHubButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const GitHubButton({
    super.key,
    required this.onPressed,
    this.label = "Sign Up with GitHub",
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 253,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/github_logo.png', height: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
