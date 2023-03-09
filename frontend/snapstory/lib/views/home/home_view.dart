import 'package:flutter/material.dart';
import 'package:snapstory/views/home/find_word_view.dart';
import 'package:snapstory/views/home/fairytale_quiz_view.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const FindWord()),
                );
              },
              child: Container(
                  width: 277,
                  height: 253,
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 70),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(23),
                    color: const Color(0xffffdb1f),
                  ),
                  child: const Center(child: Text("주변 영단어 찾기"))),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const FairyTaleQuiz()),
                );
              },
              child: Container(
                  width: 277,
                  height: 253,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(23),
                    color: const Color(0xff86EC62),
                  ),
                  child: const Center(child: Text("동화 퀴즈"))),
            ),
            
            
          ],
        )));
  }
}
