import 'package:buk/providers/language/language_enum.dart';
import 'package:buk/providers/language/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:translator/translator.dart';

class TranslateText extends StatefulWidget {
  final String text;
  final String? english;
  final String? ukrainian;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool selectable;

  const TranslateText({
    Key? key,
    required this.text,
    this.english,
    this.ukrainian,
    this.style,
    this.textAlign,
    this.selectable = true,
  }) : super(key: key);

  @override
  State<TranslateText> createState() => _TranslateTextState();
}

class _TranslateTextState extends State<TranslateText> {
  final Map translations = {};

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    translations["default"] = widget.text;

    if (widget.ukrainian == null) {
      translate(LanguageType.uk, translations["default"]).then((value) {
        if (!mounted) return;

        setState(() {
          if (!mounted) return;
          translations[LanguageType.uk] = value.toString();
        });
      });
    } else {
      translations[LanguageType.uk] = widget.ukrainian;
    }

    if (widget.english == null) {
      translate(LanguageType.en, translations["default"]).then((value) {
        if (!mounted) return;

        setState(() {
          translations[LanguageType.en] = value.toString();
        });
      });
    } else {
      translations[LanguageType.en] = widget.english;
    }
  }

  @override
  Widget build(BuildContext context) {
    return translations.containsKey(Provider.of<Language>(context).language)
        ? widget.selectable
            ? SelectableText(
                translations[Provider.of<Language>(context).language],
                style: widget.style,
                textAlign: widget.textAlign,
              )
            : Text(
                translations[Provider.of<Language>(context).language],
                style: widget.style,
                textAlign: widget.textAlign,
              )
        : Shimmer.fromColors(
            child: Container(
                color: Colors.grey[300], child: Text(translations["default"])),
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!);
  }

  Future<Translation> translate(LanguageType to, String text) async {
    final translator = GoogleTranslator();
    return await translator.translate(text, to: to.toString().split('.').last);
  }
}
