import 'package:firebase_auth/firebase_auth.dart';
import 'package:snapstory/constants/routes.dart';
import 'package:snapstory/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:snapstory/views/login_view.dart';

import '../services/crud/user_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.send,
            color: Colors.orange,
            size: 100,
          ),
          SizedBox(
            height: 15,
          ),
          const Text(
            "인증링크를 전송했습니다.",
            style: TextStyle(fontSize: 30, color: Colors.orange),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "메일함에서 인증 링크를 눌러\n인증을 완료해주세요.",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("이메일을 받지 못했다면?",
                  style: TextStyle(fontSize: 15, color: Colors.grey)),
              SizedBox(width: 10),
              TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all((RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Color.fromARGB(255, 255, 182, 40),
                            width: 2.5),
                        borderRadius: BorderRadius.circular(5)))),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    foregroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 255, 182, 40)),
                  ),
                  onPressed: () async {
                    await AuthService.firebase().sendEmailVerification();
                  },
                  child: const Text('인증링크 재전송',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal))),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          SizedBox(
            height: 60,
            width: 250,
            child: TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all((RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white, width: 2.5),
                  borderRadius: BorderRadius.circular(50),
                ))),
                backgroundColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 255, 182, 40)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () async {
                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('SnapStory 시작하기',
                  style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
            ),
          )
        ],
      ),
    ));
  }
}
