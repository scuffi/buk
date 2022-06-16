import 'package:buk/providers/donations/donations_provider.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DonationsList extends StatelessWidget {
  const DonationsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<DonationsProvider>(context);

    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      itemCount: prov.items.length,
      itemBuilder: (con, index) {
        var item = prov.items.elementAt(index);

        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
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
                ]),
            child: TextButton(
              style: const ButtonStyle(
                splashFactory: NoSplash.splashFactory,
              ),
              onPressed: (() async {
                final Uri url = Uri.parse(item.link);

                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              }),
              child: Row(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                      child: TranslateText(
                        selectable: false,
                        text: item.title,
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor)),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                        child: SizedBox(
                          width: 300,
                          child: TranslateText(
                            selectable: false,
                            text: item.description,
                            style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 13, color: Colors.black54)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color:
                                Colors.greenAccent.shade400.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_sharp,
                              color: Colors.greenAccent[400],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 2.0, right: 4.0),
                              child: Text(
                                item.publisher,
                                style: GoogleFonts.lato(
                                    color: Colors.greenAccent[400]),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[700],
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
