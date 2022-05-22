import 'package:buk/widgets/feed/feed_empty.dart';
import 'package:buk/widgets/feed/feed_item.dart';
import 'package:buk/widgets/feed_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/feed_loader.dart';
import '../../providers/feed_provider.dart';

class OfferFeed extends StatelessWidget {
  const OfferFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedLoader>(
      builder: (_, loader, __) => loader.loaded
          ? Consumer<FeedData>(
              builder: (_, data, __) => data.offerItems.isNotEmpty
                  ? ListView.builder(
                      itemCount: data.offerItems.length,
                      itemBuilder: (_, index) {
                        return FeedItem(info: data.offerItems[index]);
                      },
                    )
                  : const FeedEmpty(),
            )
          : const FeedLoading(),
    );
  }
}
