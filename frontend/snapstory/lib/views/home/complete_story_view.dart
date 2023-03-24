import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snapstory/views/home/home_view.dart';
import 'package:snapstory/views/home/make_story_view.dart';
import 'package:snapstory/views/main_view.dart';
import 'package:http/http.dart' as http;
import 'package:snapstory/views/my_library/my_library_view.dart';
import 'package:network_to_file_image/network_to_file_image.dart';

class CompleteStory extends StatefulWidget {
  const CompleteStory({Key? key, required this.id, required this.ft}) : super(key: key);

  final int id;
  final FairyTale ft;

  @override
  State<CompleteStory> createState() => _CompleteStoryState();
}

class _CompleteStoryState extends State<CompleteStory> {

  late FlutterTts flutterTts;

  Future<int> makeSound({required String text}) async {
    return await flutterTts.speak(text);
  }

  // 스토리 정보 받아오기
  void getStory() async {

    // 토큰 뽑기
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    // 동화 정보 불러오기
    // 이미지 없는 동화 먼저 저장
    final response = await http.get(
      Uri.parse("https://j8a401.p.ssafy.io/api/v1/ai-tales/$widget.id"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    print(jsonDecode(utf8.decode(response.bodyBytes)));
  }

  @override
  void initState() {
    flutterTts = FlutterTts();
    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.5); //speed of speech
    flutterTts.setVolume(1.0); //volume of speech
    flutterTts.setPitch(1);
    makeSound(text: "word");


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 15,
              ),
              Image.network(widget.ft.image, width: 350.0),

              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.05,
              // ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  margin: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 10.0),
                  child: Row(
                    children: [
                      const Text(
                        "Story about ",
                        style: TextStyle(fontSize: 22),
                      ),
                      const Text(
                        "word",
                        style: TextStyle(fontSize: 22, color: Colors.red),
                      )
                    ],
                  )),

              Container(
                height: 1.0,
                width: MediaQuery.of(context).size.width * 0.85,
                color: Colors.grey,
              ),

              Container(
                // color: Colors.orange,

                // height: MediaQuery.of(context).size.height * 0.35,
                margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: Text(
                  widget.ft.contentEng.split("\"")[1].split("\n")[2],
                  style: const TextStyle(fontSize: 19 ),
                    textAlign: TextAlign.justify
                ),
              ),

              Container(
                  // color: Colors.grey,
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                    alignment: Alignment(0.75, 0.0),
                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MainView(selectedPage: 1)),
                          );
                        },
                        child: const Text("나만의 도서관 가기")),
                  ))
            ],
          ),
        ),
      ),
    ));
  }
}
