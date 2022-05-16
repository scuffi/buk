import 'package:flutter/cupertino.dart';

class FeedLoader extends ChangeNotifier {
  bool _loaded = false;

  bool get loaded => _loaded;

  void setLoaded(bool boolean) {
    _loaded = boolean;
    notifyListeners();
  }

  void invert() {
    _loaded = !_loaded;
    notifyListeners();
  }
}
