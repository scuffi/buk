import 'package:buk/widgets/feed/feed_empty.dart';
import 'package:buk/widgets/feed/feed_item.dart';
import 'package:buk/widgets/feed/sub/category_switcher.dart';
import 'package:buk/widgets/feed_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/feed/feed_loader.dart';
import '../../providers/feed/feed_provider.dart';

class OfferFeed extends StatelessWidget {
  const OfferFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedLoader>(
      builder: (_, loader, __) => loader.loaded
          ? // Consumer<FeedData>(
          //     builder: (_, data, __) {
          Column(
              children: [
                CategorySwitcher(
                  type: "offer",
                ),
                Provider.of<FeedData>(context).sortedOfferFeed().isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: Provider.of<FeedData>(context)
                              .sortedOfferFeed()
                              .length,
                          itemBuilder: (_, index) {
                            return FeedItem(
                                info: Provider.of<FeedData>(context)
                                    .sortedOfferFeed()[index]);
                          },
                        ),
                      )
                    : const FeedEmpty(),
              ],
            )
          //   },
          // )
          : const FeedLoading(),
    );
  }
}
