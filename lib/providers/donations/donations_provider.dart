import 'package:buk/widgets/feed/interface/donation_item.dart';
import 'package:flutter/cupertino.dart';

class DonationsProvider extends ChangeNotifier {
  List<DonationItem> _items = [];

  List<DonationItem> get items => _items;

  void setItems(List<DonationItem> items) {
    _items = items;
    notifyListeners();
  }
}
