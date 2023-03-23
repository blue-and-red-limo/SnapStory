import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:painter/painter.dart';
import 'package:snapstory/constants/routes.dart';
import 'package:snapstory/utilities/loading_dialog.dart';
import 'package:snapstory/views/my_library/my_library_view.dart';

class DrawingView extends StatefulWidget {
  final int id;

  // const DrawingView({Key? key, this.id}) : super(key: key);
  const DrawingView(this.id);

  @override
  State<DrawingView> createState() => _DrawingViewState();
}

class _DrawingViewState extends State<DrawingView> {
  String baseUrl = 'https://j8a401.p.ssafy.io/api/v1';
  dynamic token = '';
  int id = 0;
  bool _correct = false;
  bool isComplete = false;
  bool _1 = false;
  bool _2 = false;
  bool _3 = false;
  bool _4 = false;
  bool isLoading = false;
  String answer = '';
  dynamic _words = {};
  List<String> items = [
    "assets/empty.png",
    "assets/empty.png",
    "assets/empty.png",
    "assets/empty.png",
  ];

  late ConfettiController _controllerTopCenter;

  getInfo() async {
    id = widget.id;
    token = await FirebaseAuth.instance.currentUser?.getIdToken();
    try {
      http.Response response = await http.get(
          Uri.parse('$baseUrl/quiz-tale-items/$id'),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      var jsonResponse =
          jsonDecode(response.body)['result']['drawQuizTaleItems'];
      setState(() {
        _1 = jsonResponse[0]['draw'];
        _2 = jsonResponse[1]['draw'];
        _3 = jsonResponse[2]['draw'];
        _4 = jsonResponse[3]['draw'];

        for (int i in [0, 1, 2, 3]) {
          _words[jsonResponse[i]['itemEng']] = jsonResponse[i]['itemId'];
          jsonResponse[i]['draw']
              ? items[i] = '${jsonResponse[i]['imageColor']}.png'
              : items[i] = '${jsonResponse[i]['imageBlack']}.png';
        }
      });
    } catch (e) {
      print('$e getInfo 에러');
    }
    // print(token);
  }

  getItems() async {
    try {
      http.Response response = await http.get(
          Uri.parse('$baseUrl/quiz-tale-items/$id'),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      var jsonResponse =
          jsonDecode(response.body)['result']['drawQuizTaleItems'];
      setState(() {
        _1 = jsonResponse[0]['draw'];
        _2 = jsonResponse[1]['draw'];
        _3 = jsonResponse[2]['draw'];
        _4 = jsonResponse[3]['draw'];
        for (int i in [0, 1, 2, 3]) {
          jsonResponse[i]['draw']
              ? items[i] = '${jsonResponse[i]['imageColor']}.png'
              : items[i] = '${jsonResponse[i]['imageBlack']}.png';
        }
      });
    } catch (e) {
      print('$e getItems 에러');
    }
  }

  // 정답 확인 함수
  void isCorrect() async {
    setState(() {
      isLoading = true;
    });
    // 이미지 보내기
    await img();
    print(answer);

    // 정답인지 확인
    if (_words[answer].runtimeType == int) {
      _correct = true;
      _controllerTopCenter.play();
      int itemId = _words[answer];
      try {
        http.Response response =
            await http.post(Uri.parse('$baseUrl/quiz-tale-items'),
                headers: {
                  HttpHeaders.authorizationHeader: 'Bearer $token',
                  'Content-Type': "application/json"
                },
                body: jsonEncode(<String, int>{"quizTaleItemListId": itemId}));
        var jsonResponse = jsonDecode(response.body);

        // 컴플리트
        isComplete = jsonResponse['result']['complete'];
      } catch (e) {
        print('$e isCorrect 정답 확인 에러');
      }
    } else {
      _correct = false;
    }
    setState(() {
      isLoading = false;
    });
    modal();
  }

  // 이미지 string으로 보내기
  img() async {
    PictureDetails picture = _controller.finish();
    Uint8List a = await picture.toPNG();

    try {
      http.Response response = await http.post(
          Uri.parse('https://j8a401.p.ssafy.io/ai/predictions/drawings'),
          headers: {'Content-Type': "application/json"},
          body: jsonEncode(<String, String>{"base64_file": base64Encode(a)}));
      // logDev.log(base64Encode(a));
      var jsonResponse = jsonDecode(response.body);
      answer = await jsonResponse;
    } catch (e) {
      print('$e 이미지 확인 에러');
    }
    setState(() {
      _controller = _newController();
    });
  }

  // 정답 or 오답 모달
  modal() {
    return showDialog(
        context: context,
        // 바깥 영역 터치시 닫을지 여부
        barrierDismissible: true,
        builder: (BuildContext context) => Stack(
              children: [
                Center(
                    child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.5,
                  margin: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                    bottom: 200,
                    top: 200,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xffffb628),
                      width: 6,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3f000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: (_correct)
                      ?
                      // 정답일 경우
                      Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                              const Text(
                                "정답입니다!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xffffb628),
                                  fontSize: 30,
                                ),
                              ),
                              const SizedBox(height: 50),
                              FittedBox(
                                fit: BoxFit.contain,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Text(
                                    answer,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      // fontSize: 60,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 50),
                              Container(
                                  width: 115,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13),
                                    color: const Color(0xffffb628),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _confirm();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xffffb628)),
                                    child: const Text(
                                      "확인",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  )),
                            ])
                      :
                      // 오답일 경우
                      Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: const Text(
                                "오답입니다",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xffffb628), fontSize: 30),
                              ),
                            ),
                            Image.asset(
                              'assets/snappy_crying.png',
                              height: 180,
                            ),
                            Container(
                                width: 150,
                                height: 50,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  // color: Color(0xffffb628),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _confirm();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xffffb628)),
                                  child: const Text(
                                    "다시 그려보기",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                )),

                // confetti
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _controllerTopCenter,
                    blastDirectionality: BlastDirectionality.explosive,
                    emissionFrequency: 0.6,
                    minimumSize: const Size(5, 5),
                    maximumSize: const Size(15, 15),
                    numberOfParticles: 1,
                    gravity: 0.5,
                    shouldLoop: true,
                  ),
                ),
              ],
            ));
  }

  // 정답 후 확인 or 다시 풀기 클릭시
  _confirm() async {
    Navigator.of(context).pop();
    await getItems();

    // complete가 true, 각 item이 false면 동화 확인 창 띄우고 도서관으로 이동
    if (isComplete && !_1 && !_2 && !_3 && !_4) {
      showDialog(
          context: context, builder: (BuildContext context) => complete());
    } else {
      setState(() {
        _controller = _newController();
      });
    }
  }

  // 완성 후 도서관 이동
  complete() {
    return Container(
        margin: const EdgeInsets.only(
          left: 30,
          right: 30,
          bottom: 250,
          top: 250,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xffffb628),
            width: 6,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3f000000),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "동화가 완성되었어요!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xffffb628),
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 50),
              Container(
                  width: 250,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: const Color(0xffffb628),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyLibrary()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffffb628)),
                    child: const Text(
                      "도서관으로 이동하기",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  )),
              SizedBox(height: 15),
              Container(
                  width: 250,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: const Color(0xffffb628),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(drawingTaleListRoute);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffffb628)),
                    child: const Text(
                      "다른 그림 퀴즈 풀어보기",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  )),
            ]));
  }

  PainterController _controller = _newController();

  @override
  void initState() {
    getInfo();
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 10));

    super.initState();
  }

  @override
  void dispose() {
    _controllerTopCenter.dispose();
    super.dispose();
  }

  // 그림 그리는 부분
  static PainterController _newController() {
    PainterController controller = PainterController();
    controller.thickness = 5.0;
    // controller.backgroundColor = Colors.amber;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          Column(
            children: [
              // 나가기
              Container(
                margin: EdgeInsets.fromLTRB(
                    0, MediaQuery.of(context).padding.top, 20, 0),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamed(drawingTaleListRoute);
                    },
                    icon: const Icon(
                      Icons.cancel_rounded,
                      color: Color(0xffffb628),
                      size: 30,
                    ),
                    label: const Text(
                      '나가기',
                      style: TextStyle(color: Color(0xffffb628), fontSize: 20),
                    ),
                  ),
                ]),
              ),

              // 동화 아이템
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                decoration: const BoxDecoration(color: Color(0xffd9d9d9)),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20),
                                child: Image.asset(
                                  items[0],
                                  width: 120,
                                )),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: Image.asset(
                                items[1],
                                width: 120,
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            child: Image.asset(
                              items[2],
                              width: 120,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            child: Image.asset(
                              items[3],
                              width: 120,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 툴 + 그림 그리는 부분
              Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1)),
                  child: Column(children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xffffb628),
                      ),
                      // 툴바
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 펜 or 지우개
                          _controller.eraseMode
                              ? RotatedBox(
                                  quarterTurns: 2,
                                  child: IconButton(
                                      icon: const Icon(Icons.auto_fix_high),
                                      tooltip: 'Enable eraser',
                                      onPressed: () {
                                        setState(() {
                                          _controller.eraseMode =
                                              !_controller.eraseMode;
                                        });
                                      }),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.create),
                                  tooltip: 'Disable eraser',
                                  onPressed: () {
                                    setState(() {
                                      _controller.eraseMode =
                                          !_controller.eraseMode;
                                    });
                                  }),
                          // 펜, 지우개 굵기 조절 Slider
                          Container(
                            width: 150,
                            child: SliderTheme(
                              data: const SliderThemeData(
                                valueIndicatorShape:
                                    PaddleSliderValueIndicatorShape(),
                              ),
                              child: Slider(
                                value: _controller.thickness,
                                onChanged: (double value) => setState(() {
                                  _controller.thickness = value;
                                }),
                                min: 0.0,
                                max: 20.0,
                                divisions: 4,
                                label: _controller.thickness.round().toString(),
                                activeColor: Colors.black,
                              ),
                            ),
                          ),

                          // 되돌리기
                          IconButton(
                              icon: const Icon(
                                Icons.undo,
                              ),
                              tooltip: 'Undo',
                              onPressed: () {
                                if (!_controller.isEmpty) {
                                  _controller.undo();
                                }
                              }),
                          // 다 지우기
                          IconButton(
                              icon: const Icon(Icons.refresh),
                              tooltip: 'Clear',
                              onPressed: _controller.clear)
                        ],
                      ),
                    ),

                    // 그림 그리는 부분
                    AspectRatio(
                      aspectRatio: 1.2,
                      child: Painter(_controller),
                    ),
                  ])),

              // 정답 확인 버튼
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffffb628)),
                  onPressed: () {
                    // 정답 확인 함수 실행
                    isCorrect();
                  },
                  child: const Text('정답 확인',
                      style: TextStyle(
                        color: Colors.white,
                      ))),
            ],
          ),
          if (isLoading) const Center(child: LoadingDialog()),
        ]),
      ),
    );
  }
}
