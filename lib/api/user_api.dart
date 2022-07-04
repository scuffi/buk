import 'package:buk/api/feed_api.dart';
import 'package:buk/widgets/feed/interface/category_type.dart';
import 'package:buk/widgets/feed/interface/item_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
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
    // print(e);
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

  // print("Adding like to ${user.uid}");

  try {
    await userDoc.set(data);
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> removeUserLikeById(User user, String itemId) async {
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
  likes.remove(itemId);

  data["likes"] = likes;

  // print("Removing like from ${user.uid}");

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

  // print("Removing like from ${user.uid}");

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

Future<List<ItemData>?> getUserLikes(User user) async {
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

  // ? Fetch all the liked items
  var db = FirebaseFirestore.instance;

  List<ItemData> likeItems = List.empty(growable: true);

  var likes = List.from(data["likes"]);

  for (var element in likes) {
    var doc = await db.collection(config.feedCollectionName).doc(element).get();

    // Only add if the document actually exists
    if (doc.exists) {
      likeItems.add(ItemData(
        id: doc.id,
        title: doc.get("title"),
        description: doc.get("description"),
        images: doc.get("images"),
        image_location: doc.get("image_location"),
        category: ItemCategory.values.asNameMap()[doc.get("category")]!,
        owner_name: doc.get("owner_name"),
        owner_id: doc.get("owner_id"),
        owner_contact: doc.get("owner_contact"),
        item_type: doc.get("item_type"),
        timestamp: doc.get("timestamp"),
      ));
    } else {
      // ! Delete the element from the db
      removeUserLikeById(user, element);
    }
  }

  return likeItems;
}

Future<bool> deleteEverything(User user) async {
  try {
    var db = FirebaseFirestore.instance;

    var userDoc = await getUserDocument(user);
    if (userDoc != null) {
      await userDoc.delete();
    }

    // print("deleted user doc");

    var items = await getAllUserItems(user);
    // print("All users items: $items");

    for (var element in items.docs) {
      await deleteItem(element.id, element.data()["image_location"]);
    }

    // print("deleted items");

    return true;
  } catch (e) {
    // print(e);
    return false;
  }
}

Future<QuerySnapshot<Map<String, dynamic>>> getAllUserItems(User user) async {
  var db = FirebaseFirestore.instance;
  // print(
  // "Fetching items with userId ${await db.collection(config.feedCollectionName).where("owner_id", isEqualTo: user.uid).get()}");
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

final functions = FirebaseFunctions.instance;

Future<bool> isVerified(User user) async {
  try {
    var verified = await functions.httpsCallable('isVerified').call();
    return verified.data.toString() == "true" ? true : false;
  } on FirebaseFunctionsException {
    // print(e.message);
    return false;
  }
}

Future<bool> isAdmin(User user) async {
  try {
    var verified = await functions.httpsCallable('isAdmin').call();
    return verified.data;
  } on FirebaseFunctionsException {
    // print(e.message);
    return false;
  }
}
