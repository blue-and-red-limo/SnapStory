import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snapstory/views/main_view.dart';
import 'package:outlined_text/outlined_text.dart';
import 'package:youtube_player_iframe_plus/youtube_player_iframe_plus.dart';

class QuizTaleView extends StatefulWidget {
  final dynamic quizInfo;

  const QuizTaleView(this.quizInfo);

  @override
  State<QuizTaleView> createState() => _QuizTaleViewState();
}

class _QuizTaleViewState extends State<QuizTaleView> {
  late YoutubePlayerController _controller;
  dynamic quizInfo = '';
  String title = '';

  @override
  void initState() {
    quizInfo = widget.quizInfo;
    title = quizInfo["title"];

    _controller = YoutubePlayerController(
      initialVideoId: quizInfo["video"],
      params: const YoutubePlayerParams(
        autoPlay: false,
        playsInline: false,
        startAt: Duration(seconds: 11),
        showFullscreenButton: true,
      ),
    );

    _controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    };

    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        minimum: EdgeInsets.all(0),
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/main/bg-main3.png'))),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.15),
                  child: OutlinedText(
                      text: Text(title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).textScaleFactor * 40)),
                      strokes: [
                        OutlinedTextStroke(color: Color(0xffffb628), width: 10),
                      ]),
                ),
                Container(
                  margin:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                  child: YoutubePlayerIFramePlus(
                    controller: _controller,
                    // aspectRatio: 16 / 9,
                  ),
                ),
                Image.asset(
                  'assets/library/snappy_watching.png',
                  height: MediaQuery.of(context).size.height * 0.2,
                )
              ]),

              // 하단바
              floatingActionButton: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.15,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
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
                    Positioned(
                      width: MediaQuery.of(context).size.width,
                      bottom: MediaQuery.of(context).size.height * 0.05,
                      child: GestureDetector(
                        child: Container(
                          height: MediaQuery.of(context).size.width * 0.22,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          // 도서관 가기
                          child: Icon(
                            Icons.exit_to_app_rounded,
                            color: Color(0xffffb628),
                            size: MediaQuery.of(context).size.width * 0.15,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MainView(selectedPage: 1)),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
            )));
  }
}
