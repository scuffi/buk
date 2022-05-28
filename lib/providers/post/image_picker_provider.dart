import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class PickerProvider extends ChangeNotifier {
  final List<XFile> _images = [];

  List<XFile> get images => _images;

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
}
