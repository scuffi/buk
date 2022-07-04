import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentSubPage extends StatelessWidget {
  DocumentSubPage({Key? key, required this.child, required this.title})
      : super(key: key);

  Widget child;
  Widget title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Column(
        children: [
          SizedBox(
            height: 175,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: title,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.keyboard_arrow_left,
                              color: Colors.black87,
                              size: 40,
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    child,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LinkItem extends StatelessWidget {
  LinkItem({Key? key, required this.text, required this.link})
      : super(key: key);

  String link;
  String text;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          final Uri url = Uri.parse(link);

          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Failed to open link, please report this")));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              TranslateText(
                text: text,
                style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.blue[900])),
                selectable: false,
              ),
              Spacer(),
              Icon(
                Icons.open_in_new,
                color: Colors.blue[900],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
