import 'package:buk/widgets/feed/interface/category_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemData {
  String id;
  String title;
  String description;
  List<dynamic> images;
  ItemCategory category;

  String owner_name;
  String owner_id;
  Map owner_contact;

  String item_type;

  Timestamp? timestamp;

  ItemData({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.category,
    required this.owner_name,
    required this.owner_id,
    required this.owner_contact,
    required this.timestamp,
    this.item_type = "request",
  });

  @override
  String toString() {
    // TODO: implement toString
    return {"title": title}.toString();
  }
}
