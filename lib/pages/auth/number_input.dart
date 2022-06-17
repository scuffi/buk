import 'package:flutter/material.dart';

class NumberInput extends StatefulWidget {
  const NumberInput({Key? key}) : super(key: key);

  @override
  State<NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  Map<String, String> countries = {"united_kingdom": "+44", "usa": "+1"};

  String selectedCountry = "united_kingdom";

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(prefixIcon: getCountryPicker()),
    );
  }

  Widget getCountryPicker() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade300),
    );
  }
}
