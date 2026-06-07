//required packages
import 'package:flutter/material.dart';

//custom widgets
import 'widgets/auth_appbar_widget.dart';
import 'widgets/auth_field_widget.dart';
import 'widgets/enter_button_widget.dart';
import 'widgets/navigation_text.dart';
import 'login_page.dart';

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
                  onPressed: () {
                    print("pressed");
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
}
