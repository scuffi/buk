import 'package:buk/widgets/feed/interface/category_type.dart';
import 'package:flutter/cupertino.dart';

class CategoryProvider extends ChangeNotifier {
  ItemCategory _category = ItemCategory.clothes;

  String get category => _category.toString().split('.').last;

  void setCategory(ItemCategory category) {
    _category = category;
    notifyListeners();
  }
}
