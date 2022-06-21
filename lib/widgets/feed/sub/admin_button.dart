import 'package:buk/api/admin_api.dart';
import 'package:buk/widgets/feed/interface/item_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminButton extends StatelessWidget {
  const AdminButton({
    Key? key,
    required this.info,
  }) : super(key: key);

  final ItemData info;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        print("Secret button");
        showDialog(
            context: context,
            builder: (context) {
              return Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  // title: const Text("Admin View"),
                  // contentPadding: EdgeInsets.zero,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Admin View",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                    Text(
                      info.title,
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                    Text(
                      "By ${info.owner_name}",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.red.shade200),
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (con) {
                                    return AlertDialog(
                                      title: Text(
                                          "Are you sure you want to delete ${info.title}"),
                                      actions: [
                                        OutlinedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("No")),
                                        ElevatedButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (con2) {
                                                    return const CircularProgressIndicator
                                                        .adaptive();
                                                  });

                                              await deleteUserPost(info.id);
                                              // TODO: Add a toast saying deleted after this / updateFeeds?

                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Yes")),
                                      ],
                                    );
                                  });
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Delete item"),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                padding:
                                    MaterialStateProperty.all(EdgeInsets.zero),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.red.shade400),
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (con) {
                                      return AlertDialog(
                                        title: Text(
                                            "Are you sure you want to prune ${info.owner_name}"),
                                        actions: [
                                          OutlinedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("No")),
                                          ElevatedButton(
                                              onPressed: () async {
                                                Navigator.pop(context);

                                                showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (con2) {
                                                      return const CircularProgressIndicator
                                                          .adaptive();
                                                    });

                                                await pruneUser(info.owner_id);
                                                // TODO: Add a toast saying deleted after this / updateFeeds?
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Yes")),
                                        ],
                                      );
                                    });
                              },
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.delete_forever,
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Prune user"),
                                  ),
                                ],
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                padding:
                                    MaterialStateProperty.all(EdgeInsets.zero),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.red.shade900),
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (con) {
                                      return AlertDialog(
                                        title: Text(
                                            "Are you sure you want to delete user ${info.owner_name}"),
                                        actions: [
                                          OutlinedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("No")),
                                          ElevatedButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator
                                                                .adaptive(),
                                                      );
                                                    });

                                                await deleteUser(info.owner_id);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Yes")),
                                        ],
                                      );
                                    });
                              },
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.sentiment_very_dissatisfied_outlined,
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Delete user"),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    )
                  ]),
                ),
              );
            });
      },
      child: ProfilePicture(
        name: info.owner_name,
        radius: 21,
        fontsize: 15,
      ),
    );
  }
}
