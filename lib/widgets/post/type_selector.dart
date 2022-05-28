import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TypeSelector extends StatelessWidget {
  const TypeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TranslateText(
          text: "I am...",
          style: GoogleFonts.mukta(textStyle: const TextStyle(fontSize: 22)),
        ),
        // ! Add checkbox selector betweeen 'Requesting' and 'Offering'
      ],
    );
  }
}
