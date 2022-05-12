import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemFooter extends StatelessWidget {
  const ItemFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: ProfilePicture(
            name: 'Archie Ferguson',
            radius: 21,
            fontsize: 15,
          ),
        ),
        SelectableText(
          "Archie Ferguson",
          style: GoogleFonts.lato(fontSize: 15, color: Colors.black87),
        ),
        const Spacer(),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.share,
            color: Colors.black87,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.message,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
