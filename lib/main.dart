import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:buk/providers/feed_loader.dart';
import 'package:buk/providers/feed_provider.dart';
import 'package:buk/widgets/feed/feed_empty.dart';
import 'package:buk/widgets/feed/feed_item.dart';
import 'package:buk/widgets/feed/interface/category_type.dart';
import 'package:buk/widgets/feed/interface/item_data.dart';
import 'package:buk/widgets/feed_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

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
      const Duration(seconds: 3),
      () => {
        Provider.of<FeedLoader>(context, listen: false).setLoaded(true),
      },
    );
    Future.delayed(
      const Duration(seconds: 6),
      () => {
        Provider.of<FeedData>(context, listen: false).addItem(
          ItemData(
              title: "Awesome title",
              description: "lorem ipsum description",
              images: imgList,
              category: ItemCategory.clothes,
              owner: "Archie Ferguson"),
        ),
        Provider.of<FeedData>(context, listen: false).addItem(
          ItemData(
              title: "Super cool title",
              description: "lorem ipsum description",
              images: [],
              category: ItemCategory.clothes,
              owner: "Archie Ferguson"),
        ),
        Provider.of<FeedData>(context, listen: false).addItem(
          ItemData(
              title: "Basic title",
              description: "lorem ipsum description",
              images: [],
              category: ItemCategory.clothes,
              owner: "Archie Ferguson"),
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
            builder: (_, loader, __) => loader.loaded
                ? Consumer<FeedData>(
                    builder: (_, data, __) => data.items.isNotEmpty
                        ? ListView.builder(
                            itemCount: data.items.length,
                            itemBuilder: (_, index) {
                              return FeedItem(info: data.items[index]);
                            },
                          )
                        : const FeedEmpty(),
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
