import 'package:buk/api/admin_api.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerificationItem extends StatefulWidget {
  VerificationItem({Key? key, required this.user}) : super(key: key);

  String user;

  @override
  State<VerificationItem> createState() => _VerificationItemState();
}

class _VerificationItemState extends State<VerificationItem> {
  bool buttonsEnabled = true;

  @override
  void initState() {
    super.initState();
    // ! Requests user information here
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(widget.user),
      builder: ((context, AsyncSnapshot<Map> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Text('Loading....');
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return getItem(snapshot.data!);
            }
        }
      }),
    );
  }

  Widget getItem(Map data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Verify " + data["displayname"]),
                      content: Text(data["phone"]),
                      actions: [
                        OutlinedButton(
                            onPressed: buttonsEnabled
                                ? () async {
                                    setState(() {
                                      buttonsEnabled = false;
                                    });
                                    await deleteUser(widget.user);
                                    Navigator.pop(context);
                                  }
                                : null,
                            child: const Text("Delete")),
                        ElevatedButton(
                            onPressed: buttonsEnabled
                                ? () async {
                                    setState(() {
                                      buttonsEnabled = false;
                                    });
                                    verifyUser(widget.user);
                                    Navigator.pop(context);
                                  }
                                : null,
                            child: const Text("Verify")),
                      ],
                    );
                  });
            },
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TranslateText(
                      text: data["displayname"],
                      selectable: false,
                      style: GoogleFonts.poppins(
                        textStyle:
                            const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                    Text(
                      data["phone"],
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            color: Colors.black54, fontSize: 15),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_right),
              ],
            ),
          ),
        ), // ! Somethere here
      ),
    );
  }
}
