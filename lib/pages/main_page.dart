import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:buk/pages/post_page.dart';
import 'package:buk/providers/screen/screen_provider.dart';
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
    Container(),
    const SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   elevation: 0,
      //   title: Row(
      //     children: [
      //       TextButton(
      //         child: const Icon(
      //           Icons.logout,
      //           color: Colors.white,
      //         ),
      //         onPressed: () {
      //           FirebaseAuth.instance.signOut();
      //           Provider.of<InitialProvider>(context, listen: false)
      //               .setPassed(false);
      //           Provider.of<UserProvider>(context, listen: false).clearUser();
      //         },
      //       ),
      //       const Spacer(),
      //       const LanguageSwitch(),
      //     ],
      //   ),
      //   // shape: const RoundedRectangleBorder(
      //   //     borderRadius: BorderRadius.vertical(bottom: Radius.circular(32))),
      //   bottom: TabBar(
      //     controller: controller,
      //     labelColor: Colors.blue,
      //     unselectedLabelColor: Colors.white,
      //     indicatorSize: TabBarIndicatorSize.label,
      //     indicator: const BoxDecoration(
      //         borderRadius: BorderRadius.only(
      //             topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      //         color: Colors.white),
      //     tabs: const [
      //       Tab(
      //         child: Align(
      //           alignment: Alignment.center,
      //           child: TranslateText(
      //             text: "Requesting",
      //             selectable: false,
      //           ),
      //         ),
      //       ),
      //       Tab(
      //         child: Align(
      //           alignment: Alignment.center,
      //           child: TranslateText(
      //             text: "Offering",
      //             selectable: false,
      //           ),
      //         ),
      //       ),
      //       Tab(
      //         child: Align(
      //           alignment: Alignment.center,
      //           child: TranslateText(
      //             text: "Liked",
      //             selectable: false,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      // body: TabBarView(
      //   controller: controller,
      //   children: [
      //     LiquidPullToRefresh(
      //       springAnimationDurationInMilliseconds: 200,
      //       showChildOpacityTransition: false,
      //       onRefresh: () {
      //         return Future.delayed(const Duration(seconds: 0), () {
      //           updateFeeds(context);
      //         });
      //       },
      //       child: const RequestFeed(),
      //     ),
      //     LiquidPullToRefresh(
      //       springAnimationDurationInMilliseconds: 200,
      //       showChildOpacityTransition: false,
      //       onRefresh: () {
      //         return Future.delayed(const Duration(seconds: 0), () {
      //           updateFeeds(context);
      //         });
      //       },
      //       child: const OfferFeed(),
      //     ),
      //     const LikedFeed(),
      //   ],
      // ),
      body: Provider.of<Screen>(context).screen,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
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
        splashColor: Colors.blue,
        activeColor: Colors.blue,
        icons: const [
          Icons.home,
          Icons.search,
          Icons.add_circle_outline,
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
