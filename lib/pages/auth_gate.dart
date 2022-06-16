import 'package:buk/api/donations_api.dart';
import 'package:buk/api/feed_api.dart';
import 'package:buk/api/user_api.dart';
import 'package:buk/pages/fullscreen_loading.dart';
import 'package:buk/pages/initial_input.dart';
import 'package:buk/pages/main_page.dart';
import 'package:buk/providers/donations/donations_provider.dart';
import 'package:buk/providers/feed/feed_provider.dart';
import 'package:buk/providers/initial/initial_provider.dart';
import 'package:buk/providers/user_provider.dart';
import 'package:buk/widgets/feed/interface/item_data.dart';
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
  bool loaded = false;
  bool firstIteration = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            loaded = false;
            firstIteration = true;
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

          if (firstIteration) {
            Future.delayed(const Duration(seconds: 1), () async {
              var provider = Provider.of<UserProvider>(context, listen: false);
              var feed = Provider.of<FeedData>(context, listen: false);

              // Set the user
              provider.setUser(snapshot.data!);

              // Update the feeds before we add likes (or else no likes will be added)
              await updateFeeds(context);

              List<String>? likes = await getUserLikes(provider.user!);
              List<ItemData> likeItems = List<ItemData>.empty(growable: true);

              if (likes != null) {
                likeItems = List<ItemData>.from(feed.fullFeed);
                likeItems.retainWhere((element) => likes.contains(element.id));

                provider.defaultAddLikes(likeItems, feed);

                // Iterate over EXISTING items, if the liked list contains an item that doesn't exist, add it to be later removed from that users likes
                // var feedIds = Provider.of<FeedData>(context, listen: false)
                //     .fullFeed
                //     .map((e) => e.id)
                //     .toList();

                // likes.retainWhere(
                //   (element) => !feedIds.contains(element),
                // );

                List<ItemData> itemsToRemove =
                    List<ItemData>.from(feed.fullFeed);
                itemsToRemove
                    .removeWhere((element) => likeItems.contains(element));

                provider.removeLikes(itemsToRemove);

                // Set donation items
                Provider.of<DonationsProvider>(context, listen: false)
                    .setItems(await fetchDonationItems());
              }

              setState(() {
                loaded = true;
              });
            });

            firstIteration = false;
          }

          return (snapshot.data!.displayName != null &&
                      snapshot.data!.displayName != "") ||
                  Provider.of<InitialProvider>(context).passed
              ? !loaded
                  ? const FullScreenLoader()
                  : const MainPage()
              : InputPage(snapshot.data!);
        });
  }
}
