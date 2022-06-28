import 'package:buk/widgets/translate/translate_text.dart';
import 'package:buk/widgets/verification/verification_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class VerificationsScreen extends StatelessWidget {
  const VerificationsScreen({Key? key}) : super(key: key);

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
                  text: "Users awaiting verification",
                  textAlign: TextAlign.center,
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
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.black87,
                            size: 40,
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 4.0, right: 4.0, top: 4.0),
                      // Future builder to fetch posts?
                      child:
                          // StreamBuilder<QuerySnapshot>(
                          //   stream: FirebaseFirestore.instance
                          //       .collection('verifications')
                          //       .orderBy("timestamp", descending: false)
                          //       .snapshots(),
                          //   builder: (context, snapshot) {
                          //     if (snapshot.hasData) {
                          //       return ListView.builder(
                          //           padding: EdgeInsets.zero,
                          //           itemCount: snapshot.data!.docs.length,
                          //           itemBuilder: (context, index) {
                          //             return Container();
                          //           });
                          //     } else {
                          //       return Container();
                          //     }
                          //   },
                          // ),
                          PaginateFirestore(
                        //item builder type is compulsory.
                        itemBuilder: (context, documentSnapshots, index) {
                          final data = documentSnapshots[index].data() as Map?;
                          if (data != null) {
                            return VerificationItem(user: data["user_id"]);
                          } else {
                            return Container();
                          }
                        },
                        // orderBy is compulsory to enable pagination
                        query: FirebaseFirestore.instance
                            .collection('verifications')
                            .orderBy("timestamp"),
                        //Change types accordingly
                        itemBuilderType: PaginateBuilderType.listView,
                        // to fetch real-time data
                        isLive: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
