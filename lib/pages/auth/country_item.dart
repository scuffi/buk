import 'package:buk/pages/auth/country.dart';
import 'package:flutter/material.dart';

class CountryItem extends StatelessWidget {
  CountryItem(this.country, {Key? key}) : super(key: key);

  Country country;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(country.emoji),
        Text("${country.name} (+${country.dial_code})"),
      ],
    );
  }
}
