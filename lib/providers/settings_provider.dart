import 'package:flutter/cupertino.dart';

class SettingsProvider extends ChangeNotifier {
  bool _notifications = true;

  bool get notifications => _notifications;

  void setNotifications(bool bool) {
    _notifications = bool;
    notifyListeners();
  }

  void toggleNotifications() {
    _notifications = !_notifications;
    notifyListeners();
  }
}
