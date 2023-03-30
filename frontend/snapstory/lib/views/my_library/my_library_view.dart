import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snapstory/services/ar_ai_service.dart';
import 'package:snapstory/utilities/loading_dialog.dart';
import 'package:snapstory/views/home/complete_story_view.dart';
import 'package:snapstory/views/my_library/quiz_tale_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class MyLibrary extends StatefulWidget {
  const MyLibrary({Key? key}) : super(key: key);

  @override
  State<MyLibrary> createState() => _MyLibraryState();
}

class _MyLibraryState extends State<MyLibrary> {
  late final ARAIService _araiService;
  late List AITaleList;
  List<dynamic> quizTaleList = [];
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
      setState(() {
        quizTaleList = jsonResponse['result'];
      });
    } catch (e) {
      print('$e getQuizTale 에러');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: (token != '')
            ? FutureBuilder(
                future: _araiService.getAITaleList(token: token),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    AITaleList = snapshot.data!.toList();
                    return Column(
                      children: [
                        Row(
                          children: [
                            Text('퀴즈 동화 '),
                            Icon(Icons.menu_book_rounded),
                          ],
                        ),
                        Expanded(
                          child: GridView.count(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.all(4),
                              childAspectRatio: 2.0,
                              crossAxisCount: 1,
                              children: quizTaleList
                                  .map(
                                    (quizTale) => Column(
                                      children: [
                                        Container(
                                          height: (MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.3),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(23),
                                            // border: Border.all(
                                            //     width: 5,
                                            //     color: const Color(0xffFFCA10)),
                                            // color: const Color(0xffFFF0BB),
                                          ),
                                          margin: const EdgeInsets.all(4),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      QuizTaleView(quizTale),
                                                ),
                                              );
                                            },
                                            child: Image.asset(
                                              'assets/quizTaleList/${quizTale['quizTaleId']}.jpg',
                                              fit: BoxFit.fitHeight,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList()),
                        ),
                        Row(
                          children: [
                            Text('내가 만든 동화책 '),
                            Icon(Icons.menu_book_rounded),
                          ],
                        ),
                        Expanded(
                          child: GridView.count(
                            padding: const EdgeInsets.all(4),
                            childAspectRatio: (1 / 1.61803398875),
                            crossAxisCount: 3,
                            children: AITaleList.map(
                              (AITale) => Column(
                                children: [
                                  Container(
                                    height: (MediaQuery.of(context).size.width -
                                                32) /
                                            3 *
                                            1.61803398875 -
                                        11,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(23),
                                      // border: Border.all(
                                      //     width: 5,
                                      //     color: const Color(0xffFFCA10)),
                                      // color: const Color(0xffFFF0BB),
                                    ),
                                    margin: const EdgeInsets.all(4),
                                    child: GestureDetector(
                                      onTap: () {
                                        print(AITale['aiTaleId']);
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => CompleteStory(
                                                id: AITale['aiTaleId']),
                                          ),
                                        );
                                      },
                                      child: Image.network(
                                        AITale['image'],
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                  Text(AITale['wordEng']),
                                ],
                              ),
                            ).toList(),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(child: LoadingDialog());
                  }
                },
              )
            : const Center(child: LoadingDialog()));
  }
}
