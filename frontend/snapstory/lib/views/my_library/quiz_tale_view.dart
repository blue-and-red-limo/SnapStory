import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:snapstory/views/main_view.dart';

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
                            image: AssetImage('assets/bg/bg-main3.png'))),
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.9,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(title, style: TextStyle(fontSize: 30)),
                              Container(
                                child: player,
                                margin: EdgeInsets.all(10),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/bg/bg-bar.png',
                          ),
                          Positioned(
                            top: -20,
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const MainView(selectedPage: 1)));
                                },
                                icon: Icon(Icons.exit_to_app_rounded),
                                color: Color(0xffffb628),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }));
  }
}
