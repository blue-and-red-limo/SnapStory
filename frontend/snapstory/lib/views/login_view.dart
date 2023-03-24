import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snapstory/constants/routes.dart';
import 'package:snapstory/services/ar_ai_service.dart';
import 'package:snapstory/services/auth/auth_service.dart';
import 'package:snapstory/services/crud/user_service.dart';
import 'package:snapstory/views/onboarding.dart';
import 'package:snapstory/views/reset_password_view.dart';

import '../services/auth/auth_exceptions.dart';
import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final UserService _userService;
  late final ARAIService _araiService;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _userService = UserService();
    _araiService = ARAIService();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 182, 40),
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 120,
                child: Image.asset('assets/snappy.png'),
              ),
              const SizedBox(
                // margin용 sized box
                height: 40,
              ),
              SizedBox(
                width: 270.0,
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
                // margin용 sized box
                height: 3,
              ),
              SizedBox(
                width: 270.0,
                child: TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
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
                    hintText: "비밀번호를 입력해주세요.",
                    hintStyle: const TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 217, 217, 217),
                      fontWeight: FontWeight.normal,
                    ),
                    filled: true,
                    //<-- SEE HERE
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Align(
                  alignment: const Alignment(0.4, 0.0),
                  child: SizedBox(
                    height: 35,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 255, 182, 40)),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const ResetPassword()),
                        );
                      },
                      child: const Text(
                        '비밀번호를 잊었다면? 초기화하기',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ),
                  )),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: 270,
                height: 50,
                child: TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all((RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.white, width: 2.5),
                        borderRadius: BorderRadius.circular(50)))),
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 255, 182, 40)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      await AuthService.firebase().login(
                        email: email,
                        password: password,
                      );
                      final user = AuthService.firebase().currentUser;
                      print("==================asd===============");
                      print(await FirebaseAuth.instance.currentUser!.getIdToken());
                      if (user?.isEmailVerified ?? false) {
                        if (await _userService.createUser(
                                user: DBUser(
                                    email: email,
                                    name: user!.userName! ?? " ",
                                    uid: FirebaseAuth
                                        .instance.currentUser!.uid)) ==
                            true) {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const OnBoardingPage(),
                              ),
                              (route) => false);
                        } else {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            mainRoute,
                            (route) => false,
                          );
                        }
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          verifyEmailRoute,
                          (route) => false,
                        );
                      }
                    } on UserNotFoundAuthException {
                      await showErrorDialog(
                        context,
                        '사용자를 찾을 수 없습니다.',
                      );
                    } on WrongPasswordAuthException {
                      await showErrorDialog(
                        context,
                        '비밀번호가 틀렸습니다.',
                      );
                    } on GenericAuthException {
                      await showErrorDialog(
                        context,
                        'AUTH ERROR',
                      );
                    }
                  },
                  child: const Text('로그인',
                      style: TextStyle(
                          fontSize: 23, fontWeight: FontWeight.normal)),
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Align(
                  alignment: const Alignment(0.45, 0.0),
                  child: SizedBox(
                    height: 35,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 255, 182, 40)),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          registerRoute,
                          (route) => false,
                        );
                      },
                      child: const Text(
                        '계정이 없다면? 회원가입하기',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ),
                  )),
            ],
          ),
        )));
  }
}
