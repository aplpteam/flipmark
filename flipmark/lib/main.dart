
import 'package:flutter/material.dart';

import './features/auth/login_page.dart';
import 'features/auth/signup_page.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SignUpPage(),
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
      );
  }
}
