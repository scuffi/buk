import 'package:flutter/cupertino.dart';

class InitialProvider extends ChangeNotifier {
  String _username = "";
  bool _passed = false;
  bool _lang = true;

  String get username => _username;
  bool get passed => _passed;
  bool get lang => _lang;

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void reset() {
    _username = "";
    notifyListeners();
  }

  void setPassed(bool bool) {
    _passed = bool;
    notifyListeners();
  }

  void setLang(bool llang) {
    _lang = llang;
    notifyListeners();
  }
}
