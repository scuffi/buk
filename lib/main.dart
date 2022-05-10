import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:tab_indicator_styler/tab_indicator_styler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    var _bottomNavIndex = 0;

    return MaterialApp(
        home: Scaffold(
      body: Container(child: ListView.builder(itemBuilder: (_, index) {
        return Container(
          width: 500,
          height: 500,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1.0),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
        );
      })),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('Floating action button pressed');
          },
          child: const Icon(Icons.add)

          //params
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const [
          Icons.home,
          Icons.search,
          Icons.add_circle_outline,
          Icons.settings
        ],
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        notchSmoothness: NotchSmoothness.smoothEdge,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        //other params
      ),
    ));
  }
}
