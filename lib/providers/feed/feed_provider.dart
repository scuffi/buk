import 'package:buk/widgets/feed/interface/item_data.dart';
import 'package:flutter/material.dart';

class FeedData with ChangeNotifier {
  List<ItemData> _request_items = [];
  List<ItemData> _offer_items = [];

  List<ItemData> get requestItems => _request_items;
  List<ItemData> get offerItems => _offer_items;
  List<ItemData> get fullFeed => [..._request_items, ..._offer_items];

  ItemData requestItemAt(int index) {
    return _request_items.elementAt(index);
  }

  ItemData offerItemAt(int index) {
    return _offer_items.elementAt(index);
  }

  void setRequestItemAt(int index, ItemData item) {
    _request_items[index] = item;
    notifyListeners();
  }

  void setOfferItemAt(int index, ItemData item) {
    _offer_items[index] = item;
    notifyListeners();
  }

  void setRequestItems(List<ItemData> items) {
    _request_items = items;
    notifyListeners();
  }

  void setOfferItems(List<ItemData> items) {
    _offer_items = items;
    notifyListeners();
  }

  void addRequestItem(ItemData item) {
    _request_items.add(item);
    notifyListeners();
  }

  void addOfferItem(ItemData item) {
    _offer_items.add(item);
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  void clearRequestItems() {
    _request_items.clear();
    notifyListeners();
  }

  void clearOfferItems() {
    _offer_items.clear();
    notifyListeners();
  }

  void clearAll() {
    _offer_items.clear();
    _request_items.clear();
  }
}
