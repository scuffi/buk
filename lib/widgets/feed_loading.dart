import 'package:buk/widgets/feed/feed_item.dart';
import 'package:flutter/material.dart';

class FeedLoading extends StatelessWidget {
  const FeedLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        FeedItem(
          info: {
            "title": "",
            "description": "",
            "username": "",
          },
          loading: true,
        ),
        FeedItem(
          info: {
            "title": "",
            "description": "",
            "username": "",
          },
          loading: true,
        ),
      ],
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
