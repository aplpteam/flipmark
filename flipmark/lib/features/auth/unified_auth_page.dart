import 'package:flutter/material.dart';
import 'widgets/auth_toggle_widget.dart';
import 'widgets/auth_field_widget.dart';
import 'package:flipmark/features/auth/auth_service.dart';
import 'package:flipmark/features/auth/widgets/snackbar_popup.dart';
import 'widgets/enter_button_widget.dart';
import '../home/home_page.dart';
import 'widgets/social_icon_widget.dart';
import '../themes/gradient_scaffold.dart';

final Color backgroundColor = Color(0xFFB4A7EA);
final BorderRadius radius = BorderRadius.circular(12);
final double verticalPadding = 2;
final double horizontalPadding = 7;

class UnifiedAuthPage extends StatefulWidget {
  const UnifiedAuthPage({super.key});

  @override
  State<UnifiedAuthPage> createState() => _UnifiedAuthPageState();
}

class _UnifiedAuthPageState extends State<UnifiedAuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _verifyPasswordController =
      TextEditingController();
  bool isLogin = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _verifyPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Text(
                    "Welcome,",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Flipmark is waiting!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 50),
                  AuthToggleSelector(
                    isLogin: isLogin,
                    onToggle: (value) => setState(() => isLogin = value),
                    borderRadius: radius,
                  ),
                  SizedBox(height: 30),
                  AuthTextField(
                    controller: _emailController,
                    labelText: "Email",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 15),
                  AuthTextField(
                    controller: _passwordController,
                    labelText: "Password",
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  SizedBox(height: 15),
                  if (!isLogin) ...[
                    AuthTextField(
                      controller: _verifyPasswordController,
                      labelText: "Verify Password",
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                  ],
                  SizedBox(height: 30),
                  EnterButton(
                    label: isLogin ? 'Login' : 'Sign Up',
                    onPressed: () async {
                      if (isLogin) {
                        final String? isValidEntry = _verifyFields(
                          _emailController.text,
                          _passwordController.text,
                        );

                        if (isValidEntry != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBarPopUp(
                              content: isValidEntry,
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
                          await AuthService.authSignIn(
                            emailAddress: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
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
                              MaterialPageRoute<void>(
                                builder: (context) => HomePage(),
                              ),
                            );
                          }
                        } catch (errorMessage) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBarPopUp(
                                content: errorMessage
                                    .toString()
                                    .replaceAll(
                                      "[firebase_auth/invalid-credential]",
                                      "",
                                    )
                                    .trim(),
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
                      } else {
                        String? validVerify = _verifyPassword(
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
                      }
                    },
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.white.withValues(alpha: 0.3),
                          thickness: 1.5,
                          endIndent: 10,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "or",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.67),
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.white.withValues(alpha: 0.3),
                          thickness: 1.5,
                          indent: 10,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialIconButton(
                        assetPath: 'assets/google_logo.jpg',
                        onPressed: () async {
                          try {
                            final credential =
                                await AuthService.authSignInWithGoogle();

                            if (credential == null) return;

                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => HomePage()),
                              );
                            }
                          } catch (errorMessage) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBarPopUp(
                                  content: errorMessage.toString(),
                                  color: Colors.redAccent,
                                ),
                              );
                            }
                          }
                        },
                      ),
                      SizedBox(width: 50),
                      SocialIconButton(
                        assetPath: 'assets/github_logo.png',
                        onPressed: () async {
                          try {
                            final credential =
                                await AuthService.authSignInWithGitHub();

                            if (credential == null) return;

                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => HomePage()),
                              );
                            }
                          } catch (errorMessage) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBarPopUp(
                                  content: errorMessage.toString(),
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
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

  String? _verifyPassword(
    final String email,
    final String password,
    final String verifyPassword,
  ) {
    if (email.trim().isEmpty ||
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
