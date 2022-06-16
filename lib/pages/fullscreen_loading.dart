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
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: GradientText(
                "Buk",
                colors: [Colors.purple[900]!, Colors.pinkAccent],
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      fontSize: 100.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Center(child: CircularProgressIndicator()),
            const Spacer(),
          ]),
        ),
      ),
    );
  }
}
