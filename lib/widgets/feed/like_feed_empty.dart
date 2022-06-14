import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
            "Oh no!",
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
            child: Text(
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
