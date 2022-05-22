import 'package:buk/widgets/feed/interface/category_type.dart';
import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: ItemCategory.values
            .map((e) => Text(e.toString().split('.').last))
            .toList(),
      ),
    );
  }
}
