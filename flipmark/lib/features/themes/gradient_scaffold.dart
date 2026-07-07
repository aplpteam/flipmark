import 'package:flutter/material.dart';

class GradientScaffold extends StatelessWidget {
  final Widget child;
  final bool useSafeArea;
  final PreferredSizeWidget? appBar;
  final List<Color> colorList;
  const GradientScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.useSafeArea = true,
    this.colorList = const [
      Color.fromARGB(255, 172, 155, 219),
      Color.fromARGB(255, 152, 61, 209),
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colorList,
            stops: [0.4, 0.8],
          ),
        ),
        child: useSafeArea ? SafeArea(child: child) : child,
      ),
    );
  }
}
