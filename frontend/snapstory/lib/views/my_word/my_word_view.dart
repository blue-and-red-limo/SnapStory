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
  late bool isCarousel = false;
  final List<bool> _selected = <bool>[true, false];

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
                    return Stack(
                      children: [
                        if (_selected[0])
                          Stack(
                            children: [
                              if(isCarousel)
                                Stack(
                                  children: [Center(
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                        height:
                                        MediaQuery.of(context).size.height * 0.6,
                                        aspectRatio: 1.61803398875,
                                        enlargeCenterPage: true,
                                        enableInfiniteScroll: true,
                                        initialPage: _current,
                                        autoPlay: false,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _current = index;
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
                                                      text:
                                                      e['wordExampleEng']
                                                          .toString());
                                                },
                                                icon: const Icon(
                                                    Icons.volume_up_rounded),
                                                padding:
                                                const EdgeInsets.all(10),
                                                iconSize:
                                                MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.1,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                    10.0),
                                                child: Image.asset(
                                                  e['word']['image']
                                                      .toString(),
                                                  height:
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.6,
                                                  width:
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.6,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                    10.0),
                                                child: Text(
                                                  isEng
                                                      ? e['word']['wordEng']
                                                      : e['word']['wordKor'],
                                                  style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          0.1),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                    10.0),
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
                              ),Positioned(
                                    left: 55,
                                    top: 600,
                                    child: Row(
                                      children: [
                                        Image.asset(wordList[_current]['word']['image'], height: 100, width: 100,),
                                        Image.asset(wordList[_current]['word']['image'], height: 100, width: 100,),
                                        Image.asset(wordList[_current]['word']['image'], height: 100, width: 100,)
                                      ],
                                    ),
                                  ),]
                                ),

                              if(!isCarousel)
                                GridView.count(
                                  crossAxisCount: 2,
                                  children: wordList.map((e) => GestureDetector(
                                    onTap: () {
                                      for(int i = 0; i < wordList.length; i++) {
                                        if (wordList[i]['word'] == e['word']) {
                                          setState(() {
                                            _current = i;
                                            isCarousel = !isCarousel;
                                          });
                                        }
                                      }
                                    },
                                    child: Image.asset(
                                      e['word']['image'],
                                      height: MediaQuery.of(context)
                                          .size
                                          .width *
                                          0.2,
                                      width: MediaQuery.of(context)
                                          .size
                                          .width *
                                          0.2,
                                    ),
                                  )).toList()),
                            ]
                          ),
                        if (_selected[1])
                          ListView.separated(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.05,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.04),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isEng = !isEng;
                                  });
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                              wordList[index]['word']['image'],
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                            ),
                                          ),
                                          Text(
                                            isEng
                                                ? wordList[index]['word']
                                                    ['wordEng']
                                                : wordList[index]['word']
                                                    ['wordKor'],
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      child: Text(
                                        isEng
                                            ? wordList[index]['wordExampleEng']
                                            : wordList[index]['wordExampleKor'],
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      child: IconButton(
                                        onPressed: () async {
                                          final shouldDelete =
                                              await showDeleteDialog(context);
                                          if (shouldDelete) {
                                            bool result =
                                                await _araiService.deleteWord(
                                                    word: wordList[index]
                                                        ['word']['wordEng'],
                                                    token: await FirebaseAuth
                                                        .instance.currentUser!
                                                        .getIdToken());
                                            if (result) setState(() {});
                                          }
                                        },
                                        icon: const Icon(
                                            Icons.delete_forever_rounded),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => const Divider(
                              color: Colors.white,
                              thickness: 1.6,
                            ),
                            itemCount: wordList.length,
                          ),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.02,
                          left: MediaQuery.of(context).size.width * 0.75,
                          child: ToggleButtons(
                            direction: Axis.horizontal,
                            onPressed: (int index) {
                              setState(() {
                                // The button that is tapped is set to true, and the others to false.
                                for (int i = 0; i < _selected.length; i++) {
                                  _selected[i] = i == index;
                                }
                                isCarousel = false;
                              });
                            },
                            borderRadius:
                                const BorderRadius.all(Radius.circular(23)),
                            selectedBorderColor: const Color(0xFFFFB628),
                            selectedColor: Colors.white,
                            fillColor: const Color(0xFFFFB628),
                            color: const Color(0xFFFFB628),
                            disabledColor: Colors.black,
                            constraints: BoxConstraints(
                              minHeight:
                                  MediaQuery.of(context).size.height * 0.05,
                              minWidth: MediaQuery.of(context).size.width * 0.1,
                            ),
                            isSelected: _selected,
                            children: const [
                              Icon(Icons.grid_view_rounded),
                              Icon(Icons.list_alt_rounded),
                            ],
                          ),
                        ),
                      ],
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

  Future<bool> showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('단어삭제'),
          content: const Text('단어장에서 삭제하시겠습니끼 ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('삭제하기'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('취소하기'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}
