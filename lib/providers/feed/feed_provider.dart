import 'package:buk/widgets/feed/interface/category_type.dart';
import 'package:buk/widgets/feed/interface/item_data.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';

class FeedData with ChangeNotifier {
  List<ItemData> _request_items = [];
  List<ItemData> _offer_items = [];
  final PaginateRefreshedChangeListener _refreshChangeListener =
      PaginateRefreshedChangeListener();

  int _offer_category = 0;
  int _request_category = 0;

  int get offerCategory => _offer_category;
  int get requestCategory => _request_category;

  List<ItemData> get requestItems => _request_items;
  List<ItemData> get offerItems => _offer_items;
  List<ItemData> get fullFeed => [..._request_items, ..._offer_items];

  PaginateRefreshedChangeListener get refreshChangeListener =>
      _refreshChangeListener;

  ItemData requestItemAt(int index) {
    return _request_items.elementAt(index);
  }

  ItemData offerItemAt(int index) {
    return _offer_items.elementAt(index);
  }

  void setOfferCategory(int index) {
    _offer_category = index;
    notifyListeners();
  }

  void setRequestCategory(int index) {
    _request_category = index;
    notifyListeners();
  }

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
