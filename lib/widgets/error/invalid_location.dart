import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class InvalidLocation extends StatelessWidget {
  const InvalidLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SvgPicture.asset("assets/503.svg", semanticsLabel: '503 error'),
          Text(
            "We're sorry...",
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(fontSize: 48),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Text(
              "We don't currently operate in your area. This could be because you've disabled location services for this app, if that could be the case click the button below to be directed to your settings. If you think this is an error, please contact help@edwin-studios.com",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.green.shade100),
                ),
                onPressed: () async => await Geolocator.openLocationSettings(),
                child: const Text(
                  "Location Settings",
                  style: TextStyle(color: Colors.black87),
                )),
          ),
          const Spacer(),
          Text(
            "Image by 'storyset' from storyset.com",
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
