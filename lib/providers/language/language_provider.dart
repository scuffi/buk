import 'package:buk/providers/language/language_enum.dart';
import 'package:flutter/material.dart';

class Language with ChangeNotifier {
  LanguageType _lang = LanguageType.en;

  LanguageType get language => _lang;

  void setLang(LanguageType lang) {
    _lang = lang;
    notifyListeners();
  }

  void resetLang() {
    _lang = LanguageType.en;
    notifyListeners();
  }
}
