import 'package:buk/api/feed_api.dart';
import 'package:buk/providers/user_provider.dart';
import 'package:buk/widgets/feed/interface/item_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../translate/translate_text.dart';

class ItemHeader extends StatelessWidget {
  const ItemHeader({Key? key, required this.info, this.loading = false})
      : super(key: key);

  final ItemData info;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 50,
          width: 322,
          padding: const EdgeInsets.only(left: 10),
          child: Align(
            child: loading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                        width: 180, height: 30, color: Colors.grey[300]))
                : TranslateText(
                    text: info.title,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Colors.black87,
                        fontSize: 22,
                        overflow: TextOverflow.ellipsis,
                      ),
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
                : const SizedBox(
                    height: 50,
                    width: 50,
                    child: Icon(
                      Icons.bookmark_outline,
                      color: Colors.black87,
                    ),
                  ),
      ],
    );
  }
}
