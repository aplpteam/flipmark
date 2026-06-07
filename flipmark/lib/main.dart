
import 'package:flutter/material.dart';
import 'package:flipmark/features/home/home_page.dart';
import 'package:flipmark/features/auth/login_page.dart';
import 'package:flipmark/features/auth/signup_page.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: LoginPage(),
    );
  }
}
