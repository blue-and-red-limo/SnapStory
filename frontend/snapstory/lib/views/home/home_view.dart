import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:snapstory/constants/routes.dart';
import 'package:snapstory/views/home/fairytale_quiz_view.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (defaultTargetPlatform == TargetPlatform.iOS) {
                  Navigator.of(context).pushNamed(iOSRoute);
                } else if (defaultTargetPlatform == TargetPlatform.android) {
                  Navigator.of(context).pushNamed(androidRoute);
                }
              },
              child: Container(

                  width: 277,
                  height: 253,
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 70),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(23),
                    color: const Color(0xffffdb1f),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/find_word_btn.png'), // 배경 이미지
                    ),
                  ),
                  child: const Center(child: Text(""))
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(drawingTaleListRoute);
              },
              child: Container(
                  width: 277,
                  height: 253,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(23),
                    color: const Color(0xff86EC62),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/draw_quiz_btn.png'), // 배경 이미지
                    ),
                  ),
                  child: const Center(child: Text(""))),
            ),
          ],
        )));
  }
}
