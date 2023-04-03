import 'dart:typed_data';
import 'package:snapstory/constants/routes.dart';
import 'package:snapstory/views/my_library/my_library_view.dart';
import 'package:flutter/material.dart';
// import 'package:painter/painter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:confetti/confetti.dart';
import 'package:outlined_text/outlined_text.dart';
import 'dart:developer' as logDev;

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
  String answer = '';
  dynamic _words = {};
  List<String> items = [
    "assets/empty.png",
    "assets/empty.png",
    "assets/empty.png",
    "assets/empty.png",
  ];
  List title = ['신데렐라', '백설공주', '잠자는 숲속의 공주', '라푼젤', '미녀와 야수'];
  // 캔버스에 그림 그리기 위해 담는 리스트
  List<List<Offset>> _points = [];
  // AI쪽에 보낼 정보를 담는 리스트
  List<List<List<int>>> path = [];

  late ConfettiController _controllerTopCenter;

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
    // 이미지 보내기
    await check();
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
    modal();
  }

  // 정답 확인 - AI 서버
  check() async {
    try {
      http.Response response = await http.post(
          Uri.parse('https://j8a401.p.ssafy.io/recognize/doodles'),
          headers: {'Content-Type': "application/json"},
          body: jsonEncode(<String, List<List<List<int>>>>{"data": path}));
      var jsonResponse = jsonDecode(response.body);

      print("============jon Response ==============");
      print(jsonResponse);
      if (jsonResponse['probability'] >= 0.7) {
        answer = jsonResponse['prediction'];
      }
    } catch (e) {
      print('$e 이미지 확인 에러');
    }
    setState(() {
      _points = [];
      path = [];
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
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.of(context).size.height * 0.05),
                        margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.1,
                            vertical:
                                MediaQuery.of(context).size.height * 0.25),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // 정답일 경우 정답입니다, 아닐 경우 오답입니다
                              Text(
                                (_correct) ? "정답입니다!" : "오답입니다",
                                style: TextStyle(
                                    fontFamily: 'ONE Mobile POP',
                                    color: Color(0xffffb628),
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold),
                              ),
                              (_correct)
                                  ? FittedBox(
                                      fit: BoxFit.contain,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30),
                                        child: Text(
                                          answer,
                                          style: const TextStyle(
                                            fontFamily: 'ONE Mobile POP',
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Image.asset(
                                      'assets/snappy_crying.png',
                                      // height: 180,
                                    ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size.fromHeight(
                                      MediaQuery.of(context).size.height *
                                          0.06),
                                  backgroundColor: Color(0xffffb628),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                ),
                                onPressed: () {
                                  _confirm();
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      (_correct) ? "확인  " : "다시하기  ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    ),
                                    Icon(
                                      (_correct)
                                          ? Icons.check_rounded
                                          : Icons.refresh_rounded,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ]))),

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
      complete();
    }
  }

// 완성 후 도서관 이동
  complete() {
    return showDialog(
        context: context,
        builder: (BuildContext context) => Container(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.05),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.25),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.05),
                    child: const Text(
                      "동화가 완성되었어요!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xffffb628),
                        fontFamily: 'ONE Mobile POP',
                        fontSize: 35,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyLibrary()));
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.05),
                        backgroundColor: const Color(0xffffb628)),
                    child: const Text(
                      "도서관으로 이동하기",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(drawingTaleListRoute);
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.05),
                        backgroundColor: const Color(0xffffb628)),
                    child: const Text(
                      "다른 그림 퀴즈 풀어보기",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/main/bg-main2.png'),
                ),
              ),
              child: Column(
                children: [
                  // 상단바
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 도움말 - 튜토리얼
                        IconButton(
                            iconSize: MediaQuery.of(context).size.width * 0.25,
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/main/btn-help.png',
                            )),
                        // 동화 제목
                        OutlinedText(
                            text: Text(title[id - 1],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 40)),
                            strokes: [
                              OutlinedTextStroke(
                                  color: const Color(0xff198100), width: 10),
                            ]),
                        // 나가기
                        IconButton(
                            iconSize: MediaQuery.of(context).size.width * 0.25,
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(drawingTaleListRoute);
                            },
                            icon: Image.asset(
                              'assets/main/btn-quit.png',
                            )),
                      ]),

                  // 동화 아이템
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: const Color(0xffffb628), width: 4),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(18)),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x3f000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.02),
                              margin: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.width * 0.02,
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.05),
                              child: Image.asset(
                                items[0],
                                width: MediaQuery.of(context).size.width * 0.25,
                              )),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color(0xff198100), width: 4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(18)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x3f000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.02),
                            margin: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.width * 0.02,
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05),
                            child: Image.asset(
                              items[1],
                              width: MediaQuery.of(context).size.width * 0.25,
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color(0xffff0080), width: 4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(18)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x3f000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.02),
                            margin: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.width * 0.02,
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05),
                            child: Image.asset(
                              items[2],
                              width: MediaQuery.of(context).size.width * 0.25,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color(0xff0060c4), width: 4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(18)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x3f000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.02),
                            margin: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.width * 0.02,
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05),
                            child: Image.asset(
                              items[3],
                              width: MediaQuery.of(context).size.width * 0.25,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // 클리어 버튼 + 그림 그리는 부분
                  Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                              'assets/quizTaleList/box-quiz-board.png'),
                        ),
                      ),
                      child: Stack(children: [
                        // 그림 그리는 부분
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * 0.05,
                              MediaQuery.of(context).size.height * 0.05,
                              MediaQuery.of(context).size.width * 0.05,
                              MediaQuery.of(context).size.height * 0.01),
                          child: GestureDetector(
                            child: CustomPaint(
                              painter: DrawingPainter(_points),
                              size: Size(
                                  MediaQuery.of(context).size.width * 0.9,
                                  MediaQuery.of(context).size.height * 0.3),
                            ),
                            onPanStart: (details) {
                              setState(() {
                                _points.add([details.localPosition]);
                                path.add([
                                  [details.localPosition.dx.toInt()],
                                  [details.localPosition.dy.toInt()]
                                ]);
                              });
                            },
                            onPanUpdate: (details) {
                              setState(() {
                                // 범위에서 벗어나면 리스트에 추가X
                                if (details.localPosition.dx > 0 &&
                                    details.localPosition.dx <
                                        MediaQuery.of(context).size.width *
                                            0.8 &&
                                    details.localPosition.dy > 0 &&
                                    details.localPosition.dy <
                                        MediaQuery.of(context).size.height *
                                            0.24) {
                                  _points.last.add(details.localPosition);
                                  path.last[0]
                                      .add(details.localPosition.dx.toInt());
                                  path.last[1]
                                      .add(details.localPosition.dy.toInt());
                                }
                              });
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.15,
                              right: MediaQuery.of(context).size.width * 0.05),
                          // 다시 그리기 버튼
                          child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Color(0xffffb628),
                                ),
                                iconSize:
                                    MediaQuery.of(context).size.width * 0.1,
                                tooltip: 'Clear',
                                onPressed: () {
                                  setState(() {
                                    path = [];
                                    _points = [];
                                  });
                                }),
                          ),
                        ),
                      ])),
                ],
              ),
            ),
            // 하단 바
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
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
            ),
            Positioned(
              width: MediaQuery.of(context).size.width,
              bottom: MediaQuery.of(context).size.height * 0.05,
              child: Container(
                height: MediaQuery.of(context).size.width * 0.2,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                // 정답 확인 버튼
                child: IconButton(
                  onPressed: () {
                    isCorrect();
                  },
                  icon: Icon(
                    Icons.check_rounded,
                    size: MediaQuery.of(context).size.width * 0.15,
                  ),
                  color: const Color(0xffffb628),
                  // iconSize: ,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// 제스처로 수집한 데이터를 화면에 나타내는 부분
class DrawingPainter extends CustomPainter {
  List<List<Offset>> points;

  DrawingPainter(this.points);

  bool out = true;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    for (var pointList in points) {
      for (int i = 0; i < pointList.length - 1; i++) {
        canvas.drawLine(pointList[i], pointList[i + 1], paint);
      }
    }
  }

  // 바로바로 반영
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
