import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:snapstory/views/main_view.dart';
import 'package:outlined_text/outlined_text.dart';

class QuizTaleView extends StatefulWidget {
  final dynamic quizInfo;

  const QuizTaleView(this.quizInfo);

  @override
  State<QuizTaleView> createState() => _QuizTaleViewState();
}

class _QuizTaleViewState extends State<QuizTaleView> {
  late YoutubePlayerController _controller;
  // late StreamSubscription<Duration> subscription;
  dynamic quizInfo = '';
  String title = '';

  @override
  void initState() {
    quizInfo = widget.quizInfo;
    title = quizInfo["title"];
    _controller = YoutubePlayerController.fromVideoId(
      videoId: quizInfo["video"],
      autoPlay: false,
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
      ),
    );

    // subscription = _controller
    //     .videoStateStream
    //     .listen as StreamSubscription<Duration>;

    super.initState();
  }

  @override
  void dispose() {
    // _controller.stopVideo();
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/main/bg-main3.png'))),
        child: YoutubePlayerScaffold(
            backgroundColor: Colors.transparent,
            controller: _controller,
            aspectRatio: 16 / 9,
            builder: (context, player) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body:
                    // ListView(padding: EdgeInsets.all(0), children: [
                    Container(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.15),
                          child: OutlinedText(
                              text: Text(title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                  )),
                              strokes: [
                                OutlinedTextStroke(
                                    color: Color(0xffffb628), width: 10),
                              ]),
                        ),
                        Container(
                          //   // height: MediaQuery.of(context).size.height * 0.25,
                          //   // width: MediaQuery.of(context).size.width * 0.9,
                          child: player,

                          margin: EdgeInsets.all(20),
                        ),
                        Image.asset(
                          'assets/library/snappy_watching.png',
                          height: MediaQuery.of(context).size.height * 0.2,
                        )
                        //     ],
                        //   ),
                        // ),

                        // Align(
                        //   alignment: Alignment.bottomCenter,
                        //   child: SizedBox(
                        //     height: MediaQuery.of(context).size.height * 0.15,
                        //     child: Stack(
                        //       alignment: Alignment.bottomCenter,
                        //       children: [
                        //         Container(
                        //           width: MediaQuery.of(context).size.width,
                        //           height: MediaQuery.of(context).size.height * 0.1,
                        //           decoration: const BoxDecoration(
                        //             borderRadius: BorderRadius.only(
                        //                 topLeft: Radius.circular(32),
                        //                 topRight: Radius.circular(32)),
                        //             image: DecorationImage(
                        //               fit: BoxFit.cover,
                        //               image: AssetImage('assets/main/bg-bar.png'),
                        //             ),
                        //           ),
                        //         ),
                        //         // ),
                        //         Positioned(
                        //           width: MediaQuery.of(context).size.width,
                        //           bottom: MediaQuery.of(context).size.height * 0.05,
                        //           child: GestureDetector(
                        //             child: Container(
                        //               height: MediaQuery.of(context).size.width * 0.22,
                        //               decoration: const BoxDecoration(
                        //                   shape: BoxShape.circle, color: Colors.white),
                        //               // 정답 확인 버튼
                        //               child: Icon(
                        //                 Icons.exit_to_app_rounded,
                        //                 color: Color(0xffffb628),
                        //                 size: MediaQuery.of(context).size.width * 0.15,
                        //               ),
                        //             ),
                        //             onTap: () {
                        //               Navigator.of(context).push(MaterialPageRoute(
                        //                   builder: (context) =>
                        //                       const MainView(selectedPage: 1)));
                        //             },
                        //           ),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // Positioned(
                        //   width: MediaQuery.of(context).size.width,
                        //   bottom: MediaQuery.of(context).size.height * 0.05,
                        //   child:
                        // Container(
                        //   height: MediaQuery.of(context).size.width * 0.2,
                        //   decoration: BoxDecoration(
                        //       shape: BoxShape.circle, color: Colors.white),
                        //   child: IconButton(
                        //     onPressed: () {
                        //       Navigator.of(context).push(MaterialPageRoute(
                        //           builder: (context) =>
                        //               const MainView(selectedPage: 1))
                        // );
                        //     },
                        //     icon: Icon(
                        //       Icons.exit_to_app,
                        //       size: MediaQuery.of(context).size.width * 0.13,
                        //     ),
                        //     color: Color(0xffffb628),
                        //     // iconSize: ,
                        //   ),
                        // ),
                        // )
                        // )
                      ]),
                ),
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
                      // ),
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
                            _controller.stopVideo();
                            Navigator.of(context).push(
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
              );
            }),
      ),
    );
  }
}
