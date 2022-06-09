import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(children: const [
            Spacer(),
            TranslateText(text: "Buk"),
            CircularProgressIndicator(),
            Spacer(),
          ]),
        ),
      ),
    );
  }
}
