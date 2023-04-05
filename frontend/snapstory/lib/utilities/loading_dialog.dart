import 'package:flutter/material.dart';
import 'package:outlined_text/outlined_text.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center,children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          [
            Image.asset('assets/snappee-waiting.gif', fit: BoxFit.fill,width: MediaQuery.of(context).size.width * 0.8, height: MediaQuery.of(context).size.width * 0.8,)
          ],
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedText(
              text: const Text(
                'Loading...',
                style:
                TextStyle(fontSize: 30, color: Colors.white),
              ),
              strokes: [
                OutlinedTextStroke(
                    color: Color(0xffffb628), width: 5),
              ])],
      )
    ]);
  }
}
