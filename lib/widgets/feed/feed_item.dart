import 'package:buk/widgets/feed/sub/item_carousel.dart';
import 'package:buk/widgets/feed/interface/item_data.dart';
import 'package:buk/widgets/feed/sub/item_description.dart';
import 'package:buk/widgets/feed/sub/item_footer.dart';
import 'package:buk/widgets/feed/sub/item_header.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class FeedItem extends StatelessWidget {
  const FeedItem({Key? key, required this.info, this.loading = false})
      : super(key: key);

  final ItemData info;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
            depth: 8,
            lightSource: LightSource.topLeft,
            color: Colors.white),
        child: Column(
          children: [
            ItemHeader(info: info, loading: loading),
            ItemCarousel(images: info.images, loading: loading),
            ItemDescription(description: info.description, loading: loading),
            ItemFooter(info: info, loading: loading),
          ],
        ),
      ),
    );
  }
}
