import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:snapstory/utilities/ar_helper.dart';

class ARViewIOS extends StatefulWidget {
  const ARViewIOS({Key? key}) : super(key: key);
  @override
  _ARViewIOSState createState() => _ARViewIOSState();
}

class _ARViewIOSState extends State<ARViewIOS> {
  late ARKitController arkitController;

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FIND WORD IOS'),
      ),
      body: Stack(
        children: [
          ARKitSceneView(onARKitViewCreated: onARKitViewCreated),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: MediaQuery.of(context).size.width * 0.1,
            child: DottedBorder(
              color: const Color.fromARGB(255, 0, 0, 0),
              //color of dotted/dash line
              strokeWidth: 3,
              //thickness of dash/dots
              dashPattern: [10, 6],
              //dash patterns, 10 is dash width, 6 is space width
              child: Container(
                //inner container
                  height: MediaQuery.of(context).size.height *
                      0.3, //height of inner container
                  width: MediaQuery.of(context).size.width *
                      0.8, //width to 100% match to parent container.
                  color: const Color.fromRGBO(
                      0, 0, 0, 0) //background color of inner container
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            final image = await arkitController.snapshot();
            // await Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => SnapshotPreview(
            //       imageProvider: image,
            //     ),
            //   ),
            // );
            MaterialPageRoute(
              builder: (context) => SnapshotPreview(imageProvider: image),
            );
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.add(createSphere());
  }
}

class SnapshotPreview extends StatelessWidget {
  const SnapshotPreview({
    Key? key,
    required this.imageProvider,
  }) : super(key: key);

  final ImageProvider imageProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Preview'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image(image: imageProvider),
        ],
      ),
    );
  }
}
