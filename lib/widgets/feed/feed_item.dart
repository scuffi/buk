import 'package:buk/widgets/feed/sub/item_carousel.dart';
import 'package:buk/widgets/feed/sub/item_description.dart';
import 'package:buk/widgets/feed/sub/item_footer.dart';
import 'package:buk/widgets/feed/sub/item_header.dart';
import 'package:flutter/material.dart';

class FeedItem extends StatelessWidget {
  const FeedItem({Key? key, required this.info}) : super(key: key);

  final Map info;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      // height: 500,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          ItemHeader(title: info["title"]),
          const ItemCarousel(),
          ItemDescription(description: info["description"]),
          const ItemFooter(),
        ],
      ),
    );
  }
}
