import 'package:buk/providers/language/language_enum.dart';
import 'package:buk/providers/language/language_provider.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class LikeFeedEmpty extends StatelessWidget {
  const LikeFeedEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Center(
          child: GradientText(
            Provider.of<Language>(context, listen: false).language ==
                    LanguageType.en
                ? "Oh No!"
                : "O ні!",
            colors: [Colors.purple[900]!, Colors.pinkAccent],
            style: GoogleFonts.lato(
              textStyle:
                  const TextStyle(fontSize: 100.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: 300,
            child: TranslateText(
              text:
                  "It looks like nothing is here, try clicking the bookmark on the top right of a post you want to remember.",
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.lato(textStyle: const TextStyle(fontSize: 22.0)),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
