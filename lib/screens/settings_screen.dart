import 'package:buk/widgets/settings/settings_buttons.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Column(
        children: [
          SizedBox(
            height: 175,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: TranslateText(
                  text: "Settings",
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: const Padding(
                padding: EdgeInsets.all(30.0),
                child: SettingsButtons(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
