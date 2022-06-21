import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';

class ViewableImage extends StatelessWidget {
  ViewableImage(this.imageUrl, this.itemName, {Key? key}) : super(key: key);

  String imageUrl;
  String itemName;

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismissed: () {
        Navigator.of(context).pop();
      },
      // Note that scrollable widget inside DismissiblePage might limit the functionality
      // If scroll direction matches DismissiblePage direction
      direction: DismissiblePageDismissDirection.multi,
      isFullScreen: false,
      child: InteractiveViewer(
        panEnabled: false,
        minScale: 0.2,
        maxScale: 5.0,
        child: Hero(
          tag: 'Image for $itemName',
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
