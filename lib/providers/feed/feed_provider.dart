import 'package:buk/providers/feed/feed_type.dart';
import 'package:buk/widgets/feed/interface/category_type.dart';
import 'package:buk/widgets/feed/interface/item_data.dart';
import 'package:flutter/material.dart';

class FeedData with ChangeNotifier {
  List<ItemData> _request_items = [];
  List<ItemData> _offer_items = [];

  int _offer_category = 0;
  int _request_category = 0;

  int get offerCategory => _offer_category;
  int get requestCategory => _request_category;

  List<ItemData> get requestItems => _request_items;
  List<ItemData> get offerItems => _offer_items;
  List<ItemData> get fullFeed => [..._request_items, ..._offer_items];

  // ! General use functions
  void setCategory(int index, FeedType feedType) {
    if (feedType == FeedType.offer) {
      _offer_category = index;
    } else {
      _request_category = index;
    }
    notifyListeners();
  }

  List<ItemData> getFeed(FeedType feedType) {
    return feedType == FeedType.request ? _request_items : _offer_items;
  }

  void insertItem(int index, ItemData item, FeedType feedType) {
    // ? Only insert if the index we're inserting into is in our list
    if (index > getFeed(feedType).length) {
      return;
    }

    // ? Only add if it is unique (not already there)
    if (getFeed(feedType).any((element) => element.id == item.id)) {
      return;
    }

    if (feedType == FeedType.request) {
      _request_items.insert(index, item);
    } else {
      _offer_items.insert(index, item);
    }
    notifyListeners();
  }

  void setItemAt(int index, ItemData item, FeedType feedType) {
    feedType == FeedType.request
        ? _offer_items[index] = item
        : _request_items[index] = item;
    notifyListeners();
  }

  void setItems(List<ItemData> items, FeedType feedType) {
    if (feedType == FeedType.offer) {
      _offer_items = items;
    } else {
      _request_items = items;
    }
    notifyListeners();
  }

  void addItem(ItemData item, FeedType feedType) {
    if (feedType == FeedType.offer) {
      _offer_items.add(item);
    } else {
      _request_items.add(item);
    }
    notifyListeners();
  }

  void clearItems(FeedType? feedType) {
    if (feedType == FeedType.offer) {
      _offer_items.clear();
    } else if (feedType == FeedType.request) {
      _request_items.clear();
    } else {
      _offer_items.clear();
      _request_items.clear();
    }
    notifyListeners();
  }

  ItemData itemAt(int index, FeedType feedType) {
    return feedType == FeedType.offer
        ? _offer_items.elementAt(index)
        : _request_items.elementAt(index);
  }

  void removeById(String id, FeedType feedType) {
    getFeed(feedType).removeWhere((element) => element.id == id);
    notifyListeners();
  }

  // ! Specific use functions

  List<ItemData> sortedOfferFeed() {
    if (_offer_category == 0) return _offer_items;

    var newList = List<ItemData>.from(_offer_items);
    var category = _offer_category == 0
        ? null
        : ItemCategory.values.elementAt(_offer_category - 1);

    newList.retainWhere((element) => element.category == category);

    return newList;
  }

  List<ItemData> sortedRequestFeed() {
    if (_request_category == 0) return _request_items;

    var newList = List<ItemData>.from(_request_items);

    var category = _request_category == 0
        ? null
        : ItemCategory.values.elementAt(_request_category - 1);

    newList.retainWhere((element) => element.category == category);

    return newList;
  }
}
