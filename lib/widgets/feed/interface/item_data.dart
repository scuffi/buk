import 'package:buk/widgets/feed/interface/category_type.dart';

class ItemData {
  String title;
  String description;
  List<String> images;
  ItemCategory category;

  String owner;

  ItemData(
      {required this.title,
      required this.description,
      required this.images,
      required this.category,
      required this.owner});
}
