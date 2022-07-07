import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:buk/providers/post/post_form_provider.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TypeSelector extends StatelessWidget {
  const TypeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 2.0),
            child: TranslateText(
              text: "I am...",
              style:
                  GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 22)),
            ),
          ),
        ),
        Consumer<PostFormProvider>(
          builder: (context, value, child) {
            return AnimatedToggleSwitch<bool>.size(
              innerColor: Colors.white,
              height: 45,
              // borderRadius: BorderRadius.circular(32),
              dif: 8,
              borderColorBuilder: (i) => Colors.transparent,
              current: value.type == "request",
              values: const [true, false],
              indicatorSize: const Size(150, 40),
              borderColor: Colors.transparent,
              onTap: () {
                value.setType(value.type == "request" ? "offer" : "request");
              },
              onChanged: (i) {
                value.setType(!i ? "offer" : "request");
              },
              iconBuilder: (type, size) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(32),
                    border: const Border(),
                  ),
                  child: Center(
                    child: TranslateText(
                      text: type ? "Requesting" : "Offering",
                      ukrainian: type ? "Запит" : "Пропонування",
                      selectable: false,
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              color: Colors.white, fontSize: 18)),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
