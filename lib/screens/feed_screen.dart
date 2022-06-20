import 'package:buk/providers/feed/feed_type.dart';
import 'package:buk/widgets/feed/feed.dart';
import 'package:flutter/material.dart';
import 'package:buk/widgets/feed/liked_feed.dart';
import 'package:buk/widgets/translate/language_switch.dart';
import 'package:buk/widgets/translate/translate_text.dart';

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
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Row(
          children: const [
            Spacer(),
            LanguageSwitch(),
          ],
        ),
        // shape: const RoundedRectangleBorder(
        //     borderRadius: BorderRadius.vertical(bottom: Radius.circular(32))),
        bottom: TabBar(
          controller: controller,
          labelColor: Theme.of(context).primaryColor,
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
          Feed(
            FeedType.request,
          ),
          Feed(
            FeedType.offer,
          ),
          const LikedFeed(),
        ],
      ),
    );
  }
}
