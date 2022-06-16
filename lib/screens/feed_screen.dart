import 'package:flutter/material.dart';
import 'package:buk/api/feed_api.dart';
import 'package:buk/providers/initial/initial_provider.dart';
import 'package:buk/providers/user_provider.dart';
import 'package:buk/widgets/feed/feed_offer.dart';
import 'package:buk/widgets/feed/feed_request.dart';
import 'package:buk/widgets/feed/liked_feed.dart';
import 'package:buk/widgets/translate/language_switch.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: Colors.white),
          tabs: const [
            Tab(
              child: Align(
                alignment: Alignment.center,
                child: TranslateText(
                  text: "Requesting",
                  selectable: false,
                ),
              ),
            ),
            Tab(
              child: Align(
                alignment: Alignment.center,
                child: TranslateText(
                  text: "Offering",
                  selectable: false,
                ),
              ),
            ),
            Tab(
              child: Align(
                alignment: Alignment.center,
                child: TranslateText(
                  text: "Liked",
                  selectable: false,
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          LiquidPullToRefresh(
            springAnimationDurationInMilliseconds: 200,
            showChildOpacityTransition: false,
            onRefresh: () {
              return Future.delayed(const Duration(seconds: 0), () {
                updateFeeds(context);
              });
            },
            child: const RequestFeed(),
          ),
          LiquidPullToRefresh(
            springAnimationDurationInMilliseconds: 200,
            showChildOpacityTransition: false,
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
    );
  }
}
