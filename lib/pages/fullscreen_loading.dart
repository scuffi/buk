import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(children: [
            const Spacer(),
            Image.asset(
              "assets/logo_blank.png",
              height: 200,
              width: 200,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: GradientText(
                "UK2BUK",
                colors: [Colors.purple[900]!, Colors.blueAccent],
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      fontSize: 56.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Center(child: CircularProgressIndicator.adaptive()),
            const Spacer(),
          ]),
        ),
      ),
    );
  }
}
