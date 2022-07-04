import 'package:buk/widgets/documents/sub_pages/areas_page.dart';
import 'package:buk/widgets/documents/sub_pages/passport_page.dart';
import 'package:buk/widgets/documents/sub_pages/universal_credit_page.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentsBase extends StatelessWidget {
  const DocumentsBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TranslateText(
              text: "Government Help & Advice",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ),
          ),
          DocumentLinkItem(
            text: "Guide for Ukrainians arriving in UK",
            link:
                "https://www.gov.uk/government/publications/welcome-a-guide-for-ukrainians-arriving-in-the-uk/welcome-a-guide-for-ukrainians-arriving-in-the-uk",
          ),
          DocumentLinkItem(
            text: "RedCross - Help for Ukraine",
            link:
                "https://www.redcross.org.uk/get-help/get-help-as-a-refugee/help-for-refugees-from-ukraine",
          ),
          DocumentLinkItem(
            text: "Healthy Start - Financial Support",
            link:
                "https://www.healthystart.nhs.uk/frequently-asked-questions/applying-for-healthy-start-faqs/",
          ),
          DocumentItem(
            text: "Apply for Universal Credit",
            redirect: const UniversalCreditPage(),
          ),
          DocumentLinkItem(
            text: "Homes for Ukraine",
            link: "https://www.gov.uk/register-interest-homes-ukraine",
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TranslateText(
              text: "Your area",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ),
          ),
          DocumentItem(
            text: "Areas of interest",
            redirect: const AreasPage(),
          ),
          DocumentLinkItem(
            text: "Buckinghamshire Schools",
            link:
                "https://www.buckinghamshire.gov.uk/schools-and-learning/schools-index/",
          ),
        ],
      ),
    );
  }
}

class DocumentItem extends StatelessWidget {
  DocumentItem({required this.redirect, required this.text, Key? key})
      : super(key: key);

  Widget redirect;
  String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 3,
                offset: const Offset(0, 2),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: redirect,
                ),
              );
            },
            child: Row(
              children: [
                SizedBox(
                  width: 300,
                  child: TranslateText(
                    text: text,
                    selectable: false,
                    style: GoogleFonts.lato(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DocumentLinkItem extends StatelessWidget {
  DocumentLinkItem({required this.link, required this.text, Key? key})
      : super(key: key);

  String link;
  String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 3,
                offset: const Offset(0, 2),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async {
              final Uri url = Uri.parse(link);

              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to open link")));
              }
            },
            child: Row(
              children: [
                SizedBox(
                  width: 300,
                  child: TranslateText(
                    text: text,
                    selectable: false,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.blue[900]),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                Icon(Icons.open_in_new, color: Colors.blue[900]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
