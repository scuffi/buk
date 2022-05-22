import 'package:buk/widgets/feed/feed_empty.dart';
import 'package:buk/widgets/feed/feed_item.dart';
import 'package:buk/widgets/feed_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/feed_loader.dart';
import '../../providers/feed_provider.dart';

class RequestFeed extends StatelessWidget {
  const RequestFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedLoader>(
      builder: (_, loader, __) => loader.loaded
          ? Consumer<FeedData>(
              builder: (_, data, __) => data.requestItems.isNotEmpty
                  ? ListView.builder(
                      itemCount: data.requestItems.length,
                      itemBuilder: (_, index) {
                        return FeedItem(info: data.requestItems[index]);
                      },
                    )
                  : const FeedEmpty(),
            )
          : const FeedLoading(),
    );
  }
}
