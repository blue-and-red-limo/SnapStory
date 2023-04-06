import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// 필요한 것
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:openai_client/openai_client.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:snapstory/services/ar_ai_service.dart';
import 'package:snapstory/utilities/loading_dialog.dart';
import 'package:snapstory/utilities/loading_dialog_makingStory.dart';

import '../../constants/api_key.dart';
import '../../constants/api_key.dart';
import 'complete_story_view.dart';

// dalle가 만든 이미지 리스트
List<String> imgList = [];

// complete_story_view로 넘어갈 변수 2개
String story = ""; // chatGpt가 만든 스토리
String selectedImg = ""; // 선택한 이미지
late int aiTaleId;
late Future<String> imgPath;

// 동화 클래스
class FairyTale {
  final String contentEng;
  final String contentKor;
  final String image;
  final String wordEng;

  const FairyTale(this.contentEng, this.contentKor, this.image, this.wordEng);
}

//
// List<Widget> imageSliders

class MakeStory extends StatefulWidget {
  const MakeStory({Key? key, required this.word}) : super(key: key);

  final String word;

  @override
  State<MakeStory> createState() => _MakeStoryState();
}

class _MakeStoryState extends State<MakeStory> {
  late Future myFuture;
  late ARAIService _araiService;

  bool isLoading = false;
  bool selectReady = false;

  @override
  void initState() {
    _araiService = ARAIService();
    myFuture = askToGpt(context);
    super.initState();
  }

  // dall-e 사용하기
  void askToDalle(String imgStr) async {
    // Create a new client.
    final client = OpenAIClient(
      configuration: const OpenAIConfiguration(
        apiKey: apiKey,
      ),
    );

    // Create an image.
    final image = await client.images
        .create(
          prompt: 'cute illust of a group of $imgStr',
          n: 4, // 원하는 이미지 개수
        )
        .data;
    imgList.clear();
    for (int i = 0; i < 4; i++) {
      // 이미지 리스트에 추가
      imgList
          .add(image.data.toList().elementAt(i).props.elementAt(0).toString());
    }

    print("=================${imgStr}에 대한 imgList 상태===============");
    print(imgList.toString());
    setState(() {
    selectReady = true;

    });

    // return (image.data
    //     .toList()
    //     .elementAt(1)
    //     .props
    //     .elementAt(0)
    //     .toString()); // 첫번째 elementAt에 들어가는 숫자가 달리가 불러오는 이미지 인덱스
  }

  // GPT 사용하기 (동화텍스트와 동화 이미지 경로를 반환)
  Future<FairyTale> askToGpt(BuildContext context) async {

    late FairyTale ft;
    // 토큰 뽑기
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();

    final res = await http.get(
      Uri.parse(
          "https://j8a401.p.ssafy.io/api/v1/ai-tales/word/${widget.word}"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    print("단어로 동화 조회 결과");
    print(jsonDecode(utf8.decode(res.bodyBytes)));

    if (res.statusCode == 200) {
      // 단어로 만든 동화가 있으면
      // 중복된 단어 있다고 알림 띄우기
      // set up the button
      Widget okButton = TextButton(
        child: const Text("확인"),
        onPressed: () {
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ >= 2);
          // Navigator.of(context).pop();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("중복된 동화가 있습니다."),
        content: const Text("새로운 동화를 만들고 싶다면\n동화 화면에서 기존 동화를 삭제해주세요."),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      await showDialog(
        barrierDismissible: false,
        context: context,
        useRootNavigator: false,
        builder: (BuildContext context) {
          return WillPopScope(onWillPop: () async => false, child: alert);
        },
      );
    } else if (res.statusCode != 200) { // 단어로 만든 동화가 없으면 진행

      print(
          "================================[result][errorCode]=====================================");
      print(jsonDecode(utf8.decode(res.bodyBytes))['result']['errorCode']);
      String obj = widget.word; // 인식한 사물 이름 넣기
      String data =
          await _araiService.generateStoryandImage(obj); // 동화와 이미지 문장 만들기

      List<String> str = data.split("Image:");

      String fairytale = str[0]; // 동화 저장
      story = fairytale;
      String imgStr = str[1]; // 달리한테 보내줄 이미지 설명 저장
      String fairytaleKor =
          await _araiService.translateText(fairytale);  // 동화 번역하기




      askToDalle(imgStr); // 달리로 이미지 경로 생성

      // 확인
      print("동화:" + fairytale);
      print("동화 해석:" + fairytaleKor);
      print("이미지 설명:" + imgStr);


      // 동화 객체 만들기
      ft = FairyTale(fairytale, fairytaleKor, "", widget.word);

      // 이미지 없는 동화 먼저 저장
      final response = await http.post(
        Uri.parse("https://j8a401.p.ssafy.io/api/v1/ai-tales"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          "contentEng": ft.contentEng,
          "contentKor": ft.contentKor,
          "image": ft.image,
          "word": ft.wordEng
        }),
      );

      print(response.body.toString());
      print(jsonDecode(utf8.decode(response.bodyBytes))['result']['errorCode']);

      aiTaleId = jsonDecode(utf8.decode(response.bodyBytes))['result']
          ['aiTaleId'] as int; // 결과 확인하고 ai tale id 뽑아쓰기


    }

    return ft;



    // 동화를 반환
  }

  Future<bool> putImage(String url) async {
    // 토큰 뽑기
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();

    final response = await http.put(
      Uri.parse("https://j8a401.p.ssafy.io/api/v1/ai-tales/$aiTaleId"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        "image": url,
      }),
    );

    print("put 요청 결과:" + response.body.toString());

    return true;
  }

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/main/bg-main3.png'), // 배경 이미지
        ),
      ),
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: FutureBuilder(
                  future: myFuture,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    //error가 발생하게 될 경우 반환하게 되는 부분
                    if (snapshot.hasError) {
                      return Center(
                        child:
                            Text("에러가 발생했습니다. 앱을 다시 실행해주세요. ${snapshot.error}"),
                      );
                    }
                    //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                    else if (snapshot.hasData == false) {
                      return const Center(child: LoadingDialogMS());
                    }
                    // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                    else {
                      FairyTale ft = snapshot.data as FairyTale;
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "멋진 동화",
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.amber),
                                  ),
                                  Text(
                                    "가",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ],
                              ),
                              const Text(
                                "완성되었습니다!",
                                style: TextStyle(fontSize: 30),
                              ),


                              Container(
                                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                                margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.1, MediaQuery.of(context).size.width * 0.03, MediaQuery.of(context).size.width * 0.1, MediaQuery.of(context).size.width * 0.05),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                    border: Border.all(color: Colors.amber, width: 5),
                                  borderRadius: BorderRadius.circular(30.0)
                                ),

                                  child: Text(ft.contentEng.split('\n')[2], textAlign: TextAlign.justify)),
                              if (!selectReady)
                                Text("곧 동화 표지 화면이 표시됩니다. 잠시만 기다려주세요.", style: TextStyle(fontSize: 15)),
                              if (selectReady)
                                Column(
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.02,
                                    ),
                                    const Text("원하는 동화 표지를 선택해주세요.",
                                        style: TextStyle(fontSize: 24)),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.02,
                                    ),
                                    CarouselSlider(
                                      options: CarouselOptions(
                                          aspectRatio: 2.0,
                                          enlargeCenterPage: true,
                                          enableInfiniteScroll: false,
                                          initialPage: 0,
                                          autoPlay: false,
                                          onPageChanged: (index, reason) {
                                            // setState(() {
                                            _current = index;
                                            // });
                                          }),
                                      items: imgList
                                          .map((item) => Container(
                                        margin: const EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                            border: Border.all(color: Colors.amber, width: 5)
                                        ),
                                        child: ClipRRect(
                                            borderRadius:
                                            const BorderRadius.all(
                                                Radius.circular(30.0)),
                                            child: Stack(
                                              children: <Widget>[
                                                Image.network(item,
                                                    loadingBuilder: (context, child, loadingProgress) {
                                                      if (loadingProgress == null) return child;

                                                      return Center(child: Container(child: Center(child: CircularProgressIndicator()),height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.25, width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.25,));
                                                      // You can use LinearProgressIndicator, CircularProgressIndicator, or a GIF instead
                                                    },
                                                    fit: BoxFit.cover,
                                                    width: 1000.0),
                                                Positioned(
                                                  bottom: 0.0,
                                                  left: 0.0,
                                                  right: 0.0,
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 20.0),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ))
                                          .toList(),
                                    ),

                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.03,
                                    ),

                                    // Image.network(snapshot.data[1]),
                                    if(!isLoading)
                                    TextButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                          MaterialStateProperty.all(Colors.amber),
                                          foregroundColor:
                                          MaterialStateProperty.all(Colors.white),
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          selectedImg = imgList[_current];
                                          await putImage(selectedImg);
                                          setState(() {
                                            isLoading = false;
                                          }); // put
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CompleteStory(id: aiTaleId),
                                            ),
                                          );
                                        },


                                        child: const Text(
                                          "이 표지로 할래요",
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        )),
                                  ],
                                )


                            ],
                          ),
                          if (isLoading)
                            Positioned.fill(
                              child: Align(
                                  alignment: Alignment.center,
                                  child: LoadingDialogMS()),
                            )
                        ],
                      );
                    }
                  }),
            )),
      ),
    );
  }
}
