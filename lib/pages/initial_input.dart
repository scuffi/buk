import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:buk/providers/initial/initial_provider.dart';
import 'package:buk/widgets/translate/language_switch.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InputPage extends StatefulWidget {
  const InputPage(this.data, {Key? key}) : super(key: key);

  final User data;
  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();
  bool langSwitch = true;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                      colors: [Color(0xff45a7f5), Color(0xffd47fe3)],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    )),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: (height * 0.075)),
                child: AnimatedTextKit(
                  repeatForever: true,
                  pause: const Duration(milliseconds: 50),
                  animatedTexts: [
                    FadeAnimatedText(
                      "Welcome",
                      duration: const Duration(seconds: 5),
                      fadeInEnd: 0.2,
                      fadeOutBegin: 0.9,
                      textAlign: TextAlign.center,
                      textStyle: GoogleFonts.poppins(
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 48),
                      ),
                    ),
                    FadeAnimatedText(
                      "Biтaю",
                      duration: const Duration(seconds: 5),
                      fadeInEnd: 0.2,
                      fadeOutBegin: 0.9,
                      textAlign: TextAlign.center,
                      textStyle: GoogleFonts.poppins(
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 48),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: height * 0.2),
                child: Container(
                  height: height * 0.4,
                  width: width * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            spreadRadius: 8,
                            blurRadius: 6,
                            offset: const Offset(0, 4)),
                      ]),
                  child: Column(
                    children: [
                      const Spacer(),
                      TranslateText(
                        text: "Welcome to buk, here you can find...",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                            textStyle: const TextStyle(fontSize: 18)),
                      ),
                      const Spacer(),
                      TranslateText(
                        text: "What is your preferred language?",
                        ukrainian: "Яку мову ви віддаєте перевагу?",
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.black.withOpacity(0.7))),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: LanguageSwitch(),
                      ),
                      TranslateText(
                        text: "What is your username?",
                        ukrainian: "Яке ваше ім'я користувача?",
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.black.withOpacity(0.7))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                        child: SizedBox(
                          width: width * 0.75,
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.runtimeType != String ||
                                    value.length < 3 ||
                                    value.length > 25) {
                                  return "Username must be between 3-25 characters";
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                hintText: "Username",
                              ),
                              onChanged: (val) {
                                _formKey.currentState!.validate();
                                Provider.of<InitialProvider>(context,
                                        listen: false)
                                    .setUsername(val);
                              },
                            ),
                          ),
                        ),
                      ),
                    ], // ? Input column
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: height * 0.05),
                child: Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          widget.data
                              .updateDisplayName(Provider.of<InitialProvider>(
                                      context,
                                      listen: false)
                                  .username)
                              .catchError((err) {
                            print(err);
                          });
                          Provider.of<InitialProvider>(context, listen: false)
                              .setPassed(true);
                          // TODO: Add language to local storage so we can default to it each time app starts up
                        }
                      },
                      child: Row(
                        children: [
                          TranslateText(
                            text: "Let's go",
                            ukrainian: "Xoдiмo",
                            selectable: false,
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue)),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
