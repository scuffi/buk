import 'package:buk/api/feed_api.dart';
import 'package:buk/widgets/feed/interface/item_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:buk/config.dart' as config;

Future<bool> createUserInDb(User user) async {
  var db = FirebaseFirestore.instance;
  var col = db.collection(config.userCollectionName);

  var input = {
    "likes": [],
    "user_id": user.uid,
  };

  try {
    await col.add(input);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> userExistsInDb(User user) async {
  var db = FirebaseFirestore.instance.collection(config.userCollectionName);

  var snapshot = await db
      .where(FieldPath.fromString('user_id'), isEqualTo: user.uid)
      .limit(1)
      .get();

  return snapshot.docs.isNotEmpty;
}

Future<DocumentReference<Map<String, dynamic>>?> getUserDocument(
    User user) async {
  var db = FirebaseFirestore.instance.collection(config.userCollectionName);
  var docs = await db.where("user_id", isEqualTo: user.uid).limit(1).get();

  if (docs.docs.length != 1) {
    return null;
  }

  var doc = docs.docs[0];

  if (!doc.exists) {
    return null;
  }

  return db.doc(doc.id);
}

Future<bool> addUserLike(User user, ItemData item) async {
  var userDoc = await getUserDocument(user);
  if (userDoc == null) {
    return false;
  }

  var doc = await userDoc.get();

  Map<String, dynamic> data = doc.data()!;

  if (!data.containsKey("likes")) {
    data["likes"] = [];
  }

  var likes = List.from(data["likes"]);

  if (likes.contains(item.id)) {
    return true;
  }

  likes.add(item.id);

  data["likes"] = likes;

  print("Adding like to ${user.uid}");

  try {
    await userDoc.set(data);
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> removeUserLike(User user, ItemData item) async {
  var userDoc = await getUserDocument(user);
  if (userDoc == null) {
    return false;
  }

  var doc = await userDoc.get();

  Map<String, dynamic> data = doc.data()!;

  if (!data.containsKey("likes")) {
    data["likes"] = [];

    // If likes is empty, we can assume that nothing can be removed so it 'worked'
    return true;
  }

  var likes = List.from(data["likes"]);
  likes.remove(item.id);

  data["likes"] = likes;

  print("Removing like from ${user.uid}");

  try {
    await userDoc.set(data);
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> removeUserLikes(User user, List<ItemData> likeItems) async {
  var userDoc = await getUserDocument(user);
  if (userDoc == null) {
    return false;
  }

  var doc = await userDoc.get();

  Map<String, dynamic> data = doc.data()!;

  if (!data.containsKey("likes")) {
    data["likes"] = [];

    // If likes is empty, we can assume that nothing can be removed so it 'worked'
    return true;
  }

  var likeIds = likeItems.map((e) => e.id).toList();

  var likes = List<String>.from(data["likes"]);
  likes.removeWhere(((element) => likeIds.contains(element)));

  data["likes"] = likes;

  try {
    await userDoc.set(data);
    return true;
  } catch (e) {
    return false;
  }
}

Future<List<String>?> getUserLikes(User user) async {
  var userDoc = await getUserDocument(user);
  if (userDoc == null) {
    return null;
  }

  var doc = await userDoc.get();

  Map<String, dynamic> data = doc.data()!;

  if (!data.containsKey("likes")) {
    data["likes"] = [];

    // If likes is empty, we can assume that nothing can be removed so it 'worked'
    return null;
  }

  return List.from(data["likes"]);
}

Future<bool> deleteEverything(User user) async {
  try {
    var db = FirebaseFirestore.instance;

    var userDoc = await getUserDocument(user);
    if (userDoc != null) {
      await userDoc.delete();
    }

    print("deleted user doc");

    var items = await getAllUserItems(user);
    print("All users items: $items");

    for (var element in items.docs) {
      await deleteItem(element.id, element.data()["image_location"]);
    }

    print("deleted items");

    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<QuerySnapshot<Map<String, dynamic>>> getAllUserItems(User user) async {
  var db = FirebaseFirestore.instance;
  print(
      "Fetching items with userId ${await db.collection(config.feedCollectionName).where("owner_id", isEqualTo: user.uid).get()}");
  return await db
      .collection(config.feedCollectionName)
      .where("owner_id", isEqualTo: user.uid)
      .get();
}

Future<void> setUserDisplayName(User user, String name) async {
  var doc = await getUserDocument(user);
  if (doc != null) {
    var input = {"likes": [], "user_id": user.uid, "display_name": name};

    await doc.set(input);
  }
}

Future<bool> displayNameAvailable(String name) async {
  var db = FirebaseFirestore.instance;
  var docs = await db
      .collection(config.userCollectionName)
      .where("display_name", isEqualTo: name)
      .get();

  return docs.size == 0;
}
