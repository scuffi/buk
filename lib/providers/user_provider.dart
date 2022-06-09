import 'package:buk/widgets/feed/interface/item_data.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:buk/api/user_api.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  List<String> _likes = [];

  User? get user => _user;
  List<String> get likes => _likes;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> addLike(ItemData item) async {
    bool success = await addUserLike(user!, item);

    if (success) {
      _likes.add(item.id);
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<bool> removeLike(ItemData item) async {
    bool success = await removeUserLike(user!, item);

    if (success) {
      _likes.remove(item.id);
      notifyListeners();
      return true;
    }

    return false;
  }

  void defaultAddLikes(List<String> likes) {
    _likes.addAll(likes);
    notifyListeners();
  }

  bool hasLiked(ItemData item) {
    return _likes.contains(item.id);
  }

  void clearUser() {
    _user = null;
    _likes = [];
    notifyListeners();
  }
}
