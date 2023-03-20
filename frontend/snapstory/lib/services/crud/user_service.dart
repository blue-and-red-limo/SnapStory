import 'dart:convert';

import 'package:http/http.dart' as http;

class DBUser {
  final String email;
  final String name;
  final String uid;

  DBUser({required this.email, required this.name, required this.uid});

  DBUser.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        name = json['name'],
        uid = json['uid'];

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'uid': uid,
      };
}

class UserService {
  final String api = 'https://j8a401.p.ssafy.io/api/v1/users';

  Future<bool> createUser({required DBUser user}) async {
    final response = await http.post(
      Uri.parse(api),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteUser({required String token}) async {
    final response = await http.delete(
      Uri.parse(api),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body.toString());

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
