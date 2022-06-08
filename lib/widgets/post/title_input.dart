import 'package:buk/providers/language/language_enum.dart';
import 'package:buk/providers/language/language_provider.dart';
import 'package:buk/providers/post/post_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostTitleForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const PostTitleForm({Key? key, required this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextFormField(
        enableSuggestions: false,
        // key: formKey,
        validator: (value) {
          if (value == null ||
              value.isEmpty ||
              value.runtimeType != String ||
              value.length < 3 ||
              value.length > 25) {
            return Provider.of<Language>(context, listen: false).language ==
                    LanguageType.en
                ? "Title must be between 3-25 characters"
                : "Назва має містити від 3 до 25 символів";
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          hintText: Provider.of<Language>(context, listen: false).language ==
                  LanguageType.en
              ? "Title"
              : "Назва",
        ),
        onChanged: (val) {
          formKey.currentState!.validate();
          Provider.of<PostFormProvider>(context, listen: false).setTitle(val);
        },
      ),
    );
  }
}
