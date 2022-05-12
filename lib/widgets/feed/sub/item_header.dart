import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemHeader extends StatelessWidget {
  const ItemHeader({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 50,
          width: 322,
          padding: const EdgeInsets.only(left: 10),
          child: Align(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(color: Colors.black87, fontSize: 22),
              ),
            ),
            alignment: Alignment.centerLeft,
          ),
        ),
        const Spacer(),
        const SizedBox(
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
