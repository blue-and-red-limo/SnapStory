import 'package:firebase_auth/firebase_auth.dart';
import 'package:snapstory/constants/routes.dart';
import 'package:snapstory/services/auth/auth_service.dart';
import 'package:snapstory/services/crud/user_service.dart';
import 'package:snapstory/utilities/show_error_dialog.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_exceptions.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _userName;
  late final UserService _userService;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _userName = TextEditingController();
    _userService = UserService();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _userName.dispose();
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

                  const SizedBox( // margin용 sized box
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
                          borderSide: const BorderSide(color: Colors.lightGreenAccent),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 255, 182, 40)),
                          borderRadius: BorderRadius.circular(50.0),
                        ),

                        hintText: "이메일을 입력해주세요.",
                        hintStyle: const TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 217, 217, 217),
                          fontWeight: FontWeight.normal,
                        ),
                        filled: true, //<-- SEE HERE
                        fillColor: Colors.white, //<-- SEE HERE
                      ),
                    ),
                  ),

                  const SizedBox( // margin용 sized box
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
                          borderSide: const BorderSide(color: Colors.lightGreenAccent),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 255, 182, 40)),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        hintText: "비밀번호를 입력해주세요.",
                        hintStyle: const TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 217, 217, 217),
                          fontWeight: FontWeight.normal,
                        ),
                        filled: true, //<-- SEE HERE
                        fillColor: Colors.white,

                      ),
                    ),
                  ),

                  const SizedBox( // margin용 sized box
                    height: 3,
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
                          borderSide: const BorderSide(color: Colors.lightGreenAccent),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 255, 182, 40)),
                          borderRadius: BorderRadius.circular(50.0),
                        ),

                        hintText: "아이의 이름을 입력해주세요.",
                        hintStyle: const TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 217, 217, 217),
                          fontWeight: FontWeight.normal,
                        ),
                        filled: true, //<-- SEE HERE
                        fillColor: Colors.white, //<-- SEE HERE
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    width: 270,
                    height: 50,
                    child: TextButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all((RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Colors.white,
                              width: 2.5
                          ),
                          borderRadius: BorderRadius.circular(50),

                        ))),
                        backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 255, 182, 40)),
                        foregroundColor: MaterialStateProperty.all(Colors.white),

                      ),

                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          registerRoute,
                              (route) => false,
                        );
                      },
                      child: const Text('회원가입', style: TextStyle(fontSize: 23, fontWeight: FontWeight.normal)),
                    ),
                  ),
                  Align(
                      alignment: const Alignment(0.5, 0.0),
                      child: SizedBox(
                        height: 35,
                        child: TextButton(
                          style: ButtonStyle(

                            backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 255, 182, 40)),
                            foregroundColor: MaterialStateProperty.all(Colors.white),

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
            )
        )
    );
  }
}
