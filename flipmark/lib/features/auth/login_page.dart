import 'package:flipmark/features/auth/auth_service.dart';
import 'package:flipmark/features/auth/widgets/snackbar_popup.dart';
import 'package:flipmark/features/home/home_page.dart';
import 'package:flutter/material.dart';
import 'widgets/auth_field_widget.dart';
import 'widgets/enter_button_widget.dart';
import 'widgets/auth_appbar_widget.dart';
import 'signup_page.dart';
import 'widgets/navigation_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AuthAppBar(title: 'Login to Flipmark'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _genChildren(
                _emailController,
                _passwordController,
                context,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _genChildren(
    TextEditingController emailController,
    TextEditingController passwordController,
    BuildContext context,
  ) {
    List<Widget> children = [
      SizedBox(height: 160),
      AuthTextField(
        controller: emailController,
        labelText: 'Email',
        keyboardType: TextInputType.emailAddress,
      ),
      SizedBox(height: 20),
      AuthTextField(
        controller: passwordController,
        labelText: 'Password',
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
      ),
      SizedBox(height: 35),
      EnterButton(
        label: 'Login',
        onPressed: () async {
          final String? isValidEntry = _verifyFields(
            emailController.text,
            passwordController.text,
          );

          if (isValidEntry != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBarPopUp(content: isValidEntry, color: Colors.redAccent),
              snackBarAnimationStyle: AnimationStyle(
                curve: Curves.easeOutBack,
                duration: Duration(milliseconds: 400),
                reverseDuration: Duration(milliseconds: 200),
              ),
            );
            return;
          }
          try {
            await AuthService.authSignIn(
              emailAddress: emailController.text.trim(),
              password: passwordController.text.trim(),
            );
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBarPopUp(
                  content: "Login was successful, logging in",
                  color: Colors.greenAccent,
                ),
                snackBarAnimationStyle: AnimationStyle(
                  curve: Curves.easeOutBack,
                  duration: Duration(milliseconds: 400),
                  reverseDuration: Duration(milliseconds: 200),
                ),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(builder: (context) => HomePage()),
              );
            }
          } catch (errorMessage) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBarPopUp(
                  content: errorMessage.toString(),
                  color: Colors.redAccent,
                ),
                snackBarAnimationStyle: AnimationStyle(
                  curve: Curves.easeOutBack,
                  duration: Duration(milliseconds: 400),
                  reverseDuration: Duration(milliseconds: 200),
                ),
              );
            }
          }
        },
      ),
      SizedBox(height: 10),
      NavigationText(
        normalText: "Don't have an account yet?",
        buttonedText: "Sign Up!",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => SignUpPage(),
              requestFocus: true,
            ),
          );
        },
      ),
    ];
    return children;
  }

  String? _verifyFields(final String email, final String password) {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      return "A field may be empty, please ensure all fields have characters";
    }
    if (!email.contains('@') || !email.contains('.')) {
      return "Email missing period identifier or @ symbol";
    }
    return null;
  }
}
