import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class FeedEmpty extends StatelessWidget {
  const FeedEmpty({Key? key}) : super(key: key);

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
              "It looks like nothing is here, why don't you create a post to make it less empty?",
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
