import 'package:buk/widgets/documents/sub_pages/document_subpage.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PassportPage extends StatelessWidget {
  const PassportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DocumentSubPage(
      title: TranslateText(
        text: "Apply for UK passport",
        selectable: false,
        style: GoogleFonts.lato(
          textStyle: const TextStyle(
              color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
      child: Column(
        children: const [],
      ),
    );
  }
}
