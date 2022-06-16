import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:buk/api/user_api.dart';
import 'package:buk/providers/initial/initial_provider.dart';
import 'package:buk/providers/user_provider.dart';
import 'package:buk/widgets/translate/language_switch.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool nameFormOpen = true;
  bool inputError = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                            color: Colors.grey.shade400.withOpacity(0.7),
                            spreadRadius: 3,
                            blurRadius: 2,
                            offset: const Offset(0, 2)),
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
                              maxLength: 25,
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                              readOnly: !nameFormOpen,
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.runtimeType != String ||
                                    value.length < 3 ||
                                    value.length > 25) {
                                  return "Username must be between 3-25 characters";
                                } else if (inputError) {
                                  return "Username already exists, try another one";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: "Username",
                              ),
                              onChanged: (val) async {
                                if (val.contains(" ")) {
                                  val.replaceAll(" ", "");
                                }
                                setState(() {
                                  inputError = false;
                                });
                                _formKey.currentState!.validate();
                                Provider.of<InitialProvider>(context,
                                        listen: false)
                                    .setUsername(val.trim());
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
                          setState(() {
                            nameFormOpen = false;
                          });
                          String displayName = Provider.of<InitialProvider>(
                                  context,
                                  listen: false)
                              .username;
                          bool available =
                              await displayNameAvailable(displayName);
                          if (available) {
                            // Set displayName in database
                            await setUserDisplayName(
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .user!,
                                displayName);

                            // Set display name in user auth
                            await Provider.of<UserProvider>(context,
                                    listen: false)
                                .user!
                                .updateDisplayName(displayName)
                                .catchError((err) {
                              print(err);
                            });

                            //Reload the user so userName updates
                            await Provider.of<UserProvider>(context,
                                    listen: false)
                                .user!
                                .reload();

                            Provider.of<UserProvider>(context, listen: false)
                                .setUser(FirebaseAuth.instance.currentUser!);

                            // Allow to move onto next stage
                            Provider.of<InitialProvider>(context, listen: false)
                                .setPassed(true);
                          } else {
                            setState(() {
                              inputError = true;
                              nameFormOpen = true;
                            });
                          }
                          // TODO: Add language to local storage so we can default to it each time app starts up
                        }
                      },
                      child: nameFormOpen
                          ? Row(
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
                            )
                          : const CircularProgressIndicator.adaptive(),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor)),
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
