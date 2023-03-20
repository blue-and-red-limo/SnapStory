import 'package:flutter/material.dart';

class FairyTaleQuiz extends StatefulWidget {
  const FairyTaleQuiz({Key? key}) : super(key: key);

  @override
  State<FairyTaleQuiz> createState() => _FairyTaleQuizState();
}

class _FairyTaleQuizState extends State<FairyTaleQuiz> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text("퀴즈 화면 등장!")
      ),
    );
  }
}

