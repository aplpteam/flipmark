import 'package:flutter/material.dart';

class AuthToggleSelector extends StatelessWidget {
  final bool isLogin;
  final ValueChanged<bool> onToggle;
  final BorderRadius borderRadius;
  final double verticalPadding;
  final double horizontalPadding;
  
  // Custom Styling Parameters
  final Gradient loginGradient;
  final Gradient signUpGradient;

  const AuthToggleSelector({
    super.key,
    required this.isLogin,
    required this.onToggle,
    required this.borderRadius,
    this.verticalPadding = 2,
    this.horizontalPadding = 7,
    this.loginGradient = const LinearGradient(
      colors: [Color(0xFFFFC8DD), Color(0xFFFFAFCC)],
    ),
    this.signUpGradient = const LinearGradient(
      colors: [Color(0xFFD6EADF), Color(0xFFADF7B6)],
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: Colors.white.withValues(alpha: 0.2),
        ),
        child: Row(
          children: [
            // Login Tab Lane
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onToggle(true),
                child: AnimatedContainer(
                  padding: EdgeInsets.symmetric(
                    vertical: verticalPadding,
                    horizontal: horizontalPadding,
                  ),
                  duration: const Duration(milliseconds: 500),
                  alignment: Alignment.center,
                  decoration: isLogin
                      ? BoxDecoration(
                          borderRadius: borderRadius,
                          gradient: loginGradient,
                        )
                      : null,
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
            
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onToggle(false),
                child: AnimatedContainer(
                  padding: EdgeInsets.symmetric(
                    vertical: verticalPadding,
                    horizontal: horizontalPadding,
                  ),
                  duration: const Duration(milliseconds: 500),
                  alignment: Alignment.center,
                  decoration: !isLogin
                      ? BoxDecoration(
                          borderRadius: borderRadius,
                          gradient: signUpGradient,
                        )
                      : null,
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}