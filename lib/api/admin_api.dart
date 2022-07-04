import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buk/config.dart' as config;
import 'package:cloud_functions/cloud_functions.dart';

final db = FirebaseFirestore.instance;
final functions = FirebaseFunctions.instance;

Future<void> pruneUser(String userId) async {
  var docs = await db
      .collection(config.feedCollectionName)
      .where("owner_id", isEqualTo: userId)
      .get();

  for (var element in docs.docs) {
    await db.collection(config.feedCollectionName).doc(element.id).delete();
  }
}

Future<void> deleteUserPost(String itemId) async {
  await db.collection(config.feedCollectionName).doc(itemId).delete();
}

Future<void> deleteUser(String userId) async {
  try {
    // print("Deleting $userId");
    await functions.httpsCallable('deleteUser').call(userId);
  } on FirebaseFunctionsException {
    // print(e.message);
  }
}

Future<Map> getUser(String user) async {
  try {
    var verified = await functions.httpsCallable('getUser').call(user);
    return verified.data;
  } on FirebaseFunctionsException {
    // print(e.message);
    return {};
  }
}

Future<void> verifyUser(String userId) async {
  try {
    // print("Verifying $userId");
    await functions.httpsCallable('verifyUser').call(userId);
  } on FirebaseFunctionsException {
    // print(e.message);
  }
}
