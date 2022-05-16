import 'package:buk/widgets/feed/interface/item_data.dart';
import 'package:flutter/material.dart';

class FeedData with ChangeNotifier {
  final List<ItemData> _items = [];

  List<ItemData> get items => _items;

  ItemData itemAt(int index) {
    return _items.elementAt(index);
  }

  void setItemAt(int index, ItemData item) {
    _items[index] = item;
    notifyListeners();
  }

  void addItem(ItemData item) {
    _items.add(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
