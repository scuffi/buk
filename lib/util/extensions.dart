import 'package:buk/providers/language/language_enum.dart';
import 'package:translator/translator.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

extension TranslateExtension on String {
  static final translator = GoogleTranslator();

  Future<String> translate(LanguageType lang, String? translation) async {
    // Check if we don't need to actually translate this item
    if (translation != null && lang == LanguageType.uk) {
      return translation;
    }

    return translator
        .translate(this, to: lang.toString().split('.').last)
        .toString();
  }
}
