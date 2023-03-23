import 'package:snapstory/constants/routes.dart';
import 'package:snapstory/services/auth/auth_service.dart';
import 'package:snapstory/services/crud/user_service.dart';
import 'package:snapstory/views/home/find_word_view_android.dart';
import 'package:snapstory/views/home/find_word_view_ios.dart';
import 'package:snapstory/views/home/home_view.dart';
import 'package:snapstory/views/login_view.dart';
import 'package:snapstory/views/main_view.dart';
import 'package:snapstory/views/register_view.dart';
import 'package:snapstory/views/verify_email_view.dart';
import 'package:snapstory/views/drawing_quiz/drawing_tale_list.dart';
import 'package:flutter/material.dart';

import 'views/onboarding.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'SNAP STORY',
      theme: ThemeData(
        fontFamily: 'ONE Mobile POP',
        primarySwatch:
            ColorService.createMaterialColor(const Color(0xFFFFB628)),
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        mainRoute: (context) => const MainView(selectedPage: 0),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        iOSRoute: (context) => const ARViewIOS(),
        androidRoute: (context) => const ARViewAndroid(),
        homeRoute: (context) => const Home(),
        drawingTaleListRoute: (context) => const DrawingTaleList(),
      },
    ),
  );
}

// 커스텀 색상 만드는 클래스
class ColorService {
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    final Map<int, Color> data = Map.from(swatch);
    return MaterialColor(color.value, data);
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const MainView(selectedPage: 0);
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
