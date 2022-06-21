import 'package:buk/providers/feed/feed_type.dart';
import 'package:buk/widgets/feed/feed_empty.dart';
import 'package:buk/widgets/feed/feed_item.dart';
import 'package:buk/widgets/feed/sub/category_switcher.dart';
import 'package:buk/widgets/feed/feed_loading.dart';
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CategorySwitcher(
                      type: FeedType.request,
                    ),
                    data.sortedRequestFeed().isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: data.sortedRequestFeed().length,
                              itemBuilder: (_, index) => FeedItem(
                                  info: data.sortedRequestFeed()[index]),
                            ),
                          )
                        : Expanded(
                            child: ListView(
                              children: const [
                                SizedBox(height: 550, child: FeedEmpty())
                              ],
                            ),
                          ),
                  ],
                );
              },
            )
          : const FeedLoading(),
    );
  }
}
