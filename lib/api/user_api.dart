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
