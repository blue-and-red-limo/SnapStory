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

    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: YoutubePlayerScaffold(
            controller: _controller,
            builder: (context, player) {
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/main/bg-main3.png'))),
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.9,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedText(
                                  text: Text(title,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 40)),
                                  strokes: [
                                    OutlinedTextStroke(
                                        color: Color(0xffffb628), width: 10),
                                  ]),
                              Container(
                                child: player,
                                margin: EdgeInsets.all(20),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const MainView(selectedPage: 1)));
                        },
                        icon: Icon(
                          Icons.exit_to_app,
                          size: MediaQuery.of(context).size.width * 0.13,
                        ),
                        color: Color(0xffffb628),
                        // iconSize: ,
                      ),
                    ),
                  )
                ],
              );
            }));
  }
}
