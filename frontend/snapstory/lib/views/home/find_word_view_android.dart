import 'dart:io';

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:native_screenshot/native_screenshot.dart';
import 'package:vector_math/vector_math_64.dart';

class ARViewAndroid extends StatefulWidget {
  const ARViewAndroid({Key? key}) : super(key: key);

  @override
  _ARViewAndroidState createState() => _ARViewAndroidState();
}

class _ARViewAndroidState extends State<ARViewAndroid> {
  late ArCoreController arCoreController;
  late bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ANDROID'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
      ),
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
                  dashPattern: [10, 6],
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
          if (checked) const Text('TAP'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt), // Provide an onPressed callback.
        onPressed: () async {
          String? path = await NativeScreenshot.takeScreenshot();
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DisplayPictureScreen(
                // Pass the automatically generated path to
                // the DisplayPictureScreen widget.
                imagePath: path!,
              ),
            ),
          );
        },
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController?.onNodeTap = (name) => onTapHandler(name);

    _addSphere(arCoreController);
    _addCylindre(arCoreController);
    _addCube(arCoreController);
  }

  void _addSphere(ArCoreController controller) {
    final material = ArCoreMaterial(color: Color.fromARGB(120, 66, 134, 244));
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
      color: Color.fromARGB(120, 66, 134, 244),
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

  void _addText(ArCoreController controller) {
    final material = ArCoreMaterial(
      color: Color.fromARGB(120, 66, 134, 244),
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
