import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../translate/translate_text.dart';

class ItemFooter extends StatelessWidget {
  const ItemFooter({Key? key, required this.user, this.loading = false})
      : super(key: key);

  final bool loading;
  final String user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: loading
              ? Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child:
                      Container(width: 50, height: 50, color: Colors.grey[300]))
              : ProfilePicture(
                  name: user,
                  radius: 21,
                  fontsize: 15,
                ),
        ),
        loading
            ? Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child:
                    Container(width: 165, height: 30, color: Colors.grey[300]))
            : SelectableText(
                user,
                style: GoogleFonts.lato(fontSize: 15, color: Colors.black87),
              ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: loading
              ? Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child:
                      Container(width: 35, height: 35, color: Colors.grey[300]))
              : const Icon(
                  Icons.share,
                  color: Colors.black87,
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: loading
              ? Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child:
                      Container(width: 60, height: 35, color: Colors.grey[300]))
              : OutlinedButton(
                  onPressed: () {},
                  child: const TranslateText(
                    text: "Contact",
                    ukrainian: "контакт",
                    selectable: false,
                  )),
        ),
      ],
    );
  }
}
