import 'package:flutter/material.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthAppBar({
    super.key,
    required this.title,
    this.textColor = Colors.blue,
  });
  final String title;
  final Color textColor;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 2);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
          color: textColor,
        ),
      ),
      centerTitle: true,
      elevation: 2,
      shadowColor: Colors.black,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          height: 2,
          color: const Color.fromRGBO(158, 158, 158, 0.5),
        ),
      ),
    );
  }
}
