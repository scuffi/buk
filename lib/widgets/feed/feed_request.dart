import 'package:buk/widgets/feed/feed_empty.dart';
import 'package:buk/widgets/feed/feed_item.dart';
import 'package:buk/widgets/feed/sub/category_switcher.dart';
import 'package:buk/widgets/feed_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/feed/feed_loader.dart';
import '../../providers/feed/feed_provider.dart';

class RequestFeed extends StatelessWidget {
  const RequestFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedLoader>(
      builder: (_, loader, __) => loader.loaded
          ? Consumer<FeedData>(
              builder: (_, data, __) {
                return Column(
                  children: [
                    CategorySwitcher(
                      type: "request",
                    ),
                    data.sortedRequestFeed().isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: data.sortedRequestFeed().length,
                              itemBuilder: (_, index) => FeedItem(
                                  info: data.sortedRequestFeed()[index]),
                            ),
                          )
                        : const FeedEmpty(),
                  ],
                );
              },
            )
          : const FeedLoading(),
    );
  }
}
