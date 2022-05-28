import 'dart:io';

import 'package:buk/providers/post/image_picker_provider.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ImagePost extends StatelessWidget {
  const ImagePost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImagePicker picker = ImagePicker();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    int maxPhotos = 6;

    return SizedBox(
      height: height * 0.15 + 32,
      width: width * 0.8,
      child: Consumer<PickerProvider>(
        builder: (_, images, __) => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: images.images.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              if (images.images.length == 6) {
                return Container();
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: (() async {
                    await showBarModalBottomSheet(
                        context: context,
                        builder: (context) => SizedBox(
                              height: 101,
                              child: Column(
                                children: [
                                  TextButton(
                                    child: const TranslateText(
                                      text: "Take photo",
                                      selectable: false,
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(context);

                                      final XFile? photo =
                                          await picker.pickImage(
                                              source: ImageSource.camera);

                                      if (photo != null &&
                                          images.images.length < maxPhotos &&
                                          images.images.length + 1 <=
                                              maxPhotos) {
                                        images.addImage(photo);
                                      }
                                    },
                                  ),
                                  const Divider(
                                    thickness: 1,
                                    height: 3,
                                  ),
                                  TextButton(
                                    child: const TranslateText(
                                      text: "Choose from camera roll",
                                      selectable: false,
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(context);

                                      final List<XFile>? photos =
                                          await picker.pickMultiImage();

                                      if (photos != null &&
                                          images.images.length < maxPhotos &&
                                          photos.length +
                                                  images.images.length <=
                                              maxPhotos) {
                                        images.addImages(photos);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ));
                    // final List<XFile>? photos = await picker.pickMultiImage();

                    // if (photos != null && images.images.length < 6) {
                    //   images.addImages(photos);

                    //   print(images.images.length);
                    // }
                  }),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    dashPattern: const [20, 15],
                    strokeWidth: 3,
                    padding: EdgeInsets.zero,
                    color: Colors.blue.shade300,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: Container(
                        // color: Colors.red,
                        height: height * 0.15,
                        width: height * 0.15,
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            const Spacer(),
                            Icon(
                              Icons.add_a_photo_rounded,
                              size: height * 0.04,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: TranslateText(
                                text: "Add photo",
                                selectable: false,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: height * 0.15,
                width: height * 0.15,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: SizedBox(
                        height: height * 0.15,
                        width: height * 0.15,
                        child: Image.file(
                          File(
                            Provider.of<PickerProvider>(context, listen: false)
                                .images[index - 1]
                                .path,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: height * 0.1,
                      left: height * 0.075,
                      child: TextButton(
                        onPressed: () =>
                            Provider.of<PickerProvider>(context, listen: false)
                                .removeImage(index - 1),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 16,
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          shape: const CircleBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
