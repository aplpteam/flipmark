import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // -----------------------------
  // EMAIL + PASSWORD SIGN UP
  // -----------------------------
  static Future<UserCredential> authCreateAccount({
    required String emailAddress,
    required String password,
  }) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
  }

  // -----------------------------
  // EMAIL + PASSWORD LOGIN
  // -----------------------------
  static Future<UserCredential> authSignIn({
    required String emailAddress,
    required String password,
  }) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
  }

  // -----------------------------
  // GOOGLE SIGN-IN (WEB + ANDROID)
  // -----------------------------
  static Future<UserCredential?> authSignInWithGoogle() async {
    if (kIsWeb) {
      // WEB FLOW
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider
        ..addScope('email')
        ..setCustomParameters({'prompt': 'select_account'});

      return await FirebaseAuth.instance.signInWithPopup(googleProvider);
    } else {
      // ANDROID FLOW
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }
}
