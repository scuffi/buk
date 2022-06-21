import 'package:buk/providers/user_provider.dart';
import 'package:buk/widgets/feed/feed_empty.dart';
import 'package:buk/widgets/feed/feed_item.dart';
import 'package:buk/widgets/feed/interface/category_type.dart';
import 'package:buk/widgets/feed/interface/item_data.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
                  text: "My posts",
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
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 4.0),
                // Future builder to fetch posts?
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('feed')
                      .where("owner_id",
                          isEqualTo:
                              Provider.of<UserProvider>(context, listen: false)
                                  .user!
                                  .uid)
                      .orderBy("timestamp", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot doc = snapshot.data!.docs[index];
                            var item = ItemData(
                              id: doc.id,
                              title: doc.get("title"),
                              description: doc.get("description"),
                              images: doc.get("images"),
                              image_location: doc.get("image_location"),
                              category: ItemCategory.values
                                  .asNameMap()[doc.get("category")]!,
                              owner_name: doc.get("owner_name"),
                              owner_id: doc.get("owner_id"),
                              owner_contact: doc.get("owner_contact"),
                              item_type: doc.get("item_type"),
                              timestamp: doc.get("timestamp"),
                            );
                            return FeedItem(info: item);
                          });
                    } else {
                      return const FeedEmpty();
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
