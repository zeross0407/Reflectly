import 'package:flutter/material.dart';
import 'package:myrefectly/help/enum.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entity.dart';

import 'package:http/http.dart' as http;

class ForgotPassword_Viewmodel extends ChangeNotifier {
  String email = "";

  String code = "";
  String new_password = "";
  String retype = "";
  bool requesting = false;
  int status_code = 0;
  late User user;
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  ActionStatus action = ActionStatus.waiting;
  ForgotPassword_Viewmodel() {
    _init_data();
  }

  Future<void> _init_data() async {
    notifyListeners();
  }

  Future<int> request_code() async {
    requesting = true;
    notifyListeners();
    if (!emailRegex.hasMatch(email)) {
      return -1;
    }

    final response = await http.post(
      Uri.parse('${server_root_url}/api/Account/forgotpassword?email=$email'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
    } else {
      requesting = false;
      action = ActionStatus.failure;
      notifyListeners();
      return -1;
    }

    requesting = false;

    notifyListeners();

    return 1;
  }

  Future<int> change_password() async {
    requesting = true;
    notifyListeners();
    if (!emailRegex.hasMatch(email) ||
        code.length != 4 && new_password != retype) {
      return -1;
    }

    final response = await http.post(
      Uri.parse(
          '${server_root_url}/api/Account/changepassword?email=$email&code=$code&new_password=$new_password'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
    } else {
      requesting = false;
      action = ActionStatus.failure;
      notifyListeners();
      return -1;
    }

    requesting = false;

    notifyListeners();

    return 1;
  }
}
