import 'package:flutter/material.dart';

class DocumentSubPage extends StatelessWidget {
  DocumentSubPage({Key? key, required this.child, required this.title})
      : super(key: key);

  Widget child;
  Widget title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Column(
        children: [
          SizedBox(
            height: 175,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: title,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.keyboard_arrow_left,
                              color: Colors.black87,
                              size: 40,
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    child,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
