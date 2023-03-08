import 'package:snapstory/services/auth/auth_service.dart';
import 'package:snapstory/services/crud/notes_service.dart';
import 'package:flutter/material.dart';
import 'package:snapstory/views/onboarding.dart';

import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late final NotesService _notesService;

  String get userEmail => AuthService.firebase().currentUser!.email!;

  String get userName => AuthService.firebase().currentUser!.userName!;

  // navigation bar
  int selectedPos = 0;

  double bottomNavBarHeight = 70;

  List<TabItem> tabItems = List.of([
    TabItem(
      Icons.home,
      "홈",
      Colors.blue,
      labelStyle: TextStyle(
        fontWeight: FontWeight.normal,
      ),
    ),
    TabItem(
      Icons.library_books,
      "나만의 도서관",
      Colors.orange,
      labelStyle: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    TabItem(
      Icons.menu_book,
      "나만의 단어장",
      Colors.red,
      // circleStrokeColor: Colors.black,
    ),
  ]);

  late CircularBottomNavigationController _navigationController;

  Widget bodyContainer() {
    Color? selectedColor = tabItems[selectedPos].circleColor;
    String slogan;
    switch (selectedPos) {
      case 0:
        slogan = "주변 영단어 찾기, 손그림 퀴즈";
        break;
      case 1:
        slogan = "나만의 도서관";
        break;
      case 2:
        slogan = "나만의 단어장";
        break;
      default:
        slogan = "";
        break;
    }

    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: selectedColor,
        child: Center(
          child: Text(
            slogan,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
      onTap: () {
        if (_navigationController.value == tabItems.length - 1) {
          _navigationController.value = 0;
        } else {
          _navigationController.value = _navigationController.value! + 1;
        }
      },
    );
  }

  Widget bottomNav() {
    return CircularBottomNavigation(
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
      backgroundBoxShadow: <BoxShadow>[
        BoxShadow(color: Colors.black45, blurRadius: 10.0),
      ],
      animationDuration: Duration(milliseconds: 300),
      selectedCallback: (int? selectedPos) {
        setState(() {
          this.selectedPos = selectedPos ?? 0;
          print(_navigationController.value);
        });
      },
    );
  }
  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
    _navigationController = CircularBottomNavigationController(selectedPos);
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const OnBoardingPage()),
              );
            },
            icon: const Icon(Icons.help_outline),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logout();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('SIGN OUT'),
                ),
              ];
            },
          )
        ],
      ),
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
            ),
            accountName: Text('$userName 보호자님 안녕하세요.'),
            accountEmail: Text('bbanto@bbanto'),
            decoration: BoxDecoration(
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
            title: Text('소리설정'),
            onTap: () {
              print('소리설정 is clicked');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout_rounded,
              color: Colors.grey[850],
            ),
            title: Text('로그아웃/탈퇴'),
            onTap: () {
              print('로그아웃/탈퇴 is clicked');
            },
          )
        ],
      )),
      body: Stack(
        children: <Widget>[
          Padding(
            child: bodyContainer(),
            padding: EdgeInsets.only(bottom: bottomNavBarHeight),
          ),
          Align(alignment: Alignment.bottomCenter, child: bottomNav())
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
              child: const Text('CANCEL'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}
