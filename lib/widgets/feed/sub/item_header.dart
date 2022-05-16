import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ItemHeader extends StatelessWidget {
  const ItemHeader({Key? key, required this.title, this.loading = false})
      : super(key: key);

  final String title;
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
                : Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      textStyle:
                          const TextStyle(color: Colors.black87, fontSize: 22),
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
            : const SizedBox(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.bookmark,
                  color: Colors.black87,
                ),
              ),
      ],
    );
  }
}
