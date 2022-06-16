import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:buk/pages/post_page.dart';
import 'package:buk/providers/screen/screen_provider.dart';
import 'package:buk/screens/donations_screen.dart';
import 'package:buk/screens/feed_screen.dart';
import 'package:buk/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  var _bottomNavIndex = 0;

  var screenIndex = [
    const FeedScreen(),
    Container(),
    const DonationsScreen(),
    const SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Provider.of<Screen>(context).screen,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PostPage(),
              fullscreenDialog: true,
            ),
          );
        },
        child: const Icon(
          Icons.add,
          size: 40,
        ),
        //params
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        splashColor: Theme.of(context).primaryColor,
        activeColor: Theme.of(context).primaryColor,
        icons: const [
          Icons.home,
          Icons.help_outline_rounded,
          Icons.attach_money_sharp,
          Icons.settings
        ],
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        notchSmoothness: NotchSmoothness.smoothEdge,
        onTap: (index) => setState(() {
          Provider.of<Screen>(context, listen: false)
              .setScreen(screenIndex[index], context);
          _bottomNavIndex = index;
        }),
        //other params
      ),
    );
  }
}
