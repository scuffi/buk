import 'package:buk/widgets/documents/sub_pages/passport_page.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class DocumentsBase extends StatelessWidget {
  const DocumentsBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          DocumentItem(
            text: "Apply for a UK passport",
            redirect: const PassportPage(),
          ),
          DocumentItem(
            text: "Apply for local schools",
            redirect: const PassportPage(),
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
                TranslateText(
                  text: text,
                  selectable: false,
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
