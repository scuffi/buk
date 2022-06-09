import 'package:buk/api/feed_api.dart';
import 'package:buk/providers/user_provider.dart';
import 'package:buk/widgets/feed/interface/item_data.dart';
import 'package:buk/widgets/feed/sub/like_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:buk/config.dart' as config;
import 'package:buk/util/extensions.dart';

import '../../translate/translate_text.dart';

class ItemHeader extends StatelessWidget {
  const ItemHeader({Key? key, required this.info, this.loading = false})
      : super(key: key);

  final ItemData info;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Container(
          height: 70,
          width: width * 0.75,
          padding: const EdgeInsets.only(left: 10),
          child: Align(
            child: loading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                        width: width * 0.75,
                        height: 30,
                        color: Colors.grey[300]))
                : Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TranslateText(
                          text: info.title,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.black87,
                              fontSize: 22,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 4.0, right: 4),
                                child: TranslateText(
                                  text: info.item_type == "request"
                                      ? "Requesting"
                                      : "Offering",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: info.item_type == "request"
                                              ? config.requestColour
                                              : config.offerColour)),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: info.item_type == "request"
                                    ? config.requestColour.withOpacity(0.1)
                                    : config.offerColour.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: info.item_type == "request"
                                        ? config.requestColour
                                        : config.offerColour,
                                    width: 3),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4.0, right: 4),
                                  child: TranslateText(
                                    text: info.category.name.toCapitalized(),
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: config.categoryColour)),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: config.categoryColour.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: config.categoryColour, width: 3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            alignment: Alignment.centerLeft,
          ),
        ),
        const Spacer(),
        loading
            ? Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child:
                      Container(width: 35, height: 35, color: Colors.grey[300]),
                ))
            : context.read<UserProvider>().user!.uid == info.owner_id
                ? SizedBox(
                    height: 50,
                    width: 50,
                    child: TextButton(
                      child: const Icon(
                        Icons.delete,
                        color: Colors.black87,
                      ),
                      onPressed: () async {
                        // var success = await deleteItem(info.id);
                        deleteItem(info.id).then(
                          (value) => updateFeeds(context),
                        );

                        // print(success ? "Deleted" : "Failed to delete");
                        // updateFeeds(context);
                      },
                    ),
                  )
                : BookmarkButton(
                    item: info,
                  ),
      ],
    );
  }
}
