import 'package:snapstory/views/help_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:confetti/confetti.dart';
import 'package:outlined_text/outlined_text.dart';
import 'package:snapstory/views/my_library/quiz_tale_view.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:developer' as logDev;

class DrawingView extends StatefulWidget {
  final int id;

  // const DrawingView({Key? key, this.id}) : super(key: key);
  const DrawingView(this.id, {super.key});

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
  dynamic quizInfo = {};
  List<String> items = [
    "assets/empty.png",
    "assets/empty.png",
    "assets/empty.png",
    "assets/empty.png",
  ];
  String title = '';
  dynamic color = const Color(0xffffb628);
  AudioPlayer audioPlayer = AudioPlayer();

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
    audioPlayer.stop();
    _controllerTopCenter.dispose();
    super.dispose();
  }

  // 처음 정보 불러오기
  getInfo() async {
    id = widget.id;
    token = await FirebaseAuth.instance.currentUser?.getIdToken();
    try {
      http.Response response = await http.get(
          Uri.parse('$baseUrl/quiz-tale-items/$id'),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      setState(() {
        quizInfo = jsonDecode(utf8.decode(response.bodyBytes))['result'];
        _1 = quizInfo['drawQuizTaleItems'][0]['draw'];
        _2 = quizInfo['drawQuizTaleItems'][1]['draw'];
        _3 = quizInfo['drawQuizTaleItems'][2]['draw'];
        _4 = quizInfo['drawQuizTaleItems'][3]['draw'];
        (id == 3)
            ? title = '잠자는\n숲속의 공주'
            : title =
                jsonDecode(utf8.decode(response.bodyBytes))['result']['title'];

        for (int i in [0, 1, 2, 3]) {
          _words[quizInfo['drawQuizTaleItems'][i]['itemEng']] =
              quizInfo['drawQuizTaleItems'][i]['itemId'];
          quizInfo['drawQuizTaleItems'][i]['draw']
              ? items[i] =
                  '${quizInfo['drawQuizTaleItems'][i]['imageColor']}.png'
              : items[i] =
                  '${quizInfo['drawQuizTaleItems'][i]['imageBlack']}.png';
        }
      });
    } catch (e) {
      print('$e getInfo 에러');
    }
  }

  // 정답 맞힌 이후 정보 불러오기
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
    // 그림 보내기
    await check();

    // 정답인지 확인, 답이 해당 동화 단어리스트 안에 있으면 정답
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
    // 정답 or 오답 모달
    (_correct)
        ? audioPlayer.play(AssetSource('sound/correct.mp3'))
        : audioPlayer.play(AssetSource('sound/wrong.mp3'));
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
      // 정확도 0.48 이상이면 정답으로 인정
      if (jsonResponse['probability'] >= 0.48) {
        answer = jsonResponse['prediction'];
      } else {
        answer = 'wrong';
      }
    } catch (e) {
      answer = 'wrong';
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
        barrierDismissible: false,
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
                            color: color,
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
                        child: DefaultTextStyle(
                          style: const TextStyle(fontFamily: 'ONE Mobile POP'),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // 정답일 경우 정답입니다, 아닐 경우 오답입니다
                                Text(
                                  (_correct) ? "정답입니다!" : "오답입니다",
                                  style: TextStyle(
                                      color: color,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.1,
                                      fontWeight: FontWeight.bold),
                                ),
                                (_correct)
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.02),
                                            child: Text(
                                              answer,
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Image.asset(
                                        'assets/snappy_crying.png',
                                      ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size.fromHeight(
                                        MediaQuery.of(context).size.height *
                                            0.06),
                                    backgroundColor: color,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                  ),
                                  onPressed: () {
                                    audioPlayer.stop();
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
                                            color: Colors.white,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05),
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
                              ]),
                        ))),

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
      audioPlayer.stop();
      audioPlayer.play(AssetSource('sound/complete.mp3'));
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
                color: color,
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
            child: DefaultTextStyle(
              style: TextStyle(
                fontFamily: 'ONE Mobile POP',
                fontSize: MediaQuery.of(context).size.width * 0.08,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.05),
                      child: Text(
                        "동화가 완성되었어요!",
                        style: TextStyle(
                          color: color,
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Column(
                          children: [
                            Image.asset('assets/library/snappy_watching.png'),
                            OutlinedText(
                              text: Text(
                                '동화 보러가기',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.08),
                              ),
                              strokes: [
                                OutlinedTextStroke(color: color, width: 10),
                              ],
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        audioPlayer.stop();
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuizTaleView(quizInfo)),
                        );
                      },
                    ),
                  ]),
            )));
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
                  image: AssetImage('assets/main/bg-main2_2.png'),
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
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => HelpView(index: 4)),
                              );
                            },
                            icon: Image.asset(
                              'assets/main/btn-help.png',
                            )),
                        // 동화 제목
                        Flexible(
                          child: Center(
                            child: OutlinedText(
                                text: Text(title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.09)),
                                strokes: [
                                  OutlinedTextStroke(
                                      color: const Color(0xff198100),
                                      width: 10),
                                ]),
                          ),
                        ),
                        // 나가기
                        IconButton(
                            iconSize: MediaQuery.of(context).size.width * 0.25,
                            onPressed: () {
                              // Navigator.of(context)
                              //     .pushNamed(drawingTaleListRoute);
                              Navigator.of(context).pop();
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
                                border: Border.all(color: color, width: 4),
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
                                height:
                                    MediaQuery.of(context).size.width * 0.25,
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
                              height: MediaQuery.of(context).size.width * 0.25,
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
                              height: MediaQuery.of(context).size.width * 0.25,
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
                              height: MediaQuery.of(context).size.width * 0.25,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // 클리어 버튼 + 그림 그리는 부분
                  Container(
                      height: MediaQuery.of(context).size.height * 0.33,
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
                              MediaQuery.of(context).size.height * 0.08,
                              MediaQuery.of(context).size.width * 0.05,
                              MediaQuery.of(context).size.height * 0.01),
                          // 그리는 부분 감지 & 화면에 표시
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
                                // 범위에서 벗어나면 리스트에 추가X (사이즈 딱 맞게X, 끝부분 조금 띄어서)
                                if (details.localPosition.dx > 0 &&
                                    details.localPosition.dx <
                                        MediaQuery.of(context).size.width *
                                            0.8 &&
                                    details.localPosition.dy > 0 &&
                                    details.localPosition.dy <
                                        MediaQuery.of(context).size.height *
                                            0.24) {
                                  _points.last.add(details.localPosition);
                                  path.last[0] // x축
                                      .add(details.localPosition.dx.toInt());
                                  path.last[1] // y축
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
                                icon: Icon(
                                  Icons.refresh,
                                  color: color,
                                ),
                                iconSize:
                                    MediaQuery.of(context).size.width * 0.1,
                                tooltip: '지우기',
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
            ),
            Positioned(
              width: MediaQuery.of(context).size.width,
              bottom: MediaQuery.of(context).size.height * 0.02,
              child: Container(
                height: MediaQuery.of(context).size.width * 0.25,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                // 정답 확인 버튼
                child: IconButton(
                  onPressed: () {
                    isCorrect();
                    // logDev.log(path.toString());
                  },
                  icon: Icon(
                    Icons.check_rounded,
                    size: MediaQuery.of(context).size.width * 0.15,
                  ),
                  color: color,
                  tooltip: '정답 확인',
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
