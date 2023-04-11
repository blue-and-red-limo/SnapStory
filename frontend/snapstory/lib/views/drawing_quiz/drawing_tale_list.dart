import 'package:snapstory/constants/routes.dart';
import 'package:snapstory/views/drawing_quiz/drawing.dart';
import 'package:flutter/material.dart';
import 'package:snapstory/views/main_view.dart';

class DrawingTaleList extends StatefulWidget {
  const DrawingTaleList({Key? key}) : super(key: key);

  @override
  State<DrawingTaleList> createState() => DrawingTaleListState();
}

class DrawingTaleListState extends State<DrawingTaleList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/main/bg-main2_2.png'),
              ),
            ),
            child: ListView(
              padding: EdgeInsets.only(
                  top: 0, bottom: MediaQuery.of(context).size.height * 0.15),
              children: [
                // 신데렐라
                IconButton(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                  iconSize: MediaQuery.of(context).size.height * 0.2,
                  icon: Image.asset(
                      "assets/quizTaleList/btn-quiz-cinderella.png"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DrawingView(1)));
                  },
                ),
                // 백설공주
                IconButton(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                  iconSize: MediaQuery.of(context).size.height * 0.2,
                  icon:
                      Image.asset("assets/quizTaleList/btn-quiz-snowwhite.png"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DrawingView(2)));
                  },
                ),
                // 잠자는 숲속의 공주
                IconButton(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                  iconSize: MediaQuery.of(context).size.height * 0.2,
                  icon: Image.asset(
                      "assets/quizTaleList/btn-quiz-sleepingbeauty.png"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DrawingView(3)));
                  },
                ),
                // 라푼젤
                IconButton(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                  iconSize: MediaQuery.of(context).size.height * 0.2,
                  icon:
                      Image.asset("assets/quizTaleList/btn-quiz-rapunzel.png"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DrawingView(4)));
                  },
                ),
                // 미녀와 야수
                IconButton(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                  iconSize: MediaQuery.of(context).size.height * 0.2,
                  icon: Image.asset(
                      "assets/quizTaleList/btn-quiz-beautyandbeast.png"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DrawingView(5)));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      // 하단바
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.15,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.08,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32)),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/main/bg-bar.png'),
                ),
              ),
            ),
            Positioned(
              width: MediaQuery.of(context).size.width,
              bottom: MediaQuery.of(context).size.height * 0.03,
              child: GestureDetector(
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.22,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  // 나가기
                  child: Icon(
                    Icons.exit_to_app_rounded,
                    color: Color(0xffffb628),
                    size: MediaQuery.of(context).size.width * 0.15,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const MainView(selectedPage: 0)),
                    (route) => false,
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
