import 'package:buk/widgets/feed/interface/category_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class PostFormProvider extends ChangeNotifier {
  String _type = "request";
  String? _title = "";
  String? _desc = "";
  ItemCategory _category = ItemCategory.clothes;
  final List<XFile> _images = [];

  String get type => _type;
  String? get title => _title;
  String? get description => _desc;
  String get category => _category.toString().split('.').last;
  List<XFile> get images => _images;

  // ? Type
  void setType(String type) {
    _type = type;
    notifyListeners();
  }

  // ? Title
  void setTitle(String? title) {
    _title = title;
    notifyListeners();
  }

  // ? Description
  void setDescription(String? description) {
    _desc = description;
    notifyListeners();
  }

  // ? Category
  void setCategory(ItemCategory category) {
    _category = category;
    notifyListeners();
  }

  // ? Images
  void addImage(XFile image) {
    _images.add(image);
    notifyListeners();
  }

  void removeImage(int index) {
    _images.removeAt(index);
    notifyListeners();
  }

  void addImages(List<XFile> images) {
    _images.addAll(images);
    notifyListeners();
  }

  void clearImages() {
    _images.clear();
    notifyListeners();
  }

  // ? Global reset
  void reset() {
    _type = "request";
    _title = "";
    _desc = "";
    _category = ItemCategory.clothes;
    _images.clear();
  }
}
