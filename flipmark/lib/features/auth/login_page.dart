import 'package:flutter/material.dart';

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
      appBar: _genAppBar(),
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
}

List<Widget> _genChildren(
  TextEditingController emailController,
  TextEditingController passwordController,
) {
  List<Widget> children = [
    SizedBox(height: 160),
    _EmailUi(controller: emailController),
    SizedBox(height: 20),
    _PasswordUi(controller: passwordController),
    SizedBox(height: 35),
    SizedBox(
      width: 150,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.login_sharp),
        label: const Text(
          'Login',
          style: TextStyle(
            color: Color.fromARGB(255, 203, 196, 196),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconAlignment: IconAlignment.end,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(
            const Color.fromARGB(88, 0, 172, 126),
          ),
        ),
        onPressed: () {
          //logic if user enters wrong password/email/both/etc
          //firebase part
          print(emailController.text);
          print(passwordController.text);
        },
      ),
    ),
  ];
  return children;
}

PreferredSizeWidget _genAppBar() {
  return AppBar(
    title: Text(
      "Login to Flipmark!",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        color: Colors.blue,
      ),
    ),
    centerTitle: true,
    elevation: 2,
    shadowColor: Colors.black,
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(1.0),
      child: Container(
        height: 2,
        color: const Color.fromRGBO(158, 158, 158, 0.5),
      ),
    ),
  );
}

class _EmailUi extends StatelessWidget {
  const _EmailUi({required this.controller});

  final TextEditingController controller;
  @override
  Widget build(BuildContext build) {
    return SizedBox(
      width: 250,
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          labelText: 'Email',
        ),
        controller: controller,
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }
}

class _PasswordUi extends StatelessWidget {
  const _PasswordUi({required this.controller});

  final TextEditingController controller;
  @override
  Widget build(BuildContext build) {
    return SizedBox(
      width: 250,
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          labelText: 'Password',
        ),
        controller: controller,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
      ),
    );
  }
}
