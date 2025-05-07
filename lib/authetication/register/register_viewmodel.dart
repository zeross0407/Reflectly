import 'package:flutter/material.dart';
import 'package:myrefectly/help/enum.dart';
import 'package:myrefectly/main.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:restart_app/restart_app.dart';

import 'auth_service.dart';
import 'register_result.dart';
import 'validators.dart';

class Register_Viewmodel extends ChangeNotifier {
  final String username;
  String email = "";
  String password = "";
  String retype_password = "";
  bool logging_in = false;
  int status_code = 0;
  ActionStatus action = ActionStatus.waiting;
  
  final AuthService _authService = AuthService();
  late Repository<String, User> _repo;
  late User user;
  
  Register_Viewmodel({required this.username}) {
    _init_data();
  }

  Future<void> _init_data() async {
    _repo = await Repository<String, User>(name: 'user_box');
    await _repo.init();
    user = await _repo.getAt(0);
    notifyListeners();
  }
  
  Future<RegisterResult> validateRegistrationData() {
    if (!Validators.isValidEmail(email)) {
      return Future.value(RegisterResult(success: false, errorCode: ErrorCode.invalidEmail));
    }
    if (!Validators.isPasswordValid(password)) {
      return Future.value(RegisterResult(success: false, errorCode: ErrorCode.invalidPassword));
    }
    if (!Validators.doPasswordsMatch(password, retype_password)) {
      return Future.value(RegisterResult(success: false, errorCode: ErrorCode.passwordsDoNotMatch));
    }
    if (!Validators.isUserNameValid(username)) {
      return Future.value(RegisterResult(success: false, errorCode: ErrorCode.invalidUsername));
    }
    return Future.value(RegisterResult(success: true));
  }

  Future<int> request_register() async {
    logging_in = true;
    notifyListeners();
    
    // 1. Validate input
    final validationResult = await validateRegistrationData();
    if (!validationResult.success) {
      logging_in = false;
      notifyListeners();
      return -1;
    }
    
    try {
      // 2. Call API to register
      final registerResponse = await _authService.register(username, email, password);
      
      // 3. Update user information
      _updateUserData(registerResponse);
      
      // 4. Schedule app restart to apply changes
      Future.delayed(
        Duration(seconds: 1),
        () {
          Restart.restartApp();
        },
      );
      
      logging_in = false;
      action = ActionStatus.success;
      notifyListeners();
      return 1;
    } catch (e) {
      logging_in = false;
      action = ActionStatus.failure;
      notifyListeners();
      
      if (e is AuthException && e.code == 400) {
        return -2; // Account already exists
      }
      
      return -1; // Other errors
    }
  }
  
  void _updateUserData(RegisterResponse response) {
    user.user_name = response.user.username;
    user.email = response.user.email;
    user.refresh_token = response.refreshToken;
    user.save();
    // Update global refresh token
    refresh_token = response.refreshToken;
  }
}
