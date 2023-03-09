import 'package:flutter/material.dart';

class MyWord extends StatefulWidget {
  const MyWord({Key? key}) : super(key: key);

  @override
  State<MyWord> createState() => _MyWordState();
}

class _MyWordState extends State<MyWord> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("word"),
      ),
    );
  }
}
