import 'package:buk/providers/feed/feed_loader.dart';
import 'package:buk/providers/feed/feed_provider.dart';
import 'package:buk/providers/user_provider.dart';
import 'package:buk/widgets/feed/feed_empty.dart';
import 'package:buk/widgets/feed/feed_item.dart';
import 'package:buk/widgets/feed_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buk/config.dart' as config;

class LikedFeed extends StatelessWidget {
  const LikedFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedLoader>(
      builder: (_, loader, __) => loader.loaded
          ? Consumer<FeedData>(
              builder: (_, data, __) {
                var likeList = Provider.of<UserProvider>(context,
                        listen: !config.likeStayOnPageOnUnlike)
                    .likes;
                var usableFeed = data.fullFeed
                    .where((element) => likeList.contains(element.id));

                return usableFeed.isNotEmpty
                    ? ListView.builder(
                        itemCount: usableFeed.length,
                        itemBuilder: (_, index) {
                          return FeedItem(info: usableFeed.elementAt(index));
                        },
                      )
                    : const FeedEmpty();
              },
            )
          : const FeedLoading(),
    );
  }
}
