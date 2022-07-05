import 'package:buk/pages/auth_gate.dart';
import 'package:buk/pages/fullscreen_loading.dart';
import 'package:buk/providers/donations/donations_provider.dart';
import 'package:buk/providers/feed/feed_loader.dart';
import 'package:buk/providers/feed/feed_provider.dart';
import 'package:buk/providers/initial/initial_provider.dart';
import 'package:buk/providers/language/language_enum.dart';
import 'package:buk/providers/language/language_provider.dart';
import 'package:buk/providers/post/post_form_provider.dart';
import 'package:buk/providers/screen/screen_provider.dart';
import 'package:buk/providers/settings_provider.dart';
import 'package:buk/providers/user_provider.dart';
import 'package:buk/widgets/error/invalid_location.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        // ? Screen handler provider
        ChangeNotifierProvider(create: (_) => Screen()),
        // ? Initial input provider
        ChangeNotifierProvider(create: (_) => InitialProvider()),
        // ? User storage provider
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // ? Feed page providers
        ChangeNotifierProvider(create: (context) => FeedData()),
        ChangeNotifierProvider(create: (context) => FeedLoader()),
        // ? Language selection provider
        ChangeNotifierProvider(create: (context) => Language()),
        // ? Post page providers
        ChangeNotifierProvider(create: (context) => PostFormProvider()),
        // ? Settings provider
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        // ? Donations provider
        ChangeNotifierProvider(create: (_) => DonationsProvider()),
      ],
      // child: DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) => const MyApp(), // Wrap your app
      // ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool geofenced = false;
  Position? lastPosition;

  @override
  void initState() {
    super.initState();

    // Check the currently stored language type and set our language to that type so it doesn't default to something after each run
    Future(
      () async {
        final prefs = await SharedPreferences.getInstance();

        String? lang = prefs.getString("language");
        if (lang != null) {
          Provider.of<Language>(context, listen: false).setLang(LanguageType
              .values
              .firstWhere((element) => element.name == lang));
        }
      },
    );

    // ? Listen for gps location updates -> not 100% necessary but oh well
    // Geolocator.getPositionStream().listen((Position? position) {
    //   if (position == null) {
    //     setState(() {
    //       geofenced = false;
    //     });
    //   } else {
    //     var distance = Geolocator.distanceBetween(config.middleLatitude,
    //         config.middleLongitude, position.latitude, position.longitude);
    //     if (distance.ceil() <= config.radius) {
    //       if (!geofenced) {
    //         setState(() {
    //           geofenced = true;
    //           lastPosition = position;
    //         });
    //       }
    //     } else {
    //       if (geofenced) {
    //         setState(() {
    //           geofenced = false;
    //           lastPosition = position;
    //         });
    //       }
    //     }
    //   }
    // });

    // print("User is signed in? : ${FirebaseAuth.instance.currentUser != null}");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      theme: ThemeData(
        primaryColor: Colors.indigoAccent,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.indigoAccent,
        scaffoldBackgroundColor: Colors.black45,
      ),
      // home: const FeedPage(),
      home: const AuthGate(),
    );
  }

  Future<Position> _determineLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Widget getLocationPages() {
    if (lastPosition == null) {
      return const FullScreenLoader();
    } else if (!geofenced) {
      return const InvalidLocation();
    } else {
      return const AuthGate();
    }
  }
}
