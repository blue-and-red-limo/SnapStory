import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class QuizTaleView extends StatefulWidget {
  final dynamic quizInfo;

  // const DrawingView({Key? key, this.id}) : super(key: key);
  const QuizTaleView(this.quizInfo);

  @override
  State<QuizTaleView> createState() => _QuizTaleViewState();
}

class _QuizTaleViewState extends State<QuizTaleView> {
  late YoutubePlayerController _controller;
  // late YoutubePlayerValue isFullScreen;
  dynamic quizInfo = '';
  String title = '';
  bool isFull = false;

  @override
  void initState() {
    quizInfo = widget.quizInfo;
    title = quizInfo["title"];
    _controller = YoutubePlayerController(
      initialVideoId: quizInfo["video"],
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        enableCaption: true,
        captionLanguage: "ko",
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //  _controller.toggleFullScreenMode(){

  //  }

  @override
  Widget build(BuildContext context) {
    print(_controller.value.isFullScreen);
    return Scaffold(
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
            bottomActions: [
              CurrentPosition(),
              ProgressBar(isExpanded: true),
              RemainingDuration(),
              // FullScreenButton()
              IconButton(
                  onPressed: () {
                    setState(() {
                      isFull ? isFull = false : isFull = true;
                    });
                    print(_controller.value.isFullScreen);
                  },
                  icon: Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                  ))
            ],
            // showVideoProgressIndicator: true,
            // progressIndicatorColor: Colors.blueAccent,
          ),
          builder: (context, player) {
            return (isFull)
                ? Container(
                    child: player,
                  )
                : Column(
                    children: [
                      Container(
                        child: Text(title, style: TextStyle(fontSize: 30)),
                        margin: EdgeInsets.all(10),
                      ),
                      Container(
                        child: player,
                        margin: EdgeInsets.all(10),
                      )
                    ],
                  );
          })
    ])));
  }
}
