import 'dart:io';

import 'package:buk/providers/feed/feed_loader.dart';
import 'package:buk/providers/feed/feed_provider.dart';
import 'package:buk/providers/feed/feed_type.dart';
import 'package:buk/widgets/feed/interface/category_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../widgets/feed/interface/item_data.dart';

import 'package:buk/config.dart' as config;

Future<void> loadItems(
    {required BuildContext context, required FeedType feedType}) async {
  // Set loading status
  final loader = Provider.of<FeedLoader>(context, listen: false);
  final feed = Provider.of<FeedData>(context, listen: false);

  loader.setLoaded(false);

  feed.clearItems(feedType);

  var items =
      await _fetchFeedItems(limit: config.limitAmount, feedType: feedType);
  // Iterate through List<ItemData>
  for (var item in items) {
    // Put items into correct types
    feed.addItem(item, feedType);
  }
  loader.setLoaded(true);
}

Future<void> loadMore(
    {required BuildContext context, required FeedType feedType}) async {
  print("Loading more called");
  var db = FirebaseFirestore.instance;
  final feed = Provider.of<FeedData>(context, listen: false);

  var lastItem =
      await db.collection("feed").doc(feed.getFeed(feedType).last.id).get();

  var documents = await db
      .collection(config.feedCollectionName)
      .where("item_type", isEqualTo: feedType.name)
      .orderBy("timestamp", descending: true)
      .startAfterDocument(lastItem)
      .limit(config.limitAmount)
      .get();

  for (var doc in documents.docs) {
    print("Adding ${doc.get('title')}");
    feed.addItem(
        ItemData(
          id: doc.id,
          title: doc.get("title"),
          description: doc.get("description"),
          images: doc.get("images"),
          image_location: doc.get("image_location"),
          category: ItemCategory.values.asNameMap()[doc.get("category")]!,
          owner_name: doc.get("owner_name"),
          owner_id: doc.get("owner_id"),
          owner_contact: doc.get("owner_contact"),
          item_type: doc.get("item_type"),
          timestamp: doc.get("timestamp"),
        ),
        feedType);
  }
}

Future<List<ItemData>> _fetchFeedItems(
    {required int limit, required FeedType feedType}) async {
  var db = FirebaseFirestore.instance;
  List<ItemData> data = List.empty(growable: true);

  var conn = await db
      .collection(config.feedCollectionName)
      .where("item_type", isEqualTo: feedType.name)
      .orderBy("timestamp", descending: true)
      .limit(limit)
      .get();

  for (var doc in conn.docs) {
    data.add(ItemData(
      id: doc.id,
      title: doc.get("title"),
      description: doc.get("description"),
      images: doc.get("images"),
      image_location: doc.get("image_location"),
      category: ItemCategory.values.asNameMap()[doc.get("category")]!,
      owner_name: doc.get("owner_name"),
      owner_id: doc.get("owner_id"),
      owner_contact: doc.get("owner_contact"),
      item_type: doc.get("item_type"),
      timestamp: doc.get("timestamp"),
    ));
  }

  return data;
}

Future<List<String>> uploadImages(List<XFile> images, String idHash) async {
  List<String> urls = [];
  for (XFile image in images) {
    final path = "images/$idHash/${image.name}";
    final file = File(image.path);

    final ref = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask = ref.putFile(file);

    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();

    urls.add(downloadUrl);
  }
  return urls;
}

Future<bool> uploadItem(
    String ownerId,
    String ownerName,
    Map ownerContact,
    String title,
    String description,
    List<String> imageLinks,
    String? imageLocationHash,
    String itemType,
    String category) async {
  var db = FirebaseFirestore.instance;
  var col = db.collection(config.feedCollectionName);

  Map<String, dynamic> info = {};
  info["title"] = title;
  info["description"] = description;
  info["images"] = imageLinks;
  info["image_location"] = imageLocationHash;
  info["item_type"] = itemType;
  info["category"] = category;

  info["owner_id"] = ownerId;
  info["owner_name"] = ownerName;
  info["owner_contact"] = ownerContact;

  info["timestamp"] = FieldValue.serverTimestamp();
  // info["timestamp"] = Timestamp.now().millisecondsSinceEpoch;

  try {
    await col.add(info);
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> deleteItem(String itemId, String? imageLocation) async {
  var db = FirebaseFirestore.instance;

  // Get the feed collection
  var col = db.collection(config.feedCollectionName);

  try {
    await col.doc(itemId).delete();
    return true;
  } catch (e) {
    return false;
  }
}
