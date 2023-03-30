import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:snapstory/constants/routes.dart';

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
                if (defaultTargetPlatform == TargetPlatform.iOS ||
                    defaultTargetPlatform == TargetPlatform.android) {
                  Navigator.of(context).pushNamed(androidRoute);
                }
              },
              child: Container(

                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.35,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height * 0.03),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45),
                    color: const Color(0xffffdb1f),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/main/btn-main-ai.png'), // 배경 이미지
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
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45),
                    color: const Color(0xff86EC62),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/main/btn-main-quiz.png'), // 배경 이미지
                    ),
                  ),
                  child: const Center(child: Text(""))),
            ),
          ],
        )));
  }
}
