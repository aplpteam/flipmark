import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static Future<UserCredential> authCreateAccount({
    required String emailAddress,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_authMapError(e));
    }
  }

  static Future<UserCredential> authSignIn({
    required String emailAddress,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
        throw _authMapError(e);
    }
  }

  static Future<void> authSignOut() async{
    await FirebaseAuth.instance.signOut();
  }

  static String _authMapError(FirebaseAuthException e) {
    switch (e.code) {
      //create account errors
      case 'weak-password':
        return 'Password is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled.';
      //sign up errors

      case 'user-not-found':
        return 'No user found for this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'user-disabled':
        return 'This account has been disabled';

      // General errors
      case 'invalid-email':
        return 'Invalid email address.';

      case 'too-many-requests':
        return 'Too many attempts. Try again later.';

      case 'network-request-failed':
        return 'No internet connection.';

      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
