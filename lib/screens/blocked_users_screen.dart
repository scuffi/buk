import 'package:buk/providers/user_provider.dart';
import 'package:buk/widgets/feed/interface/blocked_type.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

class BlockedUsersScreen extends StatelessWidget {
  const BlockedUsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false);
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
                  text: "Blocked Users",
                  ukrainian: "Заблоковані користувачі",
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
                          // print(data);
                          if (data == null) {
                            return Center(
                                child: TranslateText(
                              text: "No blocked users found",
                              ukrainian:
                                  "Заблокованих користувачів не знайдено",
                              style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(fontSize: 20)),
                            ));
                          }
                          if (!data.containsKey("blocks") ||
                              data["blocks"].isEmpty) {
                            return Center(
                                child: TranslateText(
                              text: "No blocked users found",
                              ukrainian:
                                  "Заблокованих користувачів не знайдено",
                              style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(fontSize: 20)),
                            ));
                          }

                          var blocks = data["blocks"];

                          return SizedBox(
                            height: 500,
                            child: ListView.builder(
                                padding: const EdgeInsets.all(20.0),
                                itemCount: blocks.length,
                                itemBuilder: ((context, index) {
                                  var item = BlockItem(
                                      id: blocks[index]["id"],
                                      name: blocks[index]["name"]);

                                  return UserItem(item: item);
                                })),
                          );
                        },
                        // orderBy is compulsory to enable pagination
                        query: FirebaseFirestore.instance
                            .collection('users')
                            .where("user_id", isEqualTo: user.user!.uid),
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

class UserItem extends StatelessWidget {
  UserItem({required this.item, Key? key}) : super(key: key);

  BlockItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SizedBox(
                  width: 200,
                  child: Text(
                    item.name,
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            color: Colors.black87, fontSize: 18)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const Spacer(),
              OutlinedButton(
                  onPressed: () async {
                    await Provider.of<UserProvider>(context, listen: false)
                        .removeBlock(item);
                  },
                  child: TranslateText(
                    text: "Unblock",
                    ukrainian: "Розблокувати",
                    style: GoogleFonts.lato(
                        textStyle:
                            TextStyle(color: Colors.red[700], fontSize: 14)),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
