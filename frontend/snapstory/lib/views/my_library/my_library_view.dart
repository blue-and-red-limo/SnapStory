import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:outlined_text/outlined_text.dart';
import 'package:snapstory/services/ar_ai_service.dart';
import 'package:snapstory/views/home/complete_story_view.dart';
import 'package:snapstory/views/my_library/quiz_tale_view.dart';

class MyLibrary extends StatefulWidget {
  const MyLibrary({Key? key}) : super(key: key);

  @override
  State<MyLibrary> createState() => _MyLibraryState();
}

class _MyLibraryState extends State<MyLibrary> {
  late final ARAIService _araiService;
  List AITaleList = [];
  List<List> AITale2 = [];
  List quizTaleList = [];
  List<List> quizTale2 = [];
  dynamic token = '';

  @override
  void initState() {
    _araiService = ARAIService();
    getQuizTale();
    super.initState();
  }

  getQuizTale() async {
    token = await FirebaseAuth.instance.currentUser?.getIdToken();
    try {
      http.Response response = await http.get(
          Uri.parse('https://j8a401.p.ssafy.io/api/v1/quiz-tales/complete'),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      Map<String, dynamic> jsonResponse =
          jsonDecode(utf8.decode(response.bodyBytes));
      AITaleList = await _araiService.getAITaleList(token: token);
      AITale2.clear();
      for (int i = 0; i < AITaleList.length; i++) {
        if (i % 2 == 1) {
          AITale2.add([AITaleList.elementAt(i - 1), AITaleList.elementAt(i)]);
        }
      }
      if (AITaleList.length % 2 == 1) {
        AITale2.add([AITaleList.last]);
      }
      print('AITale2LENGTH: ${AITale2.length}');
      print('AITale2LENGTH: ${AITale2.first.length}');
      print(AITale2.last.toString());
      print(AITale2.first.toString());
      print('AITaleListLENGTH: ${AITaleList.length}');
      quizTaleList = jsonResponse['result'];
      quizTale2.clear();
      for (int i = 0; i < quizTaleList.length; i++) {
        if (i % 2 == 1) {
          quizTale2
              .add([quizTaleList.elementAt(i - 1), quizTaleList.elementAt(i)]);
        }
      }
      if (quizTaleList.length % 2 == 1) {
        quizTale2.add([quizTaleList.last, []]);
      }
      setState(() {});
    } catch (e) {
      print('$e getQuizTale 에러');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (quizTaleList.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.0375,
                    bottom: MediaQuery.of(context).size.height * 0.0125),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedText(
                        text: const Text(
                          '퀴즈 동화',
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                        strokes: [
                          OutlinedTextStroke(
                              color: Color(0xff1A8200), width: 5),
                        ]),
                  ],
                ),
              ),
            // QUIZ TALE
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 1.521105336544556,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/library/box-library-bar.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: CarouselSlider(
                items: quizTale2
                    .map(
                      (e) => Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizTaleView(e.first),
                                  )),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width *
                                        0.02),
                                child: Image.asset(
                                  'assets/library/btn-library-${e.first['quizTaleId']}.png',
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizTaleView(e.last),
                                  )),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.02),
                                child: Image.asset(
                                  'assets/library/btn-library-${e.last['quizTaleId']}.png',
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                  autoPlay: false,
                  enableInfiniteScroll: false,
                ),
              ),
            ),
            if (AITaleList.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.025,
                    bottom: MediaQuery.of(context).size.height * 0.0125),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedText(
                        text: const Text(
                          '내가 만든 동화',
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                        strokes: [
                          OutlinedTextStroke(
                              color: Color(0xffffb628), width: 5),
                        ])
                  ],
                ),
              ),
            // AI TALE
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: AITale2.map(
                  (e) => Container(
                    width: MediaQuery.of(context).size.width,
                    height:
                        MediaQuery.of(context).size.width / 1.521105336544556,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/library/box-library-bar.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (e.length == 2)
                          Container(
                            margin: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.0125),
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/library/box-library-aitale.png'),
                                // fit: BoxFit.fill,
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CompleteStory(id: e.first['aiTaleId']),
                              )),
                              onLongPress: () async {
                                final shouldDelete =
                                    await showDeleteDialog(context);
                                if (shouldDelete) {
                                  bool result = await _araiService.deleteAITale(
                                      id: e.first['aiTaleId'] as int,
                                      token: await FirebaseAuth
                                          .instance.currentUser!
                                          .getIdToken());
                                  if (result) {
                                    await getQuizTale();
                                  }
                                }
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: MediaQuery.of(context).size.width *
                                            0.075,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        bottom:
                                            MediaQuery.of(context).size.width *
                                                0.025),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(23),
                                      elevation: 7.5,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(23),
                                        child: Image.network(
                                          e.first['image'],
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                0.025),
                                    child: OutlinedText(
                                        text: Text(
                                          e.first['wordEng'],
                                          style: TextStyle(
                                              shadows: [
                                                Shadow(
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    offset: const Offset(2, 2),
                                                    blurRadius: 11),
                                              ],
                                              color: Colors.white,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05),
                                        ),
                                        strokes: [
                                          OutlinedTextStroke(
                                              color: Color(0xffffb628),
                                              width: 5),
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (e.length != 1)
                          Container(
                          margin: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.025),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/library/box-library-aitale.png'),
                              // fit: BoxFit.fill,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  CompleteStory(id: e.last['aiTaleId']),
                            )),
                            onLongPress: () async {
                              final shouldDelete =
                                  await showDeleteDialog(context);
                              if (shouldDelete) {
                                bool result = await _araiService.deleteAITale(
                                    id: e.last['aiTaleId'] as int,
                                    token: await FirebaseAuth
                                        .instance.currentUser!
                                        .getIdToken());
                                if (result) {
                                  await getQuizTale();
                                }
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.width *
                                          0.075,
                                      left: MediaQuery.of(context).size.width *
                                          0.05,
                                      right: MediaQuery.of(context).size.width *
                                          0.05,
                                      bottom:
                                          MediaQuery.of(context).size.width *
                                              0.025),
                                  // padding: EdgeInsets.all(
                                  //     MediaQuery.of(context).size.width * 0.05),
                                  child: Material(
                                    elevation: 7.5,
                                    borderRadius: BorderRadius.circular(23),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(23),
                                      child: Image.network(
                                        e.last['image'],
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.025),
                                  child: OutlinedText(
                                      text: Text(
                                        e.last['wordEng'],
                                        style: TextStyle(
                                            shadows: [
                                              Shadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  offset: const Offset(2, 2),
                                                  blurRadius: 11),
                                            ],
                                            color: Colors.white,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05),
                                      ),
                                      strokes: [
                                        OutlinedTextStroke(
                                            color: Color(0xffffb628), width: 5),
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (e.length == 1)
                          Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/library/box-library-aitale.png'),
                                // fit: BoxFit.fill,
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CompleteStory(id: e.first['aiTaleId']),
                              )),
                              onLongPress: () async {
                                final shouldDelete =
                                    await showDeleteDialog(context);
                                if (shouldDelete) {
                                  bool result = await _araiService.deleteAITale(
                                      id: e.first['aiTaleId'] as int,
                                      token: await FirebaseAuth
                                          .instance.currentUser!
                                          .getIdToken());
                                  if (result) {
                                    await getQuizTale();
                                  }
                                }
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: MediaQuery.of(context).size.width *
                                            0.075,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        bottom:
                                            MediaQuery.of(context).size.width *
                                                0.025),
                                    // padding: EdgeInsets.all(
                                    //     MediaQuery.of(context).size.width * 0.05),
                                    child: Material(
                                      elevation: 7.5,
                                      borderRadius: BorderRadius.circular(23),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(23),
                                        child: Image.network(
                                          e.first['image'],
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                0.025),
                                    child: OutlinedText(
                                        text: Text(
                                          e.first['wordEng'],
                                          style: TextStyle(
                                              shadows: [
                                                Shadow(
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    offset: const Offset(2, 2),
                                                    blurRadius: 11),
                                              ],
                                              color: Colors.white,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05),
                                        ),
                                        strokes: [
                                          OutlinedTextStroke(
                                              color: Color(0xffffb628),
                                              width: 5),
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ).toList()),
          ],
        ),
      ),
    );
  }

  Future<bool> showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('동화삭제'),
          content: const Text('도서관에서 삭제하시겠습니까 ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('삭제하기'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('취소하기'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}
