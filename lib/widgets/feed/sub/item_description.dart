import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemDescription extends StatelessWidget {
  const ItemDescription({Key? key, required this.description})
      : super(key: key);

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 500, maxHeight: 300),
        child: SelectableText(
          description,
          textAlign: TextAlign.left,
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(fontSize: 15, color: Colors.black54)),
        ),
      ),
    );
  }
}
