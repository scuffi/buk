import 'package:buk/providers/language/language_enum.dart';
import 'package:buk/providers/language/language_provider.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class FeedEmpty extends StatelessWidget {
  const FeedEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Center(
          child: Provider.of<Language>(context, listen: false).language ==
                  LanguageType.en
              ? GradientText(
                  "Oh No!",
                  colors: [Colors.purple[900]!, Colors.pinkAccent],
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontSize: 100.0, fontWeight: FontWeight.bold),
                  ),
                )
              : GradientText(
                  "O ні!",
                  colors: [Colors.purple[900]!, Colors.pinkAccent],
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontSize: 100.0, fontWeight: FontWeight.bold),
                  ),
                ),
        ),
        Center(
          child: SizedBox(
            width: 300,
            child: TranslateText(
              text:
                  "It looks like nothing is here, why don't you create a post to make it less empty?",
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.lato(textStyle: const TextStyle(fontSize: 22.0)),
            ),
          ),
        ),
        // const Spacer(),
        const Padding(
          padding: EdgeInsets.only(bottom: 50.0, top: 60.0),
          child: Center(
            child: Icon(
              Icons.arrow_downward_rounded,
              size: 96,
            ),
          ),
        ),
      ],
    );
  }
}
