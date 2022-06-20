import 'package:buk/providers/feed/feed_provider.dart';
import 'package:buk/widgets/feed/interface/item_data.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:buk/api/user_api.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  List<ItemData> _likes = [];

  User? get user => _user;
  List<ItemData> get likes => _likes;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  bool _existsInFeed(ItemData item, FeedData feed) {
    return feed.fullFeed.contains(item);
  }

  Future<bool> addLike(ItemData item, FeedData feed) async {
    if (_existsInFeed(item, feed)) {
      bool success = await addUserLike(user!, item);

      if (success) {
        _likes.add(item);
        notifyListeners();
        return true;
      }
    }

    return false;
  }

  Future<bool> removeLike(ItemData item) async {
    bool success = await removeUserLike(user!, item);

    if (success) {
      _likes.remove(item);
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<bool> removeLikes(List<ItemData> itemIds) async {
    bool success = await removeUserLikes(user!, itemIds);

    if (success) {
      _likes.removeWhere(((element) => itemIds.contains(element)));
      notifyListeners();
      return true;
    }

    return false;
  }

  void defaultAddLikes(List<ItemData> likes, FeedData feed) {
    _likes.addAll(likes);

    notifyListeners();
  }

  bool hasLiked(ItemData item) {
    return _likes.any((element) => element.id == item.id);
  }

  void clearUser() {
    _user = null;
    _likes = [];
    notifyListeners();
  }
}
