import 'package:buk/widgets/documents/sub_pages/document_subpage.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UniversalCreditPage extends StatelessWidget {
  const UniversalCreditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DocumentSubPage(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TranslateText(
              text: "Understand Universal Credit",
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
                text: "More information on Universal Credit",
                link:
                    "https://www.understandinguniversalcredit.gov.uk/new-to-universal-credit/is-it-for-me/"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: TranslateText(
              text: "Apply for Universal Credit",
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
                text: "Apply for Universal Credit",
                link: "https://www.gov.uk/universal-credit/how-to-claim"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: TranslateText(
              text: "Interview advice",
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
                text: "Going to your Universal Credit interview",
                link:
                    "https://www.citizensadvice.org.uk/benefits/universal-credit/claiming/going-to-your-interview/"),
          ),
        ],
      ),
      title: TranslateText(
        text: "Universal Credit",
        selectable: false,
        style: GoogleFonts.lato(
          textStyle: const TextStyle(
              color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
