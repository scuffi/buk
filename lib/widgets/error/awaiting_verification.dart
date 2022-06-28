import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AwaitingVerification extends StatelessWidget {
  const AwaitingVerification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SvgPicture.asset(
                "assets/awaiting.svg",
                semanticsLabel: 'Awaiting verification',
                fit: BoxFit.cover,
              ),
              TranslateText(
                text: "Check back soon...",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(fontSize: 48),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: TranslateText(
                  text:
                      "We're currently in the process of verifying your account, this shouldn't take anymore than 24 hours but please be patient.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle:
                        const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                "Image by 'storyset' from storyset.com",
                style: GoogleFonts.poppins(
                  textStyle:
                      const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
