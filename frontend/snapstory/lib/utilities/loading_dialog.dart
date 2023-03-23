import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23),
          border: Border.all(
              width: 5, color: const Color(0xffFFCA10)),
          color: const Color(0xffFFF0BB),),
      height: MediaQuery.of(context).size.width * 0.8,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
        Row(mainAxisAlignment: MainAxisAlignment.center,children: [Image.asset('assets/snappy.png')]),
        const Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('잠시만 기다려주세요~', style: TextStyle(fontSize:  30),)],
        )
      ]),
    );
  }
}
