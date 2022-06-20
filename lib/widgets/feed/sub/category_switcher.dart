import 'package:buk/providers/feed/feed_provider.dart';
import 'package:buk/providers/feed/feed_type.dart';
import 'package:buk/util/extensions.dart';
import 'package:buk/widgets/feed/interface/category_type.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CategorySwitcher extends StatefulWidget {
  const CategorySwitcher({
    Key? key,
    required this.type,
  }) : super(key: key);

  final FeedType type;

  @override
  State<CategorySwitcher> createState() => _CategorySwitcherState();
}

class _CategorySwitcherState extends State<CategorySwitcher> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 4),
      child: SizedBox(
        height: 35,
        child: Center(
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: ItemCategory.values.length + 1,
            itemBuilder: (con, index) {
              return Center(
                child: Container(
                  height: 35,
                  child: TextButton(
                    onPressed: () => setState(() {
                      var provider =
                          Provider.of<FeedData>(context, listen: false);

                      provider.setCategory(index, widget.type);

                      // updateFeeds(context);
                    }),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: TranslateText(
                        selectable: false,
                        text: index == 0
                            ? "All"
                            : ItemCategory.values
                                .elementAt(index - 1)
                                .name
                                .toCapitalized(),
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              height: 1.25,
                              color: index ==
                                      (widget.type == FeedType.request
                                          ? Provider.of<FeedData>(context,
                                                  listen: false)
                                              .requestCategory
                                          : Provider.of<FeedData>(context,
                                                  listen: false)
                                              .offerCategory)
                                  ? Colors.white
                                  : Colors.purple,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: index ==
                            (widget.type == FeedType.request
                                ? Provider.of<FeedData>(context, listen: false)
                                    .requestCategory
                                : Provider.of<FeedData>(context, listen: false)
                                    .offerCategory)
                        ? Colors.purple.withOpacity(0.9)
                        : Colors.purple.withOpacity(0.1),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 25,
                width: 10,
              );
            },
          ),
        ),
      ),
    );
  }
}
