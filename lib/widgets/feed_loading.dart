import 'package:buk/widgets/feed/feed_item.dart';
import 'package:buk/widgets/feed/interface/category_type.dart';
import 'package:buk/widgets/feed/interface/item_data.dart';
import 'package:flutter/material.dart';

class FeedLoading extends StatelessWidget {
  const FeedLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        FeedItem(
          info: ItemData(
              title: "",
              description: "",
              images: [],
              category: ItemCategory.clothes,
              owner_name: "",
              owner_id: "",
              owner_contact: {}),
          loading: true,
        ),
        FeedItem(
          info: ItemData(
              title: "",
              description: "",
              images: [],
              category: ItemCategory.clothes,
              owner_name: "",
              owner_id: "",
              owner_contact: {}),
          loading: true,
        ),
        FeedItem(
          info: ItemData(
              title: "",
              description: "",
              images: [],
              category: ItemCategory.clothes,
              owner_name: "",
              owner_id: "",
              owner_contact: {}),
          loading: true,
        ),
      ],
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
