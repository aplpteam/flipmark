import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Menu();
  }
}

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Home Page'), centerTitle: true),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text("Welcome, User!"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(fixedSize: Size(150, 75)),
                      child: Text('Text Entry'),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(fixedSize: Size(150, 75)),
                      child: Text('Camera Scan'),
                    ),
                    SizedBox(height: 100),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(fixedSize: Size(150, 75)),
                      child: Text('File Entry'),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(fixedSize: Size(150, 75)),
                      child: Text('History'),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(fixedSize: Size(150, 75)),
                child: Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
