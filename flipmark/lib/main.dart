import 'package:flipmark/features/auth/unified_auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flipmark/features/auth/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.comicNeueTextTheme(Theme.of(context).textTheme),
      ),
      home: const UnifiedAuthPage(),
    );
  }
}
