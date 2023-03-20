import 'package:flutter/material.dart';

class MyLibrary extends StatefulWidget {
  const MyLibrary({Key? key}) : super(key: key);

  @override
  State<MyLibrary> createState() => _MyLibraryState();
}

class _MyLibraryState extends State<MyLibrary> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("library"),
      ),
    );
  }
}
