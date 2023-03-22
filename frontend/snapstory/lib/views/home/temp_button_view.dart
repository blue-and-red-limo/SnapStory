import 'package:flutter/material.dart';
import 'package:snapstory/views/home/make_story_view.dart';

// 카메라 화면에서 동화만들기 버튼 누르면 나올 부분
class TempButton extends StatefulWidget {
  const TempButton({Key? key}) : super(key: key);

  @override
  State<TempButton> createState() => _TempButtonState();
}

class _TempButtonState extends State<TempButton> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const MakeStory(
                          word: 'apple',
                        )),
              );
            },
            child: const Text("동화만들기")),
      ),
    );
  }
}
