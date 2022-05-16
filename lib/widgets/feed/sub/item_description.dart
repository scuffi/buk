import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ItemDescription extends StatelessWidget {
  const ItemDescription(
      {Key? key, required this.description, this.loading = false})
      : super(key: key);

  final String description;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 500, maxHeight: 300),
        child: loading
            ? Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child:
                    Container(width: 500, height: 100, color: Colors.grey[300]))
            : SelectableText(
                description,
                textAlign: TextAlign.left,
                style: GoogleFonts.roboto(
                    textStyle:
                        const TextStyle(fontSize: 15, color: Colors.black54)),
              ),
      ),
    );
  }
}
