import 'package:buk/api/donations_api.dart';
import 'package:buk/api/feed_api.dart';
import 'package:buk/api/user_api.dart';
import 'package:buk/pages/auth/auth_screen.dart';
import 'package:buk/pages/fullscreen_loading.dart';
import 'package:buk/pages/initial_input.dart';
import 'package:buk/pages/main_page.dart';
import 'package:buk/providers/donations/donations_provider.dart';
import 'package:buk/providers/feed/feed_provider.dart';
import 'package:buk/providers/feed/feed_type.dart';
import 'package:buk/providers/initial/initial_provider.dart';
import 'package:buk/providers/user_provider.dart';
import 'package:buk/widgets/feed/interface/category_type.dart';
import 'package:buk/widgets/feed/interface/item_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
            return const AuthScreen();
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

              feed.clearItems(FeedType.offer);
              feed.clearItems(FeedType.request);

              // ? This is our initial feed
              await loadItems(context: context, feedType: FeedType.offer);
              await loadItems(context: context, feedType: FeedType.request);

              // ? Feed listener
              FirebaseFirestore.instance
                  .collection("feed")
                  .orderBy("timestamp", descending: true)
                  .snapshots()
                  .listen((event) {
                for (var change in event.docChanges) {
                  var type = change.doc.get("item_type") == "request"
                      ? FeedType.request
                      : FeedType.offer;
                  if (change.type == DocumentChangeType.added) {
                    var item = ItemData(
                      id: change.doc.id,
                      title: change.doc.get("title"),
                      description: change.doc.get("description"),
                      images: change.doc.get("images"),
                      image_location: change.doc.get("image_location"),
                      category: ItemCategory.values
                          .asNameMap()[change.doc.get("category")]!,
                      owner_name: change.doc.get("owner_name"),
                      owner_id: change.doc.get("owner_id"),
                      owner_contact: change.doc.get("owner_contact"),
                      item_type: change.doc.get("item_type"),
                      timestamp: change.doc.get("timestamp"),
                    );

                    feed.insertItem(change.newIndex, item, type);
                  } else if (change.type == DocumentChangeType.modified) {
                    // ! Unhandled
                  } else if (change.type == DocumentChangeType.removed) {
                    // ? This can just try remove a document, we may not have it yet but that's fine
                    feed.removeById(change.doc.id, type);
                    Provider.of<UserProvider>(context)
                        .discreditLike(change.doc.id);
                  }
                }
              });

              List<ItemData>? likes = await getUserLikes(provider.user!);

              // Add like items to provider if not null
              if (likes != null) {
                print("Adding likes to provider $likes");
                provider.defaultAddLikes(likes, feed);
              }

              // Set donation items
              Provider.of<DonationsProvider>(context, listen: false)
                  .setItems(await fetchDonationItems());

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
