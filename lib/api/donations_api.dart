import 'package:buk/widgets/feed/interface/donation_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buk/config.dart' as config;

Future<List<DonationItem>> fetchDonationItems() async {
  var db = FirebaseFirestore.instance;
  List<DonationItem> data = List.empty(growable: true);

  await db.collection(config.donationsCollectionName).get().then((event) {
    for (var doc in event.docs) {
      data.add(DonationItem(
          id: doc.id,
          title: doc.get("title"),
          description: doc.get("description"),
          link: doc.get("link"),
          publisher: doc.get("publisher")));
    }
  });

  return data;
}
