import 'package:buk/api/feed_api.dart';
import 'package:buk/pages/feed_page.dart';
import 'package:buk/pages/initial_input.dart';
import 'package:buk/providers/initial/initial_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SignInScreen(
              providerConfigs: [
                EmailProviderConfiguration(),
              ],
            );
          }

          userExistsInDb(snapshot.data!).then((exists) {
            if (!exists) {
              createUserInDb(snapshot.data!);
            }
          });

          return (snapshot.data!.displayName != null &&
                      snapshot.data!.displayName != "") ||
                  Provider.of<InitialProvider>(context).passed
              ? FeedPage(user: snapshot.data!)
              : InputPage(snapshot.data!);
        });
  }
}
