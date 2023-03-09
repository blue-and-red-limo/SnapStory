import 'package:flutter/material.dart';

class FindWord extends StatefulWidget {
  const FindWord({Key? key}) : super(key: key);

  @override
  State<FindWord> createState() => _FindWordState();
}

class _FindWordState extends State<FindWord> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("카메라 화면등장!")
      ),
    );
  }
}
