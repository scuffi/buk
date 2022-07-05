import 'package:buk/api/feed_api.dart';
import 'package:buk/api/user_api.dart';
import 'package:buk/providers/language/language_enum.dart';
import 'package:buk/providers/language/language_provider.dart';
import 'package:buk/providers/user_provider.dart';
import 'package:buk/widgets/feed/interface/blocked_type.dart';
import 'package:buk/widgets/feed/interface/item_data.dart';
import 'package:buk/widgets/feed/sub/like_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        Expanded(
          child: Container(
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
                                  padding: const EdgeInsets.only(
                                      left: 8.0,
                                      right: 6.0,
                                      top: 2.0,
                                      bottom: 2.0),
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
                                  // border: Border.all(
                                  //     color: info.item_type == "request"
                                  //         ? config.requestColour
                                  //         : config.offerColour,
                                  //     width: 3),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 6.0,
                                        top: 2.0,
                                        bottom: 2.0),
                                    child: TranslateText(
                                      text: info.category.name.toCapitalized(),
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: config.categoryColour)),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        config.categoryColour.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                    // border: Border.all(
                                    //     color: config.categoryColour, width: 3),
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
        ),
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

                        deleteItem(info.id, info.image_location);

                        // print(success ? "Deleted" : "Failed to delete");
                        // updateFeeds(context);
                      },
                    ),
                  )
                : BookmarkButton(
                    item: info,
                    liked: Provider.of<UserProvider>(context, listen: true)
                        .hasLiked(info),
                  ),
        context.read<UserProvider>().user!.uid != info.owner_id
            ? SizedBox(
                height: 50,
                width: 50,
                child: TextButton(
                  child: const Icon(
                    Icons.more_vert,
                    color: Colors.black87,
                  ),
                  onPressed: () async {
                    queryDialog(context, info);
                  },
                ),
              )
            : Container()
      ],
    );
  }

  void queryDialog(BuildContext context, ItemData item) {
    showDialog(
        context: context,
        builder: (con) {
          return AlertDialog(
            title: const TranslateText(text: "More..."),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        await Provider.of<UserProvider>(context, listen: false)
                            .addBlock(BlockItem(
                                id: item.owner_id, name: item.owner_name));
                        Navigator.pop(context);
                      },
                      child: TranslateText(
                        text: "Block '${item.owner_name}'",
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        reportDialog(context, item);
                      },
                      child: TranslateText(
                        text: "Report '${item.title}'",
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: TranslateText(
                  text: "Cancel",
                  ukrainian: "Скасувати",
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.grey[700])),
                ),
              ),
            ],
          );
        });
  }

  void reportDialog(BuildContext context, ItemData item) {
    showDialog(
        context: context,
        builder: (con) {
          var text = "";
          return AlertDialog(
            title: TranslateText(text: "Report '${item.title}'"),
            content: SizedBox(
              width: 500,
              child: Form(
                child: TextFormField(
                  maxLength: 150,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  maxLines: 4,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (input) {
                    if (input == null || input.length < 25) {
                      return Provider.of<Language>(context).language ==
                              LanguageType.en
                          ? "Reports must have at least 25 characters"
                          : "Звіти повинні мати не менше 25 символів";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (str) {
                    text = str;
                  },
                ),
              ),
            ),
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: TranslateText(
                  text: "Cancel",
                  ukrainian: "Скасувати",
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.grey[700])),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  loadingDialog(context, "Submitting report");
                  var success = await reportPost(item, text);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: TranslateText(
                      text:
                          "Submitted your report. Please give us time to resolve it.",
                      ukrainian:
                          "Надіслали свій звіт. Дайте нам час вирішити це питання.",
                    )));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: TranslateText(
                      text: "Failed to submit report. Please try again later.",
                      ukrainian:
                          "He вдалося подати звіт. Будь-ласка спробуйте пізніше.",
                    )));
                  }
                },
                child: TranslateText(
                  text: "Submit report",
                  ukrainian: "Здати звіт",
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(color: Colors.white)),
                ),
              ),
            ],
          );
        });
  }

  void loadingDialog(BuildContext context, String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.indigoAccent[100],
            child: SizedBox(
              height: 200,
              width: 350,
              child: Column(children: [
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: CircularProgressIndicator(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: TranslateText(
                    text: message,
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(fontSize: 18)),
                  ),
                ),
                const Spacer(),
              ]),
            ),
          );
        });
  }
}
