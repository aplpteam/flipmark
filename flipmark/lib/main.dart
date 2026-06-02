
import 'package:flutter/material.dart';

import './features/auth/login_page.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: LoginPage(),
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
      );
  }
}
