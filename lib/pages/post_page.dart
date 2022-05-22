import 'package:buk/pages/feed_page.dart';
import 'package:buk/providers/language/language_enum.dart';
import 'package:buk/providers/language/language_provider.dart';
import 'package:buk/widgets/post/description_input.dart';
import 'package:buk/widgets/post/title_input.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const FeedPage()),
            );
          },
        ),
        body: Stack(children: [
          Container(
            color: Colors.white,
          ),
          Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Container(
                    height: height * 0.4,
                    width: width * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.6),
                              spreadRadius: 8,
                              blurRadius: 6,
                              offset: const Offset(0, 4)),
                        ]),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          PostTitleForm(formKey: _formKey),
                          PostDescriptionForm(formKey: _formKey),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TranslateText(
                              text: Provider.of<Language>(context,
                                              listen: false)
                                          .language ==
                                      LanguageType.en
                                  ? "Tip: Try to use longer, more descriptive words"
                                  : "Порада: намагайтеся використовувати довгі, більш описові слова",
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    height: height * 0.1,
                    width: width * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.6),
                              spreadRadius: 8,
                              blurRadius: 6,
                              offset: const Offset(0, 4)),
                        ]),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    height: height * 0.2,
                    width: width * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.6),
                              spreadRadius: 8,
                              blurRadius: 6,
                              offset: const Offset(0, 4)),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ]));
  }
}
