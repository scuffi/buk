import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:buk/api/feed_api.dart';
import 'package:buk/pages/post_page.dart';
import 'package:buk/providers/initial/initial_provider.dart';
import 'package:buk/providers/user_provider.dart';
import 'package:buk/widgets/feed/feed_offer.dart';
import 'package:buk/widgets/feed/feed_request.dart';
import 'package:buk/widgets/feed/liked_feed.dart';
import 'package:buk/widgets/translate/language_switch.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 3, vsync: this);

    Future.delayed(
      const Duration(seconds: 0),
      () async {
        var provider = Provider.of<UserProvider>(context, listen: false);

        // List<String>? likes = await getUserLikes(provider.user!);
        // if (likes != null) {
        //   provider.defaultAddLikes(likes);
        // }

        // await updateFeeds(context);

        // if (likes != null) {
        //   // Iterate over EXISTING items, if the liked list contains an item that doesn't exist, add it to be later removed from that users likes
        //   var feedIds = Provider.of<FeedData>(context, listen: false)
        //       .fullFeed
        //       .map((e) => e.id)
        //       .toList();

        //   likes.retainWhere(
        //     (element) => !feedIds.contains(element),
        //   );

        //   removeUserLikes(provider.user!, likes);
        // }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _bottomNavIndex = 0;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            TextButton(
              child: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Provider.of<InitialProvider>(context, listen: false)
                    .setPassed(false);
                Provider.of<UserProvider>(context, listen: false).clearUser();
              },
            ),
            const Spacer(),
            const LanguageSwitch(),
          ],
        ),
        // shape: const RoundedRectangleBorder(
        //     borderRadius: BorderRadius.vertical(bottom: Radius.circular(32))),
        bottom: TabBar(
          controller: controller,
          tabs: const [
            Tab(
              child: TranslateText(
                text: "Requesting",
                selectable: false,
              ),
            ),
            Tab(
              child: TranslateText(
                text: "Offering",
                selectable: false,
              ),
            ),
            Tab(
              child: TranslateText(
                text: "Liked",
                selectable: false,
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          RefreshIndicator(
            onRefresh: () {
              return Future.delayed(const Duration(seconds: 0), () {
                updateFeeds(context);
              });
            },
            child: const RequestFeed(),
          ),
          RefreshIndicator(
            onRefresh: () {
              return Future.delayed(const Duration(seconds: 0), () {
                updateFeeds(context);
              });
            },
            child: const OfferFeed(),
          ),
          const LikedFeed(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PostPage(),
              fullscreenDialog: true,
            ),
          );
        },
        child: const Icon(
          Icons.add,
          size: 40,
        ),
        //params
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const [
          Icons.home,
          Icons.search,
          Icons.add_circle_outline,
          Icons.settings
        ],
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        notchSmoothness: NotchSmoothness.smoothEdge,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        //other params
      ),
    );
  }
}
