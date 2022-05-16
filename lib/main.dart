import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:buk/providers/feed_loader.dart';
import 'package:buk/providers/feed_provider.dart';
import 'package:buk/widgets/feed/feed_item.dart';
import 'package:buk/widgets/feed_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FeedData()),
        ChangeNotifierProvider(create: (context) => FeedLoader()),
      ],
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
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 10),
      () => {
        Provider.of<FeedLoader>(context, listen: false).setLoaded(true),
      },
    );
    Future.delayed(
      const Duration(seconds: 6),
      () => {
        // ! Add the information to add to the FeedData, then make the ListView below actually pull from FeedData
        Provider.of<FeedData>(context, listen: false).addItem(
          {
            "title": "Amazing title",
            "description": "lorem ipsum description",
            "username": "Archie Ferguson"
          },
        ),
        Provider.of<FeedData>(context, listen: false).addItem(
          {
            "title": "Super cool title",
            "description": "lorem ipsum description",
            "username": "Archie Ferguson"
          },
        ),

        Provider.of<FeedData>(context, listen: false).addItem(
          {
            "title": "Basic title",
            "description": "lorem ipsum description",
            "username": "Archie Ferguson"
          },
        ),
      },
    );

    var _bottomNavIndex = 0;

    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(),
      body: Container(
        child: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 1), () {
              print("Refreshed");
            });
          },
          child: Consumer<FeedLoader>(
            builder: (i, loader, o) => loader.loaded
                ? Consumer<FeedData>(
                    builder: (_, data, __) => data.items.isNotEmpty
                        ? ListView.builder(
                            itemCount: data.items.length,
                            itemBuilder: (___, index) {
                              return FeedItem(info: data.items[index]);
                            },
                          )
                        : const Text("There's nothing here!"),
                  )
                : const FeedLoading(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('Floating action button pressed');
          },
          child: const Icon(Icons.add)

          //params
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
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
        onTap: (index) => setState(() => _bottomNavIndex = index),
        //other params
      ),
    ));
  }
}
