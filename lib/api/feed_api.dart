import 'dart:io';

import 'package:buk/providers/feed/feed_loader.dart';
import 'package:buk/providers/feed/feed_provider.dart';
import 'package:buk/widgets/feed/interface/category_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../widgets/feed/interface/item_data.dart';

import 'package:buk/config.dart' as config;

Future<void> updateFeeds(BuildContext context) async {
  // Set loading status
  final loader = Provider.of<FeedLoader>(context, listen: false);
  final feed = Provider.of<FeedData>(context, listen: false);

  loader.setLoaded(false);

  feed.clearAll();

  var items = await _fetchFeedItems();
  // Iterate through List<ItemData>
  for (var item in items) {
    // Put items into correct types

    if (item.item_type == "request") {
      feed.addRequestItem(item);
    } else if (item.item_type == "offer") {
      feed.addOfferItem(item);
    }
  }

  loader.setLoaded(true);
}

Future<List<ItemData>> _fetchFeedItems() async {
  var db = FirebaseFirestore.instance;
  List<ItemData> data = List.empty(growable: true);

  await db
      .collection(config.feedCollectionName)
      .orderBy("timestamp", descending: true)
      .get()
      .then((event) {
    for (var doc in event.docs) {
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
  });

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

  // Check if image location is valid, if it is we can then try delete the location
  if (imageLocation != null) {
    await FirebaseStorage.instance
        .ref("images/$imageLocation")
        .listAll()
        .then((value) {
      for (var element in value.items) {
        FirebaseStorage.instance.ref(element.fullPath).delete();
      }
    });
  }

  // Get the feed collection
  var col = db.collection(config.feedCollectionName);

  try {
    await col.doc(itemId).delete();
    return true;
  } catch (e) {
    return false;
  }
}
