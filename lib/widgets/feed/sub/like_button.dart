import 'package:buk/providers/feed/feed_provider.dart';
import 'package:buk/providers/user_provider.dart';
import 'package:buk/widgets/feed/interface/item_data.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

class BookmarkButton extends StatefulWidget {
  BookmarkButton({Key? key, required this.item, required this.liked})
      : super(key: key);

  ItemData item;
  bool liked;

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: LikeButton(
        isLiked: widget.liked,
        likeBuilder: (isLiked) {
          return Icon(
            isLiked ? Icons.bookmark : Icons.bookmark_outline,
            color: isLiked ? Colors.yellow[800] : Colors.black,
          );
        },
        onTap: (liked) async {
          var user = Provider.of<UserProvider>(context, listen: false);
          var feed = Provider.of<FeedData>(context, listen: false);

          bool success = liked
              ? await user.removeLike(widget.item)
              : await user.addLike(widget.item, feed);

          return success ? !liked : liked;
        },
      ),
    );
  }
}
