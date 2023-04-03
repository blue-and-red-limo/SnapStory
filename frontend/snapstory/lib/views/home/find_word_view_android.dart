import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/widgets/ar_view.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:native_screenshot/native_screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snapstory/services/ar_ai_service.dart';
import 'package:snapstory/utilities/loading_dialog.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

import 'package:screenshot/screenshot.dart';
import 'package:snapstory/views/home/make_story_view.dart';

import '../../constants/routes.dart';
import 'make_story_view.dart';

class ARViewAndroid extends StatefulWidget {
  const ARViewAndroid({Key? key}) : super(key: key);

  @override
  _ARViewAndroidState createState() => _ARViewAndroidState();
}

class _ARViewAndroidState extends State<ARViewAndroid> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARAnchorManager arAnchorManager;
  late ARLocationManager arLocationManager;

  ScreenshotController screenshotController = ScreenshotController();

  //String localObjectReference;
  ARNode? localObjectNode;

  //String webObjectReference;
  ARNode? webObjectNode;

  @override
  void dispose() {
    arSessionManager.dispose();
    super.dispose();
  }

  // 원래 있던거
  late bool checked = false;
  late FlutterTts flutterTts;
  late ARAIService _araiService;
  late bool isLoading = false;
  late String word;
  late Map wordMap;

  late bool exBtnTap = false;
  late bool exContainerTap = false;


  void showDialog() {
    setState(() {
      isLoading = true;
    });
  }

  void hideDialog() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    flutterTts = FlutterTts();
    _araiService = ARAIService();
    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.5); //speed of speech
    flutterTts.setVolume(1.0); //volume of speech
    flutterTts.setPitch(1.0); //pitc of sound

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      flutterTts.setSharedInstance(true);
    }
    super.initState();
  }

  Future<int> makeSound({required String text}) async {
    print("make Sound ${text}");
    return await flutterTts.speak(text);
  }

  // Vector3(-0.01, -0.01, -0.1)

  Vector3 addVector(Vector3 vector3) {
    print('addVector !!!!!!!');
    Vector3 addVector = Vector3(0, -0.05, -0.2);
    vector3.add(addVector);
    return vector3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          Screenshot(
            controller: screenshotController,
            child: ARView(
              onARViewCreated: onARViewCreated,
              planeDetectionConfig: PlaneDetectionConfig.none,
            ),
          ),
          if (!checked && !isLoading)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: MediaQuery.of(context).size.width * 0.1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("화면에 물체를 맞춰주세요!",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.03,
                          color: Colors.white)),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  IgnorePointer(
                    ignoring: true,
                    child: DottedBorder(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      //color of dotted/dash line
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(30),
                      strokeWidth: 4,
                      //thickness of dash/dots
                      dashPattern: const [10, 6],
                      //dash patterns, 10 is dash width, 6 is space width
                      child: Container(
                          //inner container
                          height: MediaQuery.of(context).size.height *
                              0.4, //height of inner container
                          width: MediaQuery.of(context).size.width *
                              0.8, //width to 100% match to parent container.
                          color: const Color.fromRGBO(
                              0, 0, 0, 0) //background color of inner container
                          ),
                    ),
                  ),
                ],
              ),
            ),
          Positioned(
            // 하단바
            top: MediaQuery.of(context).size.height * 0.9,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/main/bg-bar.png'),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
            ),
          ),
          if (exBtnTap && checked)
            GestureDetector(
              onTap: () => {
                exContainerTap = !exContainerTap,
                print(exContainerTap),
                setState(() {})
              },

              child: Positioned.fill(
                  // top: MediaQuery.of(context).size.height * 0.3,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.23, 0, 0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        // decoration: const BoxDecoration(
                        //   borderRadius: BorderRadius.only(
                        //     topLeft: Radius.circular(23),
                        //     topRight: Radius.circular(23),
                        //   ),
                        // ),
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.8,
                        // color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Center(
                            child: exContainerTap ? Text(wordMap['wordExampleKor'], style: TextStyle(fontSize: 20),) :Text(wordMap['wordExampleEng'], style: TextStyle(fontSize: 20),),
                          ),
                        ),
                      ),
                    ),
                  )),
            ),
          if (checked && !isLoading)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.8,
              left: MediaQuery.of(context).size.width * 0.05,
              // width: MediaQuery.of(context).size.width * 0.15,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async => {
                          await makeSound(text: wordMap['word']),
                          print(wordMap['word']),
                        },
                        child: Image.asset(
                          "assets/aiTale/btn-ai-word.png",
                          width: MediaQuery.of(context).size.width * 0.3,
                        ),
                      ),
                      GestureDetector(
                          onTap: () => {
                                makeSound(
                                    text: wordMap['wordExampleEng']
                                        .toString()),
                                exBtnTap = !exBtnTap,
                                setState(() {}),
                                print(exBtnTap),
                              },
                          child: Image.asset(
                            "assets/aiTale/btn-ai-example.png",
                            width: MediaQuery.of(context).size.width * 0.3,
                          )),
                      GestureDetector(
                          onTap: () => {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => MakeStory(word: word),
                                )),
                              },
                          child: Image.asset(
                            "assets/aiTale/btn-ai-story.png",
                            width: MediaQuery.of(context).size.width * 0.3,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.05,
              left: MediaQuery.of(context).size.width * 0.07,
              child: Image(
                image: AssetImage("assets/main/btn-help.png"),
                width: MediaQuery.of(context).size.width * 0.25,
              )),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.05,
              right: MediaQuery.of(context).size.width * 0.07,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Image(
                  image: AssetImage("assets/main/btn-quit.png"),
                  width: MediaQuery.of(context).size.width * 0.25,
                ),
              )),
          if (isLoading) const Center(child: LoadingDialog()),
        ],
      ),
      floatingActionButton: Visibility(
        visible: !checked,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.09,
          // width:  MediaQuery.of(context).size.height * 0.1,
          margin: EdgeInsets.fromLTRB(
              0.0, 0.0, 0.0, MediaQuery.of(context).size.height * 0.03),
          child: FittedBox(
            child: FloatingActionButton(
              elevation: 4,
              backgroundColor: const Color(0xFFFFFFFF),
              splashColor: const Color(0xffFFF0BB),

              child:
                  const Icon(Icons.camera, color: Color(0xFFFFB628), size: 37),
              // Provide an onPressed callback.
              onPressed: () async {
                arObjectManager.onInitialize();
                // arAnchorManager.initGoogleCloudAnchorMode();
                onWebObjectAtButtonPressed();
              },
            ),
          ),
        ),
      ),
    );
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;
    this.arLocationManager = arLocationManager;

    this.arSessionManager.onInitialize(
        showFeaturePoints: false,
        showPlanes: false,
        showWorldOrigin: false,
        handleTaps: true,
        showAnimatedGuide: false);
    this.arObjectManager.onInitialize();
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      this.arSessionManager.onPlaneOrPointTap = onPlaneOrPointTapped;
      this.arObjectManager.onNodeTap = (name) => onTapHandler(name[0]);
    } else {
      this.arObjectManager.onNodeTap = (name) => onTapHandler(name[0]);
    }
    this.arLocationManager.startLocationUpdates();
  }

  Future<void> onWebObjectAtButtonPressed() async {
    Matrix4 pos =
        await arSessionManager.getCameraPose().then((value) => value!);
    String wordName;
    if (defaultTargetPlatform == TargetPlatform.android) {
      final directory = (await getApplicationDocumentsDirectory())
          .path; //from path_provide package
      String fileName = '${DateTime.now().microsecondsSinceEpoch}.png';
      print(directory + fileName);

      await screenshotController
          .capture(delay: const Duration(milliseconds: 10))
          .then((image) async {
        if (image != null) {
          final imagePath = await File('$directory/$fileName').create();
          await imagePath.writeAsBytes(image);
        }
      });
      setState(() {
        isLoading = true;
      });
      wordName = await _araiService.postPictureAndGetWord(
          path: '$directory/$fileName'!);
    } else {
      String? path = await NativeScreenshot.takeScreenshot();
      setState(() {
        isLoading = true;
      });
      wordName = await _araiService.postPictureAndGetWord(path: path!);
    }
    // ai 서버에서 정보 받아오기
    // String wordName = await _araiService.postPictureAndGetWord(path: '$directory/$fileName'!);
    // wordName = wordName.substring(1, wordName.length - 1);
    print('wordname: $wordName');
    word = wordName;

    if(wordName == "CANNOT GET WORD"){
      print("errrrrrrorooorrrrr!!!!!!!!!!!!!!!!!!!!!!");
    } else {
      var map = await _araiService.generateText(
          obj: wordName,
          token: await FirebaseAuth.instance.currentUser!.getIdToken());
      setState(() {
        wordMap = map;
      });
      print(wordMap.toString());

      if (webObjectNode != null) {
        arObjectManager.removeNode(webObjectNode!);
        webObjectNode = null;
      }

      String nodeUrl =
          "https://snapstory401.s3.ap-northeast-2.amazonaws.com/models/${wordName}.glb";
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        nodeUrl =
        "https://snapstory401.s3.ap-northeast-2.amazonaws.com/models/${wordName}_ios.glb";
      }
      var newNode = ARNode(
        name: wordName,
        type: NodeType.webGLB,
        uri: nodeUrl,
        scale: Vector3(0.1, 0.1, 0.5),
        transformation: pos,
      );
      bool? didAddWebNode = await arObjectManager.addNode(newNode);
      print("nnnnnnnnnnnnnnnnnnnnnnnoooooooooooooooddddddddddeeeeee" +
          didAddWebNode.toString());
      webObjectNode = (didAddWebNode!) ? newNode : null;

    }
      setState(() {
        isLoading = false;
      });

  }

  void onTapHandler(String name) {
    print("먀먀먀먀ㅑ먐갹먁ㅁ갸!!!!" + name);
    checked == true ? checked = false : checked = true;
    setState(() {});
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    if (webObjectNode != null) {
      onTapHandler(word);
    }
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
