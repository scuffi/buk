import 'package:buk/api/user_api.dart';
import 'package:buk/providers/initial/initial_provider.dart';
import 'package:buk/providers/screen/screen_provider.dart';
import 'package:buk/providers/settings_provider.dart';
import 'package:buk/providers/user_provider.dart';
import 'package:buk/screens/feed_screen.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingsButtons extends StatefulWidget {
  const SettingsButtons({Key? key}) : super(key: key);

  @override
  State<SettingsButtons> createState() => _SettingsButtonsState();
}

class _SettingsButtonsState extends State<SettingsButtons> {
  final _formKey = GlobalKey<FormState>();
  String passwordInput = '';

  @override
  Widget build(BuildContext context) {
    SettingsProvider provider = Provider.of<SettingsProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          Provider.of<UserProvider>(context).user!.displayName!,
          style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.grey[800], fontSize: 30)),
        ),
        Text(
          Provider.of<UserProvider>(context).user!.email!,
          style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.grey[700], fontSize: 15)),
        ),
        TextButton(
          style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
          onPressed: () {
            provider.toggleNotifications();
          },
          child: Row(
            children: [
              const Icon(
                Icons.notifications_none,
                color: Colors.indigoAccent,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TranslateText(
                  text: "Notifications",
                  selectable: false,
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(fontSize: 16),
                      color: Colors.grey[700]),
                ),
              ),
              const Spacer(),
              Switch.adaptive(
                  value: provider.notifications,
                  onChanged: (toggled) {
                    provider.setNotifications(toggled);
                  })
            ],
          ),
        ), // Notifications section
        TextButton(
          style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
          onPressed: () {
            print("Help pressed");
          },
          child: Row(
            children: [
              const Icon(
                Icons.help_outline,
                color: Colors.indigoAccent,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TranslateText(
                  text: "Help",
                  selectable: false,
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(fontSize: 16),
                      color: Colors.grey[700]),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[700],
                ),
              )
            ],
          ),
        ), // Help section
        TextButton(
          style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Column(mainAxisSize: MainAxisSize.min, children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TranslateText(
                          textAlign: TextAlign.center,
                          text: "Type your password to confirm deletion",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 24, color: Colors.grey[800]),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                passwordInput = value;
                              });
                            },
                            obscureText: true,
                            autocorrect: false,
                            enableSuggestions: false,
                            decoration: const InputDecoration(
                              labelText: "Password",
                            ),
                            validator: (val) {
                              print(val);
                              if (val == null ||
                                  val.trim().isEmpty ||
                                  val == '') {
                                return "Password is required";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: TranslateText(
                                text: "Cancel",
                                selectable: false,
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                            const Spacer(),
                            OutlinedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  print("Delete account");
                                  var userProvider = Provider.of<UserProvider>(
                                      context,
                                      listen: false);

                                  userProvider.user!
                                      .reauthenticateWithCredential(
                                          EmailAuthProvider.credential(
                                              email: userProvider.user!.email!,
                                              password: passwordInput));

                                  print("User: ${userProvider.user}");

                                  bool deleted = await deleteEverything(
                                      userProvider.user!);

                                  print("Deleted everything? $deleted");

                                  userProvider.user!.delete();
                                  // FirebaseAuth.instance.signOut();

                                  Navigator.pop(context);

                                  Provider.of<InitialProvider>(context,
                                          listen: false)
                                      .setPassed(false);
                                  Provider.of<UserProvider>(context,
                                          listen: false)
                                      .clearUser();
                                  Provider.of<Screen>(context, listen: false)
                                      .setScreen(const FeedScreen(), context);
                                }
                              },
                              child: TranslateText(
                                text: "Delete",
                                selectable: false,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      color: Colors.grey[700], fontSize: 16),
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ]),
                  );
                });
          },
          child: Row(
            children: [
              const Icon(
                Icons.delete_outline,
                color: Colors.indigoAccent,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TranslateText(
                  text: "Delete account",
                  selectable: false,
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(fontSize: 16),
                      color: Colors.grey[700]),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[700],
                ),
              )
            ],
          ),
        ), // Delete account
        TextButton(
          style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Center(
                    child: Container(
                      height: 160,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TranslateText(
                            textAlign: TextAlign.center,
                            text: "Are you sure you want to logout?",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 24, color: Colors.grey[800]),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: TranslateText(
                                  text: "No",
                                  selectable: false,
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  FirebaseAuth.instance.signOut();
                                  Provider.of<InitialProvider>(context,
                                          listen: false)
                                      .setPassed(false);
                                  Provider.of<UserProvider>(context,
                                          listen: false)
                                      .clearUser();
                                  Provider.of<Screen>(context, listen: false)
                                      .setScreen(const FeedScreen(), context);
                                },
                                child: TranslateText(
                                  text: "Yes",
                                  selectable: false,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        color: Colors.grey[700], fontSize: 16),
                                  ),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  );
                });
          },
          child: Row(
            children: [
              const Icon(
                Icons.logout_outlined,
                color: Colors.indigoAccent,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TranslateText(
                  text: "Logout",
                  selectable: false,
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(fontSize: 16),
                      color: Colors.grey[700]),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[700],
                ),
              )
            ],
          ),
        ), // Logout
      ],
    );
  }
}
