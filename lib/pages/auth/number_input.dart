import 'package:buk/pages/auth/country.dart';
import 'package:buk/pages/auth/country_codes.dart';
import 'package:buk/providers/language/language_enum.dart';
import 'package:buk/providers/language/language_provider.dart';
import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class NumberInput extends StatefulWidget {
  NumberInput({Key? key, required this.onChanged, required this.form})
      : super(key: key);

  Function(String?, Country) onChanged;
  GlobalKey<FormState> form;

  @override
  State<NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  List<Country> staticItems = [];
  List<Country> listItems = [];
  Country selected = Country(
      name: "United Kingdom",
      dial_code: (countries["United Kingdom"]!["dial_code"] as int).toString(),
      country_code: countries["United Kingdom"]!["country_code"].toString(),
      emoji: Emoji.byShortName(
              "flag_${countries["United Kingdom"]!['country_code'].toString().toLowerCase()}")!
          .char);

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
      staticItems.add(country);

      // ? Set default
      if (value["country_code"] == "united_kingdom") {
        selected = country;
      }
      //   listItems.add(DropdownMenuItem(
      //     child: CountryItem(country),
      //     value: country,
      //   ));
      //   // }
    });
    listItems.addAll(staticItems);
  }

  // @override
  // Widget build(BuildContext context) {
  //   countries.forEach((key, value) {
  //     if (Emoji.byShortName(
  //             "flag_${value['country_code'].toString().toLowerCase()}") !=
  //         null) {
  //       countries[key]!["emoji"] = Emoji.byShortName(
  //               "flag_${value['country_code'].toString().toLowerCase()}")!
  //           .char;
  //     }
  //   });
  //   return SearchChoices.single(
  //     items: listItems,
  //     value: selected,
  //     hint: "Select your country",
  //     searchHint: "Select your country",
  //     onChanged: (value) {
  //       setState(() {
  //         selected = value;
  //       });
  //     },
  //     dialogBox: true,
  //     isExpanded: true,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // return InkWell(
    //   child: Container(
    //     decoration: BoxDecoration(
    //       borderRadius: const BorderRadius.only(
    //         topLeft: Radius.circular(16),
    //         bottomLeft: Radius.circular(16),
    //       ),
    //       border: Border.all(color: Colors.black45, width: 1),
    //     ),
    //     child: Row(
    //       children: [
    //         const Padding(
    //           padding: EdgeInsets.only(left: 8.0),
    //           child: Icon(Icons.keyboard_arrow_down_outlined),
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.only(right: 8.0),
    //           child: Text(selected.emoji),
    //         ),
    //         // Padding(
    //         //   padding: const EdgeInsets.only(right: 8.0),
    //         //   child: Text("+" + selected.dial_code),
    //         // ),
    //         Expanded(
    //             child: TextFormField(
    //           decoration: InputDecoration(
    //             hintText: "Phone number",
    //             prefix: getDropdown(),
    //           ),
    //           inputFormatters: [
    //             FilteringTextInputFormatter.digitsOnly,
    //           ],
    //           keyboardType: TextInputType.number,
    //         )),
    //       ],
    //     ),
    //   ),
    //   onTap: () {
    //     listItems = [...staticItems];
    //     openDialog(context);
    //   },
    // );
    return Form(
      key: widget.form,
      child: TextFormField(
        validator: ((value) {
          if (value == null || value.isEmpty) {
            return "Please enter your phone number above";
          } else if (value.length < (12 - selected.dial_code.length)) {
            return "Phone number is not long enough";
          }
          return null;
        }),
        autofocus: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          hintText: Provider.of<Language>(context, listen: true).language ==
                  LanguageType.en
              ? "Phone number"
              : "Телефонний номер",
          prefix: SizedBox(width: 96, child: getDropdown()),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.indigoAccent)),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.black45)),
          errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.redAccent)),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        maxLength: (12 - selected.dial_code.length),
        keyboardType: TextInputType.number,
        onChanged: (str) {
          widget.onChanged.call(str, selected);
        },
      ),
    );
  }

  Widget getDropdown() {
    return InkWell(
      child: Row(
        children: [
          const Icon(Icons.keyboard_arrow_down_outlined),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              selected.emoji,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Text("+" + selected.dial_code),
          ),
          // Expanded(
          //     child: TextFormField(
          //   decoration: InputDecoration(
          //     hintText: "Phone number",
          //     prefix: Text("+" + selected.dial_code),
          //   ),
          //   inputFormatters: [
          //     FilteringTextInputFormatter.digitsOnly,
          //   ],
          //   keyboardType: TextInputType.number,
          // )),
        ],
      ),
      onTap: () {
        listItems = [...staticItems];
        openDialog(context);
      },
    );
  }

  void openDialog(BuildContext context) {
    showBarModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, miniState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      Expanded(child: TextFormField(
                        onChanged: (value) {
                          miniState(() {
                            listItems = sort(value);
                          });
                        },
                      ))
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: listItems.length,
                      itemBuilder: ((context, index) {
                        var country = listItems.elementAt(index);
                        return InkWell(
                          onTap: (() {
                            Navigator.pop(context);
                            setState(
                              () => selected = country,
                            );
                          }),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(country.emoji),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: SizedBox(
                                    width: 200,
                                    child: Text(
                                      country.name,
                                      style: GoogleFonts.poppins(
                                        textStyle:
                                            const TextStyle(fontSize: 16),
                                      ),
                                      overflow: TextOverflow.fade,
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    "(+" + country.dial_code + ")",
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          fontSize: 12, color: Colors.black87),
                                    ),
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })),
                )
              ],
            ),
          );
        });
  }

  List<Country> sort(String query) {
    return staticItems
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()) ||
            element.dial_code.contains(query) ||
            element.country_code.toLowerCase().contains(query))
        .toList();
  }
}
