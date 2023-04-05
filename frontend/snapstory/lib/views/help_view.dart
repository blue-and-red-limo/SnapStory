
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

final List<List<Image>> tutorials = [
  [
    Image.asset('assets/tuto/help_0-1.png', fit: BoxFit.fill,)
  ],
  [],
  [],
  [],
  [],
];

// 앱 처음 시작할 때 튜토리얼 페이지
class HelpView extends StatelessWidget {
  final int index;

  const HelpView({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      rawPages:
        tutorials[index].toList(),
      done: const Text('done'),
      onDone: () {
        // 이전 페이지로 이동
        Navigator.of(context).pop();
      },
      next: const Icon(Icons.arrow_forward),
      showSkipButton: true,
      skip: const Text('skip'),
      dotsDecorator: DotsDecorator(
          color: Colors.grey,
          size: const Size(6.5, 10),
          activeSize: const Size(22, 10),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          activeColor: Colors.orange),
      curve: Curves.bounceOut,
    );
  }
}
