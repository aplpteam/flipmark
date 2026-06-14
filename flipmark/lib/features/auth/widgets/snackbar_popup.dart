import 'package:flutter/material.dart';

class SnackBarPopUp extends SnackBar {
  SnackBarPopUp({required String content, required Color color, super.key})
    : super(
        content: Text(content),
        backgroundColor: color,
        elevation: 1.5,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          side: BorderSide(color: Colors.white, width: 1.5),
        ),
      );
}
