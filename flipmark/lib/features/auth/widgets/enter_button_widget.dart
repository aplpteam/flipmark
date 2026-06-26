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
      width: 150,
      child: ElevatedButton.icon(
        icon: icon,
        label: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        iconAlignment: IconAlignment.end,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(
            const Color.fromARGB(208, 6, 213, 20),
          ),
          foregroundColor: WidgetStatePropertyAll<Color>(Colors.black),
        ),
        onPressed: onPressed,
        autofocus: true,
      ),
    );
  }
}
