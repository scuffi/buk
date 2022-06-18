import 'package:buk/providers/feed/feed_provider.dart';
import 'package:buk/widgets/feed/feed_item.dart';
import 'package:buk/widgets/feed/interface/category_type.dart';
import 'package:buk/widgets/feed/interface/item_data.dart';
import 'package:buk/widgets/feed/sub/category_switcher.dart';
import 'package:buk/widgets/feed_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

import '../../providers/feed/feed_loader.dart';

class Feed extends StatelessWidget {
  Feed(this.type, {Key? key}) : super(key: key);

  String type;

  // ! Working / no pagination
  // @override
  // Widget build(BuildContext context) {
  //   return Consumer<FeedLoader>(
  //     builder: (_, loader, __) => loader.loaded
  //         ? Consumer<FeedData>(
  //             builder: (_, data, __) {
  //               var feed = type == "request"
  //                   ? data.sortedRequestFeed()
  //                   : data.sortedOfferFeed();
  //               return Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   CategorySwitcher(
  //                     type: type,
  //                   ),
  //                   feed.isNotEmpty
  //                       ? Expanded(
  //                           child: ListView.builder(
  //                             itemCount: feed.length,
  //                             itemBuilder: (_, index) =>
  //                                 FeedItem(info: feed[index]),
  //                           ),
  //                         )
  //                       : Expanded(
  //                           child: ListView(
  //                             children: const [
  //                               SizedBox(height: 550, child: FeedEmpty())
  //                             ],
  //                           ),
  //                         ),
  //                 ],
  //               );
  //             },
  //           )
  //         : const FeedLoading(),
  //   );
  // }
  // ! Not working / pagination
  @override
  Widget build(BuildContext context) {
    return Consumer<FeedLoader>(
      builder: (_, loader, __) => loader.loaded
          ?
          // Consumer<FeedData>(
          //     builder: (_, data, __) {
          //       var feed = type == "request"
          //           ? data.sortedRequestFeed()
          //           : data.sortedOfferFeed();
          //       return Column(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           CategorySwitcher(
          //             type: type,
          //           ),
          //           feed.isNotEmpty
          //               ? Expanded(
          //                   child: ListView.builder(
          //                     itemCount: feed.length,
          //                     itemBuilder: (_, index) =>
          //                         FeedItem(info: feed[index]),
          //                   ),
          //                 )
          //               : Expanded(
          //                   child: ListView(
          //                     children: const [
          //                       SizedBox(height: 550, child: FeedEmpty())
          //                     ],
          //                   ),
          //                 ),
          //         ],
          //       );
          //     },
          //   )
          Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CategorySwitcher(
                  type: type,
                ),
                Expanded(
                  child: PaginateFirestore(
                    //item builder type is compulsory.
                    itemBuilder: (context, documentSnapshots, index) {
                      var category = type == "request"
                          ? Provider.of<FeedData>(context).requestCategory
                          : Provider.of<FeedData>(context).offerCategory;
                      final doc = documentSnapshots[index];
                      var item = ItemData(
                        id: doc.id,
                        title: doc.get("title"),
                        description: doc.get("description"),
                        images: doc.get("images"),
                        image_location: doc.get("image_location"),
                        category: ItemCategory.values
                            .asNameMap()[doc.get("category")]!,
                        owner_name: doc.get("owner_name"),
                        owner_id: doc.get("owner_id"),
                        owner_contact: doc.get("owner_contact"),
                        item_type: doc.get("item_type"),
                        timestamp: doc.get("timestamp"),
                      );

                      if (category == 0 ||
                          item.category ==
                              ItemCategory.values.elementAt(category - 1)) {
                        return FeedItem(info: item);
                      }
                      return Container();
                    },
                    // orderBy is compulsory to enable pagination
                    query: FirebaseFirestore.instance
                        .collection('feed')
                        .where("item_type", isEqualTo: type)
                        .orderBy('timestamp', descending: true),
                    //Change types accordingly
                    itemBuilderType: PaginateBuilderType.listView,
                    // to fetch real-time data
                    isLive: true,
                    listeners: [
                      Provider.of<FeedData>(context).refreshChangeListener,
                    ],
                  ),
                ),
              ],
            )
          : const FeedLoading(),
    );
  }
}
