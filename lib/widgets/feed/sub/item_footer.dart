import 'dart:io';

import 'package:buk/providers/user_provider.dart';
import 'package:buk/widgets/feed/interface/item_data.dart';
import 'package:buk/widgets/feed/sub/admin_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:timeago/timeago.dart' as timeago;

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
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade300,
                  child:
                      Container(width: 50, height: 50, color: Colors.grey[300]))
              : (isAdmin(context)
                  ? AdminButton(info: info)
                  : ProfilePicture(
                      name: info.owner_name,
                      radius: 21,
                      fontsize: 15,
                    )),
        ),
        loading
            ? Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child:
                    Container(width: 165, height: 30, color: Colors.grey[300]))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    info.owner_name,
                    style:
                        GoogleFonts.lato(fontSize: 15, color: Colors.black87),
                  ),
                  SelectableText(
                    timeago.format(DateTime.fromMillisecondsSinceEpoch(
                        info.timestamp != null
                            ? info.timestamp!.millisecondsSinceEpoch
                            : DateTime.now().millisecondsSinceEpoch)),
                    style: GoogleFonts.lato(
                        textStyle:
                            TextStyle(fontSize: 12, color: Colors.grey[600])),
                  )
                ],
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
                      await sendMessage(
                          context,
                          info.owner_contact["phone"].toString(),
                          "Hi, I'm interested in ${info.title}");
                    } else if (info.owner_contact.containsKey("email")) {
                      launchUrlString('mailto:${info.owner_contact["email"]}');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Users contact was invalid, please report this.'),
                        ),
                      );
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

  bool isAdmin(BuildContext context) {
    return Provider.of<UserProvider>(context, listen: false).admin;
  }

  sendMessage(BuildContext context, String number, String message) async {
    var whatsappURl_android =
        "whatsapp://send?phone=" + number + "&text=$message";
    var whatappURL_ios = "https://wa.me/$number?text=${Uri.parse(message)}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrlString(whatappURL_ios)) {
        await launchUrlString(whatappURL_ios);
      } else {
        String? encodeQueryParameters(Map<String, String> params) {
          return params.entries
              .map((e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
              .join('&');
        }

        Uri smsUri = Uri(
          scheme: 'sms',
          path: number,
          query: encodeQueryParameters(<String, String>{'body': message}),
        );

        try {
          if (await canLaunchUrlString(smsUri.toString())) {
            await launchUrlString(smsUri.toString());
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to launch messaging service'),
            ),
          );
        }
      }
    } else {
      // android , web
      if (await canLaunchUrlString(whatsappURl_android)) {
        await launchUrlString(whatsappURl_android);
      } else {
        String? encodeQueryParameters(Map<String, String> params) {
          return params.entries
              .map((e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
              .join('&');
        }

        Uri smsUri = Uri(
          scheme: 'sms',
          path: number,
          query: encodeQueryParameters(<String, String>{'body': message}),
        );

        try {
          if (await canLaunchUrlString(smsUri.toString())) {
            await launchUrlString(smsUri.toString());
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to launch messaging service'),
            ),
          );
        }
      }
    }
  }
}
