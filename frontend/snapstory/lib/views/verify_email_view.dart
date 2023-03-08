import 'package:snapstory/constants/routes.dart';
import 'package:snapstory/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VERIFY EMAIL'),
      ),
      body: Column(
        children: [
          const Text(
              "WE'VE SENT YOU AN EMAIL VERIFICATION, PLZ CHECK YOUR EMAIL INBOX"),
          const Text("IF YOU'VE NOT GOT AN EMAIL VERIFICATION, TRY AGAIN HERE"),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            child: const Text('SEND EMAIL VERIFICATION'),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('RESTART'),
          )
        ],
      ),
    );
  }
}
