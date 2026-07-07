import 'package:flutter/material.dart';

class EnterButton extends StatelessWidget {
  const EnterButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = const Icon(Icons.login_sharp),
  });

  final String label;
  final VoidCallback onPressed;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: ElevatedButton.icon(
        icon: icon,
        label: Text(label, style: TextStyle(fontWeight: FontWeight.w900)),
        iconAlignment: IconAlignment.end,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
          foregroundColor: WidgetStatePropertyAll<Color>(Colors.black),
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(vertical: 18.5),
          ),
          side: WidgetStatePropertyAll<BorderSide>(BorderSide(
            color: Colors.black.withValues(alpha: 0.7),
            width: 2.0,
            strokeAlign: 1.0,
          )),
          shape: WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
            )
          ),
        ),
        onPressed: onPressed,
        autofocus: true,
      ),
    );
  }
}
