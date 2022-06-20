import 'package:buk/api/feed_api.dart';
import 'package:buk/providers/feed/feed_loader.dart';
import 'package:buk/providers/feed/feed_provider.dart';
import 'package:buk/providers/feed/feed_type.dart';
import 'package:buk/widgets/feed/feed_empty.dart';
import 'package:buk/widgets/feed/feed_item.dart';
import 'package:buk/widgets/feed/sub/category_switcher.dart';
import 'package:buk/widgets/feed_loading.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';

class Feed extends StatefulWidget {
  Feed(this.type, {Key? key}) : super(key: key);

  FeedType type;

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  // ! Working / no pagination
  @override
  Widget build(BuildContext context) {
    return Consumer<FeedLoader>(
      builder: (_, loader, __) => loader.loaded
          ? Consumer<FeedData>(
              builder: (_, data, __) {
                var feed = widget.type == FeedType.request
                    ? data.sortedRequestFeed()
                    : data.sortedOfferFeed();
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CategorySwitcher(
                      type: widget.type,
                    ),
                    feed.isNotEmpty
                        ? Expanded(
                            child: LazyLoadScrollView(
                              onEndOfPage: () => loadMore(
                                  context: context, feedType: widget.type),
                              child: ListView.builder(
                                itemCount: feed.length,
                                itemBuilder: (_, index) {
                                  return FeedItem(info: feed[index]);
                                },
                              ),
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
