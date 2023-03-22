import 'package:snapstory/constants/routes.dart';
import 'package:snapstory/views/drawing_quiz/drawing.dart';
import 'package:flutter/material.dart';

class DrawingTaleList extends StatefulWidget {
  const DrawingTaleList({Key? key}) : super(key: key);

  @override
  State<DrawingTaleList> createState() => DrawingTaleListState();
}

class DrawingTaleListState extends State<DrawingTaleList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ListView(
        children: [
          // 나가기
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(mainRoute);
              },
              icon: Icon(
                Icons.cancel_rounded,
                color: Color(0xffffb628),
                size: 30,
              ),
              label: Text(
                '나가기',
                style: TextStyle(color: Color(0xffffb628), fontSize: 20),
              ),
            ),
            SizedBox(
              width: 20,
            )
          ]),
          IconButton(
            padding: EdgeInsets.zero,
            iconSize: 220,
            icon: Image.asset("assets/quizTaleList/0.jpg"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DrawingView(1)));
            },
          ),
          IconButton(
            padding: EdgeInsets.zero,
            iconSize: 220,
            icon: Image.asset("assets/quizTaleList/1.jpg"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DrawingView(2)));
            },
          ),
          IconButton(
            padding: EdgeInsets.zero,
            iconSize: 220,
            icon: Image.asset("assets/quizTaleList/2.jpg"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DrawingView(3)));
            },
          ),
          IconButton(
            padding: EdgeInsets.zero,
            iconSize: 220,
            icon: Image.asset("assets/quizTaleList/3.jpg"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DrawingView(4)));
            },
          ),
          IconButton(
            padding: EdgeInsets.zero,
            iconSize: 220,
            icon: Image.asset("assets/quizTaleList/4.jpg"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DrawingView(5)));
            },
          ),
        ],
      ),
    ));
  }
}
