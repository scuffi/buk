import 'package:buk/pages/auth/country.dart';
import 'package:buk/pages/auth/country_codes.dart';
import 'package:buk/pages/auth/country_item.dart';
import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:search_choices/search_choices.dart';

class NumberInput extends StatefulWidget {
  const NumberInput({Key? key}) : super(key: key);

  @override
  State<NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  String selectedCountry = "united_kingdom";
  List<DropdownMenuItem<Country>> listItems = [];
  Country? selected;

  @override
  void initState() {
    super.initState();

    countries.forEach((key, value) {
      // if (Emoji.byShortName(
      //         "flag_${value['country_code'].toString().toLowerCase()}") !=
      //     null) {

      var country = Country(
          name: key,
          dial_code: (value["dial_code"] as int).toString(),
          country_code: value["country_code"].toString(),
          emoji: Emoji.byShortName(
                  "flag_${value['country_code'].toString().toLowerCase()}")!
              .char);
      listItems.add(DropdownMenuItem(
        child: CountryItem(country),
        value: country,
      ));
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    countries.forEach((key, value) {
      if (Emoji.byShortName(
              "flag_${value['country_code'].toString().toLowerCase()}") !=
          null) {
        countries[key]!["emoji"] = Emoji.byShortName(
                "flag_${value['country_code'].toString().toLowerCase()}")!
            .char;
      }
    });
    return SearchChoices.single(
      items: listItems,
      value: selected,
      hint: "Select your country",
      searchHint: "Select your country",
      onChanged: (value) {
        setState(() {
          selected = value;
        });
      },
      dialogBox: true,
      isExpanded: true,
    );
  }
}
