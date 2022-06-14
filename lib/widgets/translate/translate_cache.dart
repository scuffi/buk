import 'package:buk/providers/language/language_enum.dart';

class TranslateCache {
  static final Map cacheUkraine = {};
  static final Map cacheEnglish = {};

  static void addCache(String from, String to, LanguageType langTo) {
    langTo == LanguageType.en
        ? cacheUkraine[from] = to
        : cacheEnglish[from] = to;
  }

  static String? check(String text, LanguageType langTo) {
    return langTo == LanguageType.en ? cacheUkraine[text] : cacheEnglish[text];
  }
}
