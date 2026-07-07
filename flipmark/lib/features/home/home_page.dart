import 'package:flipmark/features/auth/auth_service.dart';
import 'package:flipmark/features/auth/unified_auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flipmark/features/scanner/scanner_page.dart';
import '../themes/gradient_scaffold.dart';
import '../auth/widgets/snackbar_popup.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Menu();
  }
}

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _offsetAnimation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    _offsetAnimation = Tween<double>(begin: -16.0, end: 16.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: Theme(
        data: Theme.of(context).copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(150, 75),
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              foregroundColor: Colors.white,
              elevation: 0.0,
              side: BorderSide(
                color: Colors.black.withValues(alpha: 0.65),
                width: 2.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              textStyle: GoogleFonts.comicNeue(
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 35),
                  child: Text(
                    "Welcome Home",
                    style: GoogleFonts.comicNeue(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Text'),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ScannerPage(mode: "Camera"),
                              ),
                            );
                          },
                          child: const Text('Camera'),
                        ),
                        const SizedBox(height: 150),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ScannerPage(mode: "File"),
                              ),
                            );
                          },
                          child: const Text('File Entry'),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('History'),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: SweepGradient(
                      center: FractionalOffset.center,
                      colors: [
                        Color(0xFFCC0a00),
                        Color(0xFFFF8680),
                        Color(0xFFCC0a00),
                      ],
                    ),
                  ),
                  margin: const EdgeInsets.only(bottom: 30),
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await AuthService.authLogOut();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBarPopUp(
                              content: "Logout was successful.",
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
                              builder: (context) => UnifiedAuthPage(),
                            ),
                          );
                        }
                      } catch (error) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBarPopUp(
                              content: error.toString().trim(),
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
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        Colors.transparent,
                      ),
                      shadowColor: WidgetStatePropertyAll<Color>(
                        Colors.transparent,
                      ),
                      elevation: WidgetStatePropertyAll<double>(2.0),
                    ),
                    child: const Text('Log Out'),
                  ),
                ),
              ],
            ),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) => Transform.translate(
                offset: (Offset(0, -30 + _offsetAnimation.value)),
                child: Icon(
                  Icons.bookmarks_outlined,
                  size: 40,
                  color: Colors.greenAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
