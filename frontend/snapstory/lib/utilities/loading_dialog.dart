import 'package:flutter/material.dart';

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
      const Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('잠시만 기다려주세요~', style: TextStyle(fontSize:  30),)],
      )
    ]);
  }
}
