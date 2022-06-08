import 'package:buk/widgets/feed/interface/item_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../translate/translate_text.dart';

class ItemFooter extends StatelessWidget {
  const ItemFooter({Key? key, required this.info, this.loading = false})
      : super(key: key);

  final bool loading;
  final ItemData info;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: loading
              ? Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child:
                      Container(width: 50, height: 50, color: Colors.grey[300]))
              : ProfilePicture(
                  name: info.owner_name,
                  radius: 21,
                  fontsize: 15,
                ),
        ),
        loading
            ? Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child:
                    Container(width: 165, height: 30, color: Colors.grey[300]))
            : SelectableText(
                info.owner_name,
                style: GoogleFonts.lato(fontSize: 15, color: Colors.black87),
              ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: loading
              ? Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child:
                      Container(width: 35, height: 35, color: Colors.grey[300]))
              : TextButton(
                  onPressed: () async {
                    await Share.share(
                        '${info.title}\n\n${info.description} \nBy ${info.owner_name}',
                        subject: info.title);
                  },
                  child: const Icon(
                    Icons.share,
                    color: Colors.black87,
                  ),
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: loading
              ? Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child:
                      Container(width: 60, height: 35, color: Colors.grey[300]))
              : OutlinedButton(
                  onPressed: () async {
                    if (info.owner_contact.containsKey("phone")) {
                      try {
                        await sendSMS(
                            message: "I'm interested in ${info.title}",
                            recipients: [
                              info.owner_contact["phone"].toString()
                            ]);
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Failed to launch message service')),
                        );
                        launchUrlString(
                            'mailto:${info.owner_contact["email"]}');
                      }
                    } else if (info.owner_contact.containsKey("email")) {
                      launchUrlString('mailto:${info.owner_contact["email"]}');
                    }
                  },
                  child: const TranslateText(
                    text: "Contact",
                    ukrainian: "контакт",
                    selectable: false,
                  ),
                ),
        ),
      ],
    );
  }
}
