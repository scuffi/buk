import 'package:buk/widgets/feed/sub/item_carousel.dart';
import 'package:buk/widgets/feed/interface/item_data.dart';
import 'package:buk/widgets/feed/sub/item_description.dart';
import 'package:buk/widgets/feed/sub/item_footer.dart';
import 'package:buk/widgets/feed/sub/item_header.dart';
import 'package:flutter/material.dart';

class FeedItem extends StatelessWidget {
  const FeedItem({Key? key, required this.info, this.loading = false})
      : super(key: key);

  final ItemData info;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      // height: loading ? 500 : 0,
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
          ItemHeader(title: info.title, loading: loading),
          ItemCarousel(images: info.images, loading: loading),
          ItemDescription(description: info.description, loading: loading),
          ItemFooter(user: info.owner, loading: loading),
        ],
      ),
    );
  }
}
