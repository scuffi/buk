import 'package:flutter/material.dart';

class FeedData with ChangeNotifier {
  final List<Map> _items = [];

  List<Map> get items => _items;

  Map itemAt(int index) {
    return _items.elementAt(index);
  }

  void setItemAt(int index, Map item) {
    _items[index] = item;
    notifyListeners();
  }

  void addItem(Map item) {
    _items.add(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
