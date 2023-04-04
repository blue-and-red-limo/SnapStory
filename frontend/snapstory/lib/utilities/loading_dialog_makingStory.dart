import 'package:flutter/material.dart';
import 'package:outlined_text/outlined_text.dart';

class LoadingDialogMS extends StatelessWidget {
  const LoadingDialogMS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          width: 6,
          color: Colors.amber,
        ),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/snappee-waiting.gif',
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.width * 0.7,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedText(
                    text: const Text(
                      '동화를 만들고 있어요~',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    strokes: [
                      OutlinedTextStroke(color: Color(0xffffb628), width: 5),
                    ])
              ],
            )
          ]),
    );
  }
}
