import 'package:flutter/material.dart';
import 'widgets/auth_field_widget.dart';
import 'widgets/enter_button_widget.dart';
import 'widgets/auth_appbar_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
              children: _genChildren(_emailController, _passwordController),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _genChildren(
    TextEditingController emailController,
    TextEditingController passwordController,
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
        onPressed: () {
          print(emailController.text);
          print(passwordController.text);
        },
      ),
    ];
    return children;
  }
}
