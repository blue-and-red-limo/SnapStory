import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:snapstory/main.dart';

// 앱 처음 시작할 때 튜토리얼 페이지
class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
            title: '',
            body: '안녕! 난 Snappy라고 해.\n'
                'Sna!p story에 온걸 환영해!',
            image: Image.asset('assets/tuto/(1)intro.gif'),
            decoration: getPageDecoration(),
        ),
        PageViewModel(
            title: '',
            body: '영어 단어로 알고 싶은 사물이 있다고?\n사진을 찍어서 나에게 물어봐!',
            image: Image.asset('assets/tuto/(2)aitale.gif'),
            decoration: getPageDecoration()
        ), PageViewModel(
            title: '',
            body: '찾은 단어로 나만의 동화책을 만들 수 있어.\n'
                '매일 새로운 동화가 가득해!',
            image: Image.asset('assets/tuto/(3)aitale.gif'),
            decoration: getPageDecoration()
        ),
        PageViewModel(
            title: '',
            body: '재밌는 그림 퀴즈도 준비했어.\n'
                '다 그리면 재밌는 동화가 나와!',
            image: Image.asset('assets/tuto/(4)quiztale.gif'),
            decoration: getPageDecoration()
        ),
        PageViewModel(
            title: '',
            body: '찾은 단어들은 단어장에서 다시 볼 수 있어! 나만의 동화책들은 도서관에서 볼 수 있지.\n\n자, 이제 동화를 만들러 가볼까?\n',
            image: Image.asset('assets/tuto/(5)my.gif'),
            decoration: getPageDecoration()
        ),

      ],
      done: const Text('done'),
      onDone: () {
        // 메인 페이지로 이동
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      },
      next: const Icon(Icons.arrow_forward),
      showSkipButton: true,
      skip: const Text('skip'),
      dotsDecorator: DotsDecorator(
          color: Colors.grey,
          size: const Size(6.5, 10),
          activeSize: const Size(22, 10),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24)
          ),
          activeColor: Colors.orange
      ),
      curve: Curves.bounceOut
      ,
    );
  }

  // IntroductionScreen 꾸미기
  PageDecoration getPageDecoration() {
    return const PageDecoration(
        titleTextStyle: TextStyle(
            fontSize: 0,
            // fontWeight: FontWeight.bold
        ),
        bodyTextStyle: TextStyle(
            fontSize: 20,
            color: Colors.green
        ),
        // imagePadding: EdgeInsets.only(top: 40),
        bodyAlignment: Alignment.topCenter,
        titlePadding: EdgeInsets.zero,
        bodyFlex: 5,
        imageAlignment: Alignment.bottomCenter,
      imagePadding: EdgeInsets.zero,
      bodyPadding: EdgeInsets.zero,
      imageFlex: 15, // 이미지 위치 조정
    );
  }
}
