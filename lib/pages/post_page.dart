import 'package:buk/api/feed_api.dart';
import 'package:buk/providers/language/language_enum.dart';
import 'package:buk/providers/language/language_provider.dart';
import 'package:buk/providers/post/post_form_provider.dart';
import 'package:buk/providers/user_provider.dart';
import 'package:buk/widgets/post/category_selector_input.dart';
import 'package:buk/widgets/post/description_input.dart';
import 'package:buk/widgets/post/image_upload.dart';
import 'package:buk/widgets/post/title_input.dart';
import 'package:buk/widgets/post/type_selector.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     // Navigator.of(context).push(
        //     //   MaterialPageRoute(builder: (context) => const FeedPage()),
        //     // );
        //     Provider.of<PickerProvider>(context, listen: false).clearImages();
        //   },
        // ),
        body: Stack(children: [
          Container(
            color: Colors.white,
          ),
          GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 70.0),
                    child: Container(
                      height: height * 0.1,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                spreadRadius: 8,
                                blurRadius: 6,
                                offset: const Offset(0, 4)),
                          ]),
                      child: const TypeSelector(),
                    ),
                  ),
                ), // Type selector
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Container(
                      constraints: BoxConstraints.expand(
                        height: height * 0.43,
                        width: width * 0.8,
                      ),
                      // height: height * 0.4,
                      // width: width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                spreadRadius: 8,
                                blurRadius: 6,
                                offset: const Offset(0, 4)),
                          ]),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // const TypeSelector(),
                            PostTitleForm(formKey: _formKey),
                            SizedBox(
                                height: height * 0.3,
                                child: PostDescriptionForm(formKey: _formKey)),
                            const Spacer(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: TranslateText(
                                text: Provider.of<Language>(context,
                                                listen: false)
                                            .language ==
                                        LanguageType.en
                                    ? "Tip: Try to use longer, more descriptive words"
                                    : "Порада: намагайтеся використовувати довгі, більш описові слова",
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 12),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ), // Text inputs
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Container(
                      height: height * 0.05,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                spreadRadius: 8,
                                blurRadius: 6,
                                offset: const Offset(0, 4)),
                          ]),
                      child: const PostCategoryForm(),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Container(
                      height: height * 0.15 + 32,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                spreadRadius: 8,
                                blurRadius: 6,
                                offset: const Offset(0, 4)),
                          ]),
                      child: Wrap(children: const [ImagePost()]),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            resetProviders(context);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(color: Colors.grey[800]),
                            ),
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              var user = Provider.of<UserProvider>(context,
                                  listen: false);
                              var item = Provider.of<PostFormProvider>(context,
                                  listen: false);
                              var id = const Uuid().v4();

                              List<String> images = [];
                              if (item.images.isNotEmpty) {
                                images = await uploadImages(item.images, id);
                              }

                              print(user);
                              String userId = user.user!.uid;
                              String userName = user.user!.displayName!;

                              // ! Add phone number to this once added
                              Map userContact = {"email": user.user!.email};

                              String title = item.title!;
                              String description = item.description!;
                              String itemType = item.type;
                              String category = item.category;

                              await uploadItem(
                                  userId,
                                  userName,
                                  userContact,
                                  title,
                                  description,
                                  images,
                                  itemType,
                                  category);
                              print("Uploaded new item");

                              resetProviders(context);

                              Future.delayed(const Duration(seconds: 0), () {
                                updateFeeds(context);
                              });

                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            "Post",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(color: Colors.white),
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue)),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ]));
  }
}

void resetProviders(BuildContext context) {
  context.read<PostFormProvider>().reset();
}
