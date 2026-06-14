//required packages
import 'package:flutter/material.dart';

//custom widgets
import 'widgets/auth_appbar_widget.dart';
import 'widgets/auth_field_widget.dart';
import 'widgets/enter_button_widget.dart';
import 'widgets/navigation_text.dart';
import 'widgets/snackbar_popup.dart';
//other screens and classes
import '../home/home_page.dart';
import 'auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _verifyPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _verifyPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AuthAppBar(
        title: 'Sign Up To Flipmark!',
        textColor: Colors.yellow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                AuthTextField(controller: _nameController, labelText: 'Name'),
                SizedBox(height: 15),
                AuthTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 15),
                AuthTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                SizedBox(height: 15),
                AuthTextField(
                  controller: _verifyPasswordController,
                  labelText: 'Verify Password',
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                SizedBox(height: 25),
                EnterButton(
                  label: 'Sign Up',
                  onPressed: () async {
                    String? validVerify = _verifyPassword(
                      _nameController.text,
                      _emailController.text,
                      _passwordController.text,
                      _verifyPasswordController.text,
                    );

                    if (validVerify != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBarPopUp(
                          content: validVerify,
                          color: Colors.redAccent,
                        ),
                        snackBarAnimationStyle: AnimationStyle(
                          curve: Curves.easeOutBack,
                          duration: Duration(milliseconds: 400),
                          reverseDuration: Duration(milliseconds: 200),
                        ),
                      );
                      return;
                    }
                    try {
                      await AuthService.authCreateAccount(
                        emailAddress: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBarPopUp(
                            content: "Account Created Successfully",
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
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => HomePage(),
                          ),
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
                  icon: Icon(Icons.arrow_forward),
                ),
                SizedBox(height: 10),
                NavigationText(
                  normalText: "Already have an account?",
                  buttonedText: "Login!",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _verifyPassword(
    final String name,
    final String email,
    final String password,
    final String verifyPassword,
  ) {
    if (name.trim().isEmpty ||
        email.trim().isEmpty ||
        password.trim().isEmpty ||
        verifyPassword.trim().isEmpty) {
      return "A field may be empty, please ensure all fields have characters";
    }
    if (!email.contains('@') || !email.contains('.')) {
      return "Email missing period identifier or @ symbol";
    }

    if (password.trim().length < 8) {
      return "Password length less than 8 characters";
    }

    if (password.trim() != verifyPassword.trim()) {
      return "passwords do not match";
    }

    return null;
  }
}
