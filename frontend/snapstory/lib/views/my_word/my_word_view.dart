import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:snapstory/services/ar_ai_service.dart';

import '../../utilities/loading_dialog.dart';

class MyWord extends StatefulWidget {
  const MyWord({Key? key}) : super(key: key);

  @override
  State<MyWord> createState() => _MyWordState();
}

class _MyWordState extends State<MyWord> {
  late ARAIService _araiService;
  late List wordList;
  late FlutterTts flutterTts;
  late int _current = 0;
  late bool isEng = true;

  @override
  void initState() {
    _araiService = ARAIService();
    flutterTts = FlutterTts();
    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.5); //speed of speech
    flutterTts.setVolume(1.0); //volume of speech
    flutterTts.setPitch(1); //pitc of sound
    super.initState();
  }

  Future<int> makeSound({required String text}) async {
    return await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: FirebaseAuth.instance.currentUser!.getIdToken(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder(
              future: _araiService.getWordList(token: snapshot.data.toString()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  wordList = snapshot.data!.toList();
                  if (wordList.isNotEmpty) {
                    return Center(
                      child: CarouselSlider(
                        options: CarouselOptions(
                            height: MediaQuery.of(context).size.height * 0.6,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: true,
                            initialPage: 0,
                            autoPlay: false,
                            onPageChanged: (index, reason) {
                              _current = index;
                              setState(() {
                                isEng = true;
                              });
                            }),
                        items: wordList
                            .map((e) => GestureDetector(
                                  onTap: () => setState(() {
                                    isEng = !isEng;
                                  }),
                                  child: Card(
                                      elevation: 5.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(23)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              makeSound(
                                                  text: e['wordExampleEng']
                                                      .toString());
                                            },
                                            icon: const Icon(
                                                Icons.volume_up_rounded),
                                            padding: const EdgeInsets.all(10),
                                            iconSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Image.asset(
                                              e['word']['image'].toString(),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              isEng
                                                  ? e['word']['wordEng']
                                                  : e['word']['wordKor'],
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.1),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              isEng
                                                  ? e['wordExampleEng']
                                                  : e['wordExampleKor'],
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      )),
                                ))
                            .toList(),
                      ),
                    );
                  } else {
                    return Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(23),
                          border: Border.all(
                              width: 5, color: const Color(0xffFFCA10)),
                          color: const Color(0xffFFF0BB),
                        ),
                        height: MediaQuery.of(context).size.width * 0.8,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Image.asset('assets/snappy.png')]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '단어를 추가해주세요~',
                                    style: TextStyle(fontSize: 30),
                                  )
                                ],
                              )
                            ]),
                      ),
                    );
                  }
                } else {
                  return const Center(child: LoadingDialog());
                }
              },
            );
          } else {
            return const Center(child: LoadingDialog());
          }
        },
      ),
    );
  }
}
