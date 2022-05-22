import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/language/language_enum.dart';
import '../../providers/language/language_provider.dart';

class PostDescriptionForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const PostDescriptionForm({Key? key, required this.formKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int maxLines = (MediaQuery.of(context).size.height / 71).round();
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: maxLines,
        minLines: maxLines,
        enableSuggestions: false,
        // key: formKey,
        validator: (value) {
          if (value == null ||
              value.isEmpty ||
              value.runtimeType != String ||
              value.length < 3 ||
              value.length > 250) {
            return Provider.of<Language>(context, listen: false).language ==
                    LanguageType.en
                ? "Description must be between 3-250 characters"
                : "Опис має містити від 3 до 250 символів";
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          hintText: Provider.of<Language>(context, listen: false).language ==
                  LanguageType.en
              ? "Enter description"
              : "Введіть опис",
        ),
      ),
    );
  }
}
