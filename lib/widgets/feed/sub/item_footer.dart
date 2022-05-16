import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ItemFooter extends StatelessWidget {
  const ItemFooter({Key? key, this.loading = false}) : super(key: key);

  final bool loading;

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
              : const ProfilePicture(
                  name: 'Archie Ferguson',
                  radius: 21,
                  fontsize: 15,
                ),
        ),
        loading
            ? Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child:
                    Container(width: 180, height: 30, color: Colors.grey[300]))
            : SelectableText(
                "Archie Ferguson",
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
          padding: const EdgeInsets.all(8.0),
          child: loading
              ? Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child:
                      Container(width: 35, height: 35, color: Colors.grey[300]))
              : const Icon(
                  Icons.message,
                  color: Colors.black87,
                ),
        ),
      ],
    );
  }
}
