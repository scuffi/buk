import 'package:buk/providers/post/post_form_provider.dart';
import 'package:buk/widgets/feed/interface/category_type.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class PostCategoryForm extends StatelessWidget {
  const PostCategoryForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return TextButton.icon(
    //   onPressed: () => showBarModalBottomSheet(
    //     expand: false,
    //     context: context,
    //     backgroundColor: Colors.transparent,
    //     builder: (context) => ListView(),
    //   ),
    //   label: const TranslateText(
    //     text: "Category",
    //     ukrainian: "Категорія",
    //     selectable: false,
    //   ),
    //   icon: const Icon(Icons.arrow_forward_ios_rounded),
    // );
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: TranslateText(
            text: "Select Category",
            ukrainian: "Виберіть категорію",
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: TextButton(
            onPressed: () => showBarModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => SizedBox(
                height: ItemCategory.values.length * 50 + 10,
                child: ListView.separated(
                  itemCount: ItemCategory.values.length,
                  itemBuilder: (context, index) => TextButton(
                    child: TranslateText(
                      selectable: false,
                      text: ItemCategory.values[index]
                          .toString()
                          .split('.')
                          .last
                          .toCapitalized(),
                    ),
                    onPressed: () => {
                      Provider.of<PostFormProvider>(context, listen: false)
                          .setCategory(ItemCategory.values[index]),
                      Navigator.pop(context),
                    },
                  ),
                  separatorBuilder: (context, index) => const Divider(
                    height: 5,
                  ),
                ),
              ),
            ),
            child: Row(
              children: [
                // TranslateText(
                //   text: Provider.of<CategoryProvider>(context)
                //       .category
                //       .toCapitalized(),
                //   selectable: false,
                // ),
                Text(Provider.of<PostFormProvider>(context)
                    .category
                    .toCapitalized()),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}
