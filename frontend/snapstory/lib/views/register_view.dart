import 'package:firebase_auth/firebase_auth.dart';
import 'package:snapstory/constants/routes.dart';
import 'package:snapstory/services/auth/auth_service.dart';
import 'package:snapstory/services/crud/user_service.dart';
import 'package:snapstory/utilities/show_error_dialog.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_exceptions.dart';

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
      appBar: AppBar(
        title: const Text('REGISTER'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "ENTER EMAIL"),
          ),
          TextField(
            controller: _userName,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(hintText: "ENTER NAME"),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: "ENTER PASSWORD"),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final userName = _userName.text;
              final password = _password.text;
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  userName: userName,
                  password: password,
                );
                await AuthService.firebase().login(email: email, password: password);
                final usr = FirebaseAuth.instance.currentUser;
                bool result = await _userService.createUser(user: DBUser(email: email, name: userName, uid: usr!.uid));
                if (!result) {
                  await showErrorDialog(context, 'DB ERROR');
                } else {
                  await showErrorDialog(context, 'SUCCEED');
                }
                await AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  'WEAK PASSWORD',
                );
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                  context,
                  'EMAIL ALREADY IN USE',
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  'INVALID EMAIL',
                );
              }
            },
            child: const Text('REGISTER'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('SIGN IN'),
          )
        ],
      ),
    );
  }
}
