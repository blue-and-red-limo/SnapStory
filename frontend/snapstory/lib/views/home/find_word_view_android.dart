import 'dart:io';

import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/widgets/ar_view.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:native_screenshot/native_screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snapstory/services/ar_ai_service.dart';
import 'package:snapstory/utilities/show_error_dialog.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

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

  @override
  void initState() {
    flutterTts = FlutterTts();
    _araiService = ARAIService();
    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.5); //speed of speech
    flutterTts.setVolume(1.0); //volume of speech
    flutterTts.setPitch(1); //pitc of sound
    super.initState();
  }

  Future<int> makeSound({required String text}) async {
    return await flutterTts.speak("Hello World, this is Flutter Campus.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          if (!checked)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left: MediaQuery.of(context).size.width * 0.1,
              child: IgnorePointer(
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
                          0.6, //height of inner container
                      width: MediaQuery.of(context).size.width *
                          0.8, //width to 100% match to parent container.
                      color: const Color.fromRGBO(
                          0, 0, 0, 0) //background color of inner container
                      ),
                ),
              ),
            ),
          if (checked)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.58,
              left: MediaQuery.of(context).size.width * 0.1,
              // width: MediaQuery.of(context).size.width * 0.15,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async => await makeSound(text: 'text'),
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.35,
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(23),
                              border: Border.all(
                                  width: 5, color: const Color(0xff1FD901)),
                              color: const Color(0xffC7FCBE),
                            ),
                            child: const Center(
                                child: Text('단어듣기',
                                    style: TextStyle(fontSize: 20)))),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.35,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(23),
                          border: Border.all(
                              width: 5, color: const Color(0xff00B2FF)),
                          color: const Color(0xffB5FAFE),
                        ),
                        child: const Center(
                            child:
                                Text('문장듣기', style: TextStyle(fontSize: 20))),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.35,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(23),
                          border: Border.all(
                              width: 5, color: const Color(0xffFF93AD)),
                          color: const Color(0xffFFCBE7),
                        ),
                        child: const Center(
                            child:
                                Text('설명듣기', style: TextStyle(fontSize: 20))),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.35,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(23),
                          border: Border.all(
                              width: 5, color: const Color(0xffFFCA10)),
                          color: const Color(0xffFFF0BB),
                        ),
                        child: const Center(
                            child:
                                Text('동화만들기', style: TextStyle(fontSize: 20))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.9,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                ),
                color: Color(0xFFFFB628),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.05,
            left: MediaQuery.of(context).size.width * 0.8,
            child: IconButton(
              alignment: Alignment.bottomRight,
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.exit_to_app_outlined),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        height: MediaQuery.of(context).size.height * 0.09,
        // width:  MediaQuery.of(context).size.height * 0.1,
        margin: EdgeInsets.fromLTRB(
            0.0, 0.0, 0.0, MediaQuery.of(context).size.height * 0.03),
        child: FittedBox(
          child: FloatingActionButton(
            elevation: 4,
            backgroundColor: const Color(0xFFFFFFFF),
            splashColor: const Color(0xffFFF0BB),

            child: const Icon(Icons.camera, color: Color(0xFFFFB628), size: 37),
            // Provide an onPressed callback.
            onPressed: () async {
              // 초기화

              onWebObjectAtButtonPressed();
            },
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

    this.arSessionManager.onInitialize(
        showFeaturePoints: false,
        showPlanes: false,
        showWorldOrigin: false,
        handleTaps: false,
        showAnimatedGuide: false);
    this.arObjectManager.onInitialize();
    this.arObjectManager.onNodeTap = (name) => onTapHandler(name[0]);
  }

  Future<void> onWebObjectAtButtonPressed() async {

    // ai 서버에서 정보 받아오기
    String? path = await NativeScreenshot.takeScreenshot();
    String wordName = await _araiService.postPictureAndGetWord(path: path!);
    wordName = wordName.substring(1, wordName.length - 1);
    print(wordName);

    if (webObjectNode != null) {
      arObjectManager.removeNode(webObjectNode!);
      webObjectNode = null;
    }

    var newNode = ARNode(
      name: wordName,
      type: NodeType.webGLB,
      uri:
          "https://snapstory401.s3.ap-northeast-2.amazonaws.com/models/$wordName.glb",
      scale: Vector3(0.1, 0.1, 0.5),
      position: Vector3(-0.01, -0.01, -0.1),
    );

    bool? didAddWebNode = await arObjectManager.addNode(newNode);
    webObjectNode = (didAddWebNode!) ? newNode : null;
  }

  void onTapHandler(String name) {
    checked == true ? checked = false : checked = true;
    setState(() {});
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