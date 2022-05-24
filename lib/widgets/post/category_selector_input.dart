import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PostCategoryForm extends StatelessWidget {
  const PostCategoryForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => showBarModalBottomSheet(
        expand: false,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ListView(),
      ),
      label: const TranslateText(
        text: "Category",
        ukrainian: "Категорія",
      ),
      icon: const Icon(Icons.arrow_forward_ios_rounded),
    );
  }
}
