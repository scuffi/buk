import 'package:buk/widgets/documents/sub_pages/document_subpage.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AreasPage extends StatelessWidget {
  const AreasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DocumentSubPage(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TranslateText(
              text: "The Hub",
              selectable: false,
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: LinkItem(
                text: "Goldhill - The Hub",
                link: "https://www.goldhill.org/what-we-do/the-hub/"),
          ),
        ],
      ),
      title: TranslateText(
        text: "Areas of Interest",
        selectable: false,
        style: GoogleFonts.lato(
          textStyle: const TextStyle(
              color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
