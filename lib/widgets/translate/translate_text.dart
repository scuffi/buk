import 'package:buk/providers/language/language_enum.dart';
import 'package:buk/providers/language/language_provider.dart';
import 'package:buk/widgets/translate/translate_cache.dart';
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
  final TextOverflow? overflow;

  const TranslateText({
    Key? key,
    required this.text,
    this.english,
    this.ukrainian,
    this.style,
    this.textAlign,
    this.selectable = true,
    this.overflow,
  }) : super(key: key);

  @override
  State<TranslateText> createState() => _TranslateTextState();
}

class _TranslateTextState extends State<TranslateText> {
  String? currentTranslation;

  @override
  Widget build(BuildContext context) {
    translate(
            Provider.of<Language>(context, listen: true).language, widget.text)
        .then((value) {
      if (!mounted) return;

      setState(() {
        currentTranslation = value;
      });
    });

    return Consumer<Language>(
      builder: ((context, value, child) {
        return currentTranslation != null
            ? widget.selectable
                ? SelectableText(
                    currentTranslation!,
                    style: widget.style,
                    textAlign: widget.textAlign,
                  )
                : Text(
                    currentTranslation!,
                    style: widget.style,
                    textAlign: widget.textAlign,
                    overflow: widget.overflow,
                  )
            : Shimmer.fromColors(
                child: Container(
                    color: Colors.grey[300], child: Text(widget.text)),
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!);
      }),
    );
  }

  Future<String> translate(LanguageType to, String text) async {
    // Check if this string has already been translated in the cache
    var cached = TranslateCache.check(text, to);
    if (cached != null) {
      return cached;
    }

    final translator = GoogleTranslator();
    try {
      var translation =
          await translator.translate(text, to: to.toString().split('.').last);

      // Add to cache so next translation is faster and doesn't require a request
      TranslateCache.addCache(text, translation.text, to);

      return translation.text;
    } catch (e) {
      return text;
    }
  }
}
