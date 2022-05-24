import 'package:buk/providers/feed/feed_loader.dart';
import 'package:buk/providers/feed/feed_provider.dart';
import 'package:buk/widgets/feed/interface/category_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../widgets/feed/interface/item_data.dart';

import 'package:buk/config.dart' as config;

void updateFeeds(BuildContext context) {
  // Set loading status
  Provider.of<FeedLoader>(context, listen: false).setLoaded(false);

  Provider.of<FeedData>(context, listen: false).clearAll();

  _fetchFeedItems().then((items) {
    // Iterate through List<ItemData>
    for (var item in items) {
      // Put items into correct types
      if (item.item_type == "request") {
        Provider.of<FeedData>(context, listen: false).addRequestItem(item);
      } else if (item.item_type == "offer") {
        Provider.of<FeedData>(context, listen: false).addOfferItem(item);
      }
    }

    // Currently uneeded, maybe change addXYZItem to not notify listeners?
    // Provider.of<FeedData>(context, listen: false).notifyListeners();

    // Set loaded to true
    Provider.of<FeedLoader>(context, listen: false).setLoaded(true);
  });
}

Future<List<ItemData>> _fetchFeedItems() async {
  var db = FirebaseFirestore.instance;
  List<ItemData> data = List.empty(growable: true);

  await db.collection(config.feedCollectionName).get().then((event) {
    for (var doc in event.docs) {
      data.add(ItemData(
        title: doc.get("title"),
        description: doc.get("description"),
        // images: doc.get("images"),
        category: ItemCategory.values.asNameMap()[doc.get("category")]!,
        owner_name: doc.get("owner_name"),
        owner_id: doc.get("owner_id"),
        owner_contact: doc.get("owner_contact"),
        item_type: doc.get("item_type"),
      ));
    }
  });

  return data;
}
