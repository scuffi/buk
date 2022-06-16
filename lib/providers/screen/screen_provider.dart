import 'package:buk/screens/feed_screen.dart';
import 'package:flutter/material.dart';

class Screen with ChangeNotifier {
  Widget _screen = const FeedScreen();

  Widget get screen => _screen;

  void setScreen(Widget screen, BuildContext context) {
    _screen = screen;
    notifyListeners();
  }
}
