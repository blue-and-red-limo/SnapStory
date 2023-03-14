import 'package:firebase_auth/firebase_auth.dart';
import 'package:snapstory/services/auth/auth_service.dart';
import 'package:snapstory/services/crud/notes_service.dart';
import 'package:flutter/material.dart';
import 'package:snapstory/views/onboarding.dart';

import '../constants/routes.dart';
import '../enums/menu_action.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';

// 메인 탭 3개 페이지
import 'package:snapstory/views/home/home_view.dart';
import 'package:snapstory/views/my_library/my_library_view.dart';
import 'package:snapstory/views/my_word/my_word_view.dart';

// 나중에 지울 것
import 'package:snapstory/views/home/temp_button_view.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key, required this.selectedPage}) : super(key: key);
  final int selectedPage;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late final NotesService _notesService;
  late final TextEditingController _email;
  late final TextEditingController _password;

  // user 정보 받아오기
  String get userEmail => AuthService.firebase().currentUser!.email!;
  String get userName => AuthService.firebase().currentUser!.userName!;

  // navigation bar
  late int selectedPos;
  double bottomNavBarHeight = 70;

  final List<Widget> _children = [Home(), MyLibrary(), TempButton()]; // (Fix) 나중에 TempButton을 MyWord로 바꾸기

  // 메인 탭 3개 아이콘
  List<TabItem> tabItems = List.of([
    TabItem(
      Icons.home,
      "홈",
      const Color.fromRGBO(255, 182, 40, 1.0),
      labelStyle: const TextStyle(
        color: Colors.orange,
        fontWeight: FontWeight.bold,
      ),
    ),
    TabItem(
      Icons.library_books,
      "나만의 도서관",
      const Color.fromRGBO(255, 182, 40, 1.0),
      labelStyle: const TextStyle(
        color: Colors.orange,
        fontWeight: FontWeight.bold,
      ),
    ),
    TabItem(
      Icons.menu_book, "나만의 단어장", const Color.fromRGBO(255, 182, 40, 1.0),
      labelStyle: const TextStyle(
        color: Colors.orange,
        fontWeight: FontWeight.bold,
      ),
      // circleStrokeColor: Colors.black,
    ),
  ]);

  late CircularBottomNavigationController _navigationController;

  Widget bodyContainer() {
    return GestureDetector(
      child: _children.elementAt(selectedPos),
      // onTap: () {
      //   if (_navigationController.value == tabItems.length - 1) {
      //     _navigationController.value = 0;
      //   } else {
      //     _navigationController.value = _navigationController.value! + 1;
      //   }
      // },
    );
  }

  Widget bottomNav() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      child: CircularBottomNavigation(
        tabItems,
        controller: _navigationController,
        selectedPos: selectedPos,
        barHeight: bottomNavBarHeight,
        // use either barBackgroundColor or barBackgroundGradient to have a gradient on bar background
        barBackgroundColor: Colors.white,

        // barBackgroundGradient: LinearGradient(
        //   begin: Alignment.bottomCenter,
        //   end: Alignment.topCenter,
        //   colors: [
        //     Colors.blue,
        //     Colors.red,
        //   ],
        // ),
        backgroundBoxShadow: const <BoxShadow>[
          BoxShadow(color: Colors.black45, blurRadius: 10.0),
        ],
        animationDuration: const Duration(milliseconds: 300),
        selectedCallback: (int? selectedPos) {
          setState(() {
            this.selectedPos = selectedPos ?? 0;
            print(_navigationController.value);
          });
        },
      ),
    );
  }

  @override
  void initState() {
    _notesService = NotesService();
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
    selectedPos = widget.selectedPage;
    _navigationController = CircularBottomNavigationController(selectedPos);
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        )),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const OnBoardingPage()),
              );
            },
            icon: const Icon(Icons.help_outline),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
              ),
              accountName: Text('$userName 보호자님 안녕하세요.'),
              accountEmail: Text(userEmail),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 182, 40),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                  )),
            ),
            ListTile(
              leading: Icon(
                Icons.headphones,
                color: Colors.grey[850],
              ),
              title: const Text('소리설정'),
              onTap: () {
                print('소리설정 is clicked');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout_rounded,
                color: Colors.grey[850],
              ),
              title: const Text('로그아웃/탈퇴'),
              onTap: () async {
                print('로그아웃/탈퇴 is clicked');
                final shouldLogout = await showLogoutDialog(context);
                if (shouldLogout) {
                  await AuthService.firebase().logout();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (_) => false,
                  );
                } else {
                  final shouldDelete = await showDeleteDialog(context);
                  if(shouldDelete) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                          (_) => false,
                    );
                  }
                }
              },
            )
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: bottomNavBarHeight),
            child: bodyContainer(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: bottomNav(),
          )
        ],
      ),
    );
  }

  // FutureBuilder(
  //   future: _notesService.getOrCreateUser(email: userEmail),
  //   builder: (context, snapshot) {
  //     switch (snapshot.connectionState) {
  //       case ConnectionState.done:
  //         return StreamBuilder(
  //           stream: _notesService.allNotes,
  //           builder: (context, snapshot) {
  //             switch (snapshot.connectionState) {
  //               case ConnectionState.waiting:
  //               case ConnectionState.active:
  //                 return const Center(child: Text('WAITING FOR ALL NOTES'));
  //               default:
  //                 return const CircularProgressIndicator();
  //             }
  //           },
  //         );
  //       default:
  //         return const Center(child: CircularProgressIndicator());
  //     }
  //   },
  // ),

  Future<bool> showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('SIGN OUT'),
          content: const Text('YOU SURE YOU WANNA DELETE YOUR ACCOUNT'),
          actions: [
            TextField(controller: _email),
            TextField(controller: _password),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().deleteUser(email: _email.text, password: _password.text);
                Navigator.of(context).pop(true);
              },
              child: const Text('DELETE'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('CANCEL'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }

  Future<bool> showLogoutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('SIGN OUT'),
          content: const Text('YOU SURE YOU WANNA SIGN OUT'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('SIGN OUT'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}
