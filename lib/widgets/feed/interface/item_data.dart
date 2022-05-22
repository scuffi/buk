import 'package:buk/widgets/feed/interface/category_type.dart';

class ItemData {
  String title;
  String description;
  List<String>? images;
  ItemCategory category;

  String owner_name;
  String owner_id;
  Map owner_contact;

  String item_type;

  ItemData({
    required this.title,
    required this.description,
    this.images,
    required this.category,
    required this.owner_name,
    required this.owner_id,
    required this.owner_contact,
    this.item_type = "request",
  });
}
