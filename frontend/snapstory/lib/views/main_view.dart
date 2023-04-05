import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snapstory/services/auth/auth_service.dart';
import 'package:snapstory/services/crud/user_service.dart';
import 'package:snapstory/utilities/show_error_dialog.dart';

// 메인 탭 3개 페이지
import 'package:snapstory/views/home/home_view.dart';
import 'package:snapstory/views/my_library/my_library_view.dart';
import 'package:snapstory/views/my_word/my_word_view.dart';
import 'package:snapstory/views/onboarding.dart';

import '../constants/routes.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key, required this.selectedPage}) : super(key: key);
  final int selectedPage;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final UserService _userService;

  // user 정보 받아오기
  String get userEmail => AuthService.firebase().currentUser!.email!;

  String get userName => AuthService.firebase().currentUser!.userName!;

  // navigation bar
  late int selectedPos;
  double bottomNavBarHeight = 70;

  final List<Widget> _children = [
    const Home(),
    const MyLibrary(),
    const MyWord()
  ]; // (Fix) 나중에 TempButton을 MyWord로 바꾸기

  // 메인 탭 3개 아이콘
  List<TabItem> tabItems = List.of([
    TabItem(
      Icons.home,
      "홈",
      const Color.fromRGBO(255, 182, 40, 1.0),
      labelStyle: const TextStyle(
        color: Colors.orange,
        fontWeight: FontWeight.normal,
      ),
    ),
    TabItem(
      Icons.menu_book,
      "나만의 도서관",
      const Color.fromRGBO(255, 182, 40, 1.0),
      labelStyle: const TextStyle(
        color: Colors.orange,
        fontWeight: FontWeight.normal,
      ),
    ),
    TabItem(
      Icons.spellcheck, "나만의 단어장", const Color.fromRGBO(255, 182, 40, 1.0),
      labelStyle: const TextStyle(
        color: Colors.orange,
        fontWeight: FontWeight.normal,
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
    _email = TextEditingController();
    _password = TextEditingController();
    _userService = UserService();
    super.initState();
    selectedPos = widget.selectedPage;
    _navigationController = CircularBottomNavigationController(selectedPos);
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(23),
        // color: const Color(0xffffdb1f),
        image: DecorationImage(
            fit: BoxFit.cover,
            image: selectedPos != 0
                ? const AssetImage('assets/main/bg-main3.png')
                : const AssetImage('assets/main/bg-main.png') // 배경 이미지
            ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
              image: DecorationImage(
                image: AssetImage('assets/main/bg-bar.png'),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(44),
          )),
          actions: [
            IconButton(
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //       builder: (context) => const OnBoardingPage()),
                // );
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
                accountName: Text('Hello $userName '),
                accountEmail: Text(userEmail),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/main/bg-bar.png'),
                        fit: BoxFit.fill),
                    color: Color.fromARGB(255, 255, 182, 40),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                    )),
              ),
              ListTile(
                leading: Icon(
                  Icons.help_outline,
                  color: Colors.grey[850],
                ),
                title: const Text('튜토리얼 다시보기'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const OnBoardingPage()),
                  );
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
                    if (shouldDelete) {
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
        body: SafeArea(
          child: Stack(
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
        ),
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
          title: const Text('탈퇴하기'),
          content: const Text('이메일과 비밀번호를 입력해주세요.'),
          actions: [
            TextField(controller: _email),
            TextField(
              controller: _password,
              obscureText: true,
            ),
            TextButton(
              onPressed: () async {
                bool result = await _userService.deleteUser(
                    token:
                        await FirebaseAuth.instance.currentUser!.getIdToken());
                if (!result) await showErrorDialog(context, "DB ERROR");
                await AuthService.firebase()
                    .deleteUser(email: _email.text, password: _password.text);
                Navigator.of(context).pop(true);
              },
              child: const Text('탈퇴하기'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('돌아가기'),
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
          title: const Text('로그아웃'),
          content: const Text('로그아웃하시겠습니까 ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('로그아웃'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('탈퇴하기'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}
