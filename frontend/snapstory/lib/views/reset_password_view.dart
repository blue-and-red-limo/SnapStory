import 'package:flutter/material.dart';
import 'package:snapstory/views/login_view.dart';

import '../services/auth/auth_exceptions.dart';
import '../services/auth/auth_service.dart';
import '../utilities/show_error_dialog.dart';


class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late final TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "비밀번호를 초기화하려면 \n 이메일을 입력해주세요.",
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 270,
              child: TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.lightGreenAccent),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 255, 182, 40)),
                    borderRadius: BorderRadius.circular(50.0),
                  ),

                  hintText: "이메일을 입력해주세요.",
                  hintStyle: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 217, 217, 217),
                    fontWeight: FontWeight.normal,
                  ),
                  filled: true,
                  //<-- SEE HERE
                  fillColor: Colors.white, //<-- SEE HERE
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 270,
              height: 60,
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
                  final email = _email.text;
                  try {
                    await AuthService.firebase()
                        .sendPasswordResetEmail(email: email);
                    showDialog(
                        context: context,
                        builder: (BuildContext ctx) {
                          return AlertDialog(
                            content: Text("입력하신 이메일로 \n 비밀번호 초기화 메일을 보냈습니다."),
                            actions: [
                              TextButton(
                                  onPressed: () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginView()),
                                    ),
                                  },
                                  child: Text("확인"))
                            ],
                          );
                        });
                  } catch (e) {
                    await showErrorDialog(
                          context,
                          '이메일 형식이 맞지 않습니다.',
                    );
                    // showErrorDialog(context, text)
                    // showDialog(
                    //     context: context,
                    //     builder: (BuildContext ctx) {
                    //       return AlertDialog(
                    //         content: const Text("이메일 형식이 맞지 않습니다."),
                    //         actions: [
                    //           TextButton(
                    //               onPressed: () => {
                    //                 Navigator.push(
                    //                   context,
                    //                   MaterialPageRoute(
                    //                       builder: (context) => LoginView()),
                    //                 ),
                    //               },
                    //               child: Text("확인"))
                    //         ],
                    //       );
                    //     });
                  }
                  on InvalidEmailAuthException {
                    showDialog(
                        context: context,
                        builder: (BuildContext ctx) {
                          return AlertDialog(
                            content: Text("이메일 형식 안ㅁㅈ맞움"),
                            actions: [
                              TextButton(
                                  onPressed: () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginView()),
                                    ),
                                  },
                                  child: Text("확인"))
                            ],
                          );
                        });


                  }
                  on GenericAuthException {
                    await showErrorDialog(
                      context,
                      'ERROR',
                    );
                  }
                },
                child: const Text('이메일 초기화',
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
              ),
            ),
            Align(
                alignment: const Alignment(0.5, 0.0),
                child: SizedBox(
                  height: 35,
                  child: TextButton(
                    style: ButtonStyle(


                      foregroundColor: MaterialStateProperty.all(Colors.black),

                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const LoginView()),
                      );
                    },
                    child: const Text('로그인 화면으로 돌아가기', style: TextStyle(fontWeight: FontWeight.normal),),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
