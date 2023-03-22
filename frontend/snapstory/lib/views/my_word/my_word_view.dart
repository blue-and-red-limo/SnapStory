// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:snapstory/constants/routes.dart';
// import 'package:snapstory/services/auth/auth_service.dart';
// import 'package:snapstory/services/crud/notes_service.dart';
// import 'package:flutter/material.dart';
// import 'package:snapstory/services/crud/user_service.dart';
// import 'package:snapstory/utilities/show_error_dialog.dart';
// import 'package:snapstory/views/onboarding.dart';
//
// import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
// import 'package:circular_bottom_navigation/tab_item.dart';
//
// // 메인 탭 3개 페이지
// import 'package:snapstory/views/home/home_view.dart';
// import 'package:snapstory/views/my_library/my_library_view.dart';
// import 'package:snapstory/views/my_word/my_word_view.dart';
//
// // 나중에 지울 것
// import 'package:snapstory/views/home/temp_button_view.dart';
//
// class MyWord extends StatefulWidget {
//   const MyWord({Key? key}) : super(key: key);
//
//   @override
//   State<MyWord> createState() => _MyWordState();
// }
//
// class _MyWordState extends State<MyWord> {
//   late final TextEditingController _email;
//   late final TextEditingController _password;
//   late final UserService _userService;
//
//   // user 정보 받아오기
//   String get userEmail => AuthService.firebase().currentUser!.email!;
//   String get userName => AuthService.firebase().currentUser!.userName!;
//
//   // navigation bar
//   late int selectedPos = 2;
//   double bottomNavBarHeight = 70;
//
//   final List<Widget> _children = [Home(), MyLibrary(), MyWord()]; // (Fix) 나중에 TempButton을 MyWord로 바꾸기
//
//   // 메인 탭 3개 아이콘
//   List<TabItem> tabItems = List.of([
//     TabItem(
//       Icons.home,
//       "홈",
//       const Color.fromRGBO(255, 182, 40, 1.0),
//       labelStyle: const TextStyle(
//         color: Colors.orange,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     TabItem(
//       Icons.library_books,
//       "나만의 도서관",
//       const Color.fromRGBO(255, 182, 40, 1.0),
//       labelStyle: const TextStyle(
//         color: Colors.orange,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     TabItem(
//       Icons.menu_book, "나만의 단어장", const Color.fromRGBO(255, 182, 40, 1.0),
//       labelStyle: const TextStyle(
//         color: Colors.orange,
//         fontWeight: FontWeight.bold,
//       ),
//       // circleStrokeColor: Colors.black,
//     ),
//   ]);
//
//   late CircularBottomNavigationController _navigationController;
//
//   Widget bodyContainer() {
//     return GestureDetector(
//       child: _children.elementAt(selectedPos),
//       // onTap: () {
//       //   if (_navigationController.value == tabItems.length - 1) {
//       //     _navigationController.value = 0;
//       //   } else {
//       //     _navigationController.value = _navigationController.value! + 1;
//       //   }
//       // },
//     );
//   }
//
//   Widget bottomNav() {
//     return ClipRRect(
//       borderRadius: const BorderRadius.only(
//         topLeft: Radius.circular(40),
//         topRight: Radius.circular(40),
//       ),
//       child: CircularBottomNavigation(
//         tabItems,
//         controller: _navigationController,
//         selectedPos: selectedPos,
//         barHeight: bottomNavBarHeight,
//         // use either barBackgroundColor or barBackgroundGradient to have a gradient on bar background
//         barBackgroundColor: Colors.white,
//
//         // barBackgroundGradient: LinearGradient(
//         //   begin: Alignment.bottomCenter,
//         //   end: Alignment.topCenter,
//         //   colors: [
//         //     Colors.blue,
//         //     Colors.red,
//         //   ],
//         // ),
//         backgroundBoxShadow: const <BoxShadow>[
//           BoxShadow(color: Colors.black45, blurRadius: 10.0),
//         ],
//         animationDuration: const Duration(milliseconds: 300),
//         selectedCallback: (int? selectedPos) {
//           setState(() {
//             this.selectedPos = selectedPos ?? 0;
//             print(_navigationController.value);
//           });
//         },
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     _email = TextEditingController();
//     _password = TextEditingController();
//     _userService = UserService();
//     super.initState();
//     _navigationController = CircularBottomNavigationController(selectedPos);
//   }
//
//   @override
//   void dispose() {
//     _email.dispose();
//     _password.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.only(bottom: bottomNavBarHeight),
//             child: bodyContainer(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // FutureBuilder(
//   //   future: _notesService.getOrCreateUser(email: userEmail),
//   //   builder: (context, snapshot) {
//   //     switch (snapshot.connectionState) {
//   //       case ConnectionState.done:
//   //         return StreamBuilder(
//   //           stream: _notesService.allNotes,
//   //           builder: (context, snapshot) {
//   //             switch (snapshot.connectionState) {
//   //               case ConnectionState.waiting:
//   //               case ConnectionState.active:
//   //                 return const Center(child: Text('WAITING FOR ALL NOTES'));
//   //               default:
//   //                 return const CircularProgressIndicator();
//   //             }
//   //           },
//   //         );
//   //       default:
//   //         return const Center(child: CircularProgressIndicator());
//   //     }
//   //   },
//   // ),
//
//   Future<bool> showDeleteDialog(BuildContext context) {
//     return showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('SIGN OUT'),
//           content: const Text('YOU SURE YOU WANNA DELETE YOUR ACCOUNT'),
//           actions: [
//             TextField(controller: _email),
//             TextField(controller: _password),
//             TextButton(
//               onPressed: () async {
//                 bool result = await _userService.deleteUser(token: await FirebaseAuth.instance.currentUser!.getIdToken());
//                 if (!result) await showErrorDialog(context, "DB ERROR");
//                 await AuthService.firebase().deleteUser(email: _email.text, password: _password.text);
//                 Navigator.of(context).pop(true);
//               },
//               child: const Text('DELETE'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               },
//               child: const Text('CANCEL'),
//             ),
//           ],
//         );
//       },
//     ).then((value) => value ?? false);
//   }
//
//   Future<bool> showLogoutDialog(BuildContext context) {
//     return showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('SIGN OUT'),
//           content: const Text('YOU SURE YOU WANNA SIGN OUT'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(true);
//               },
//               child: const Text('SIGN OUT'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               },
//               child: const Text('DELETE'),
//             ),
//           ],
//         );
//       },
//     ).then((value) => value ?? false);
//   }
// }

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:snapstory/services/ar_ai_service.dart';

class MyWord extends StatefulWidget {
  const MyWord({Key? key}) : super(key: key);

  @override
  State<MyWord> createState() => _MyWordState();
}

class _MyWordState extends State<MyWord> {
  late ARAIService _araiService;
  late List wordList;
  late FlutterTts flutterTts;
  late int _current = 0;
  late bool isEng = true;

  @override
  void initState() {
    _araiService = ARAIService();
    flutterTts = FlutterTts();
    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.5); //speed of speech
    flutterTts.setVolume(1.0); //volume of speech
    flutterTts.setPitch(1); //pitc of sound
    super.initState();
  }

  Future<int> makeSound({required String text}) async {
    return await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: FirebaseAuth.instance.currentUser!.getIdToken(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder(
              future: _araiService.getWordList(token: snapshot.data as String),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  wordList = snapshot.data as List;
                  return Center(
                    child: CarouselSlider(
                      options: CarouselOptions(
                          height: MediaQuery.of(context).size.height * 0.6,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: true,
                          initialPage: 0,
                          autoPlay: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                              isEng = true;
                            });
                          }),
                      items: wordList
                          .map((e) => GestureDetector(
                                onTap: () => setState(() {
                                  isEng = !isEng;
                                }),
                                child: Card(
                                    elevation: 5.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(23)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            makeSound(
                                                text: e['wordExampleEng']
                                                    .toString());
                                          },
                                          icon: const Icon(
                                              Icons.volume_up_rounded),
                                          padding: const EdgeInsets.all(10),
                                          iconSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Image.asset(
                                            e['word']['image'].toString(),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: 
                                          Text(
                                            isEng
                                                ? e['word']['wordEng']
                                                : e['word']['wordKor'],
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.1),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(isEng
                                              ? e['wordExampleEng']
                                              : e['wordExampleKor']),
                                        ),
                                      ],
                                    )),
                              ))
                          .toList(),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
