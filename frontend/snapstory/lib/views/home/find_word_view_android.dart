import 'dart:io';

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:native_screenshot/native_screenshot.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class ARViewAndroid extends StatefulWidget {
  const ARViewAndroid({Key? key}) : super(key: key);

  @override
  _ARViewAndroidState createState() => _ARViewAndroidState();
}

class _ARViewAndroidState extends State<ARViewAndroid> {
  late ArCoreController arCoreController;
  late bool checked = false;
  late FlutterTts flutterTts;

  @override
  void initState() {
    flutterTts = FlutterTts();
    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.5); //speed of speech
    flutterTts.setVolume(1.0); //volume of speech
    flutterTts.setPitch(1); //pitc of sound
    super.initState();
  }

  Future<int> makeSound({required String text})async {
    return await flutterTts.speak("Hello World, this is Flutter Campus.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          ArCoreView(
            onArCoreViewCreated: _onArCoreViewCreated,
            enableTapRecognizer: true,
          ),
          if (!checked)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left: MediaQuery.of(context).size.width * 0.1,
              child: IgnorePointer(
                ignoring: true,
                child: DottedBorder(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  //color of dotted/dash line
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(30),
                  strokeWidth: 2,
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
              top: MediaQuery.of(context).size.height * 0.6,
              left: MediaQuery.of(context).size.width * 0.15,
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async => await makeSound(text: 'text'),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.3,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(23),
                            color: const Color(0xffffdb1f),
                          ),
                          child: const Center(child: Text('1')),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.3,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(23),
                          color: const Color(0xff86EC62),
                        ),
                        child: const Center(child: Text('2')),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.3,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(23),
                          color: const Color(0xff86EC62),
                        ),
                        child: const Center(child: Text('3')),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.3,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(23),
                          color: const Color(0xffffdb1f),
                        ),
                        child: const Center(child: Text('4')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.85,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                ),
                color: Color(0xFFFFB628),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.15,
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt), // Provide an onPressed callback.
        onPressed: () async {
          String? path = await NativeScreenshot.takeScreenshot();
          _addSphere(arCoreController);
        },
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController?.onNodeTap = (name) => onTapHandler(name);

    // _addSphere(arCoreController);
    // _addCylindre(arCoreController);
    // _addCube(arCoreController);
  }

  void _addNode(ArCoreController controller, String name) {
    final material =
        ArCoreMaterial(color: const Color.fromARGB(120, 66, 134, 244));
    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.1,
    );
    final node = ArCoreNode(
      name: name,
      shape: sphere,
      position: Vector3(0, 0, 1),
    );
    controller.addArCoreNode(node);
  }

  void _addSphere(ArCoreController controller) {
    final material =
        ArCoreMaterial(color: const Color.fromARGB(120, 66, 134, 244));
    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.1,
    );
    final node = ArCoreNode(
      name: 'sphere',
      shape: sphere,
      position: Vector3(0, 0, -1.5),
    );
    controller.addArCoreNode(node);
  }

  void _addCylindre(ArCoreController controller) {
    final material = ArCoreMaterial(
      color: const Color.fromRGBO(10, 10, 10, 10),
      reflectance: 1.0,
    );
    final cylindre = ArCoreCylinder(
      materials: [material],
      radius: 0.5,
      height: 0.3,
    );
    final node = ArCoreNode(
      name: 'cylindre',
      shape: cylindre,
      position: Vector3(0.0, -0.5, -2.0),
    );
    controller.addArCoreNode(node);
  }

  void _addCube(ArCoreController controller) {
    final material = ArCoreMaterial(
      color: const Color.fromARGB(120, 66, 134, 244),
      metallic: 1.0,
    );
    final cube = ArCoreCube(
      materials: [material],
      size: Vector3(0.5, 0.5, 0.5),
    );
    final node = ArCoreNode(
      name: 'cube',
      shape: cube,
      position: Vector3(-0.5, 0.5, -3.5),
    );
    controller.addArCoreNode(node);
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  void onTapHandler(String name) {
    checked == true ? checked = false : checked = true;
    // showDialog<void>(
    //   context: context,
    //   builder: (BuildContext context) =>
    //       AlertDialog(content: Text('onNodeTap on $name')),
    // );
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
