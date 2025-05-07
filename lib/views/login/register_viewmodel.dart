import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myrefectly/help/enum.dart';
import 'package:myrefectly/main.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/repository/api_service.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:http/http.dart' as http;
import 'package:restart_app/restart_app.dart';

class Register_Viewmodel extends ChangeNotifier {
  final String username;
  String email = "";
  String password = "";
  String retype_password = "";
  bool logging_in = false;
  int status_code = 0;
  late Repository<String, User> _repo;
  late User user;
  final apiService = ApiService(baseUrl: server_root_url + "/api/Account");
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  ActionStatus action = ActionStatus.waiting;
  Register_Viewmodel({required this.username}) {
    _init_data();
  }

  Future<void> _init_data() async {
    _repo = await Repository<String, User>(name: 'user_box');
    await _repo.init();
    user = await _repo.getAt(0);
    notifyListeners();
  }

  Future<int> request_register() async {
    logging_in = true;
    notifyListeners();
    if (!emailRegex.hasMatch(email) ||
        password.length < 8 ||
        password != retype_password) {
      logging_in = false;
      notifyListeners();
      return -1;
    }

    final response = await http.post(
      Uri.parse('${server_root_url}/api/Account/register'),
      headers: {
        'Content-Type':
            'application/json', // Đặt Content-Type là application/json
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      UserData userData = userDataFromJson(response.body);
      user.user_name = userData.user.username;
      user.email = userData.user.email;
      refresh_token = userData.refreshToken;
      user.refresh_token = userData.refreshToken;
      user.save();
      Future.delayed(
        Duration(seconds: 1),
        () {
          Restart.restartApp();
        },
      );
    } else if (response.statusCode == 400) {
      logging_in = false;
      action = ActionStatus.failure;
      notifyListeners();
      return -2;
    } else {
      logging_in = false;
      action = ActionStatus.failure;
      notifyListeners();
      return -1;
    }

    logging_in = false;

    notifyListeners();

    return 1;
  }
}
// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  String refreshToken;
  UserRS user;

  UserData({
    required this.refreshToken,
    required this.user,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        refreshToken: json["refreshToken"],
        user: UserRS.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "refreshToken": refreshToken,
        "user": user.toJson(),
      };
}

class UserRS {
  String id;
  String username;
  String email;
  dynamic avatar;

  UserRS({
    required this.id,
    required this.username,
    required this.email,
    required this.avatar,
  });

  factory UserRS.fromJson(Map<String, dynamic> json) => UserRS(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "avatar": avatar,
      };
}
