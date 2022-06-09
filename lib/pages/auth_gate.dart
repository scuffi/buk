import 'package:buk/api/user_api.dart';
import 'package:buk/pages/feed_page.dart';
import 'package:buk/pages/fullscreen_loading.dart';
import 'package:buk/pages/initial_input.dart';
import 'package:buk/providers/initial/initial_provider.dart';
import 'package:buk/providers/user_provider.dart';
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

          Future.delayed(const Duration(seconds: 1), () {
            var provider = Provider.of<UserProvider>(context, listen: false);
            provider.setUser(snapshot.data!);
          });

          return (snapshot.data!.displayName != null &&
                      snapshot.data!.displayName != "") ||
                  Provider.of<InitialProvider>(context).passed
              ? Provider.of<UserProvider>(context).user == null
                  ? const FullScreenLoader()
                  : const FeedPage()
              : InputPage(snapshot.data!);
        });
  }
}
