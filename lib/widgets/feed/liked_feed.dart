import 'package:buk/providers/feed/feed_loader.dart';
import 'package:buk/providers/user_provider.dart';
import 'package:buk/widgets/feed/feed_item.dart';
import 'package:buk/widgets/feed/like_feed_empty.dart';
import 'package:buk/widgets/feed_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LikedFeed extends StatelessWidget {
  const LikedFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedLoader>(
      builder: (_, loader, __) => loader.loaded
          ? Consumer<UserProvider>(
              builder: (_, data, __) {
                // var usableFeed = data.fullFeed
                //     .where((element) => likeList.contains(element.id))
                //     .toList();

                // usableFeed.sort(((a, b) {
                //   return b.timestamp!.compareTo(a.timestamp!);
                // }));

                // // ? Maybe needs to set usableFeed to a state?
                // print(usableFeed);

                return data.likes.isNotEmpty
                    ? ListView.builder(
                        itemCount: data.likes.length,
                        itemBuilder: (con, index) {
                          var feed =
                              Provider.of<UserProvider>(con, listen: false);

                          print(
                              "index $index, title ${feed.likes.elementAt(index)}");
                          return FeedItem(info: feed.likes.elementAt(index));
                        },
                      )
                    : const LikeFeedEmpty();
              },
            )
          : const FeedLoading(),
    );
  }
}
