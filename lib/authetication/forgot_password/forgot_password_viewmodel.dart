import 'package:flutter/material.dart';
import 'package:myrefectly/help/enum.dart';
import 'package:myrefectly/models/entity.dart';

import 'auth_service.dart';
import 'forgot_password_result.dart';
import 'validators.dart';

class ForgotPassword_Viewmodel extends ChangeNotifier {
  String email = "";
  String code = "";
  String new_password = "";
  String retype = "";
  bool requesting = false;
  int status_code = 0;
  ActionStatus action = ActionStatus.waiting;
  
  final AuthService _authService = AuthService();
  
  ForgotPassword_Viewmodel() {
    _init_data();
  }

  Future<void> _init_data() async {
    notifyListeners();
  }
  
  Future<ForgotPasswordResult> validateEmail() {
    if (!Validators.isValidEmail(email)) {
      return Future.value(ForgotPasswordResult(success: false, errorCode: ErrorCode.invalidEmail));
    }
    return Future.value(ForgotPasswordResult(success: true));
  }
  
  Future<ForgotPasswordResult> validatePasswordReset() {
    if (!Validators.isValidEmail(email)) {
      return Future.value(ForgotPasswordResult(success: false, errorCode: ErrorCode.invalidEmail));
    }
    if (!Validators.isValidCode(code)) {
      return Future.value(ForgotPasswordResult(success: false, errorCode: ErrorCode.invalidCode));
    }
    if (!Validators.isValidPassword(new_password)) {
      return Future.value(ForgotPasswordResult(success: false, errorCode: ErrorCode.invalidPassword));
    }
    if (!Validators.doPasswordsMatch(new_password, retype)) {
      return Future.value(ForgotPasswordResult(success: false, errorCode: ErrorCode.passwordsDoNotMatch));
    }
    return Future.value(ForgotPasswordResult(success: true));
  }

  Future<int> request_code() async {
    requesting = true;
    notifyListeners();
    
    // 1. Validate email
    final validationResult = await validateEmail();
    if (!validationResult.success) {
      requesting = false;
      notifyListeners();
      return -1;
    }
    
    try {
      // 2. Call API to request reset code
      await _authService.requestResetCode(email);
      
      requesting = false;
      notifyListeners();
      return 1;
    } catch (e) {
      requesting = false;
      action = ActionStatus.failure;
      notifyListeners();
      return -1;
    }
  }

  Future<int> change_password() async {
    requesting = true;
    notifyListeners();
    
    // 1. Validate all input
    final validationResult = await validatePasswordReset();
    if (!validationResult.success) {
      requesting = false;
      notifyListeners();
      return -1;
    }
    
    try {
      // 2. Call API to change password
      await _authService.changePassword(email, code, new_password);
      
      requesting = false;
      action = ActionStatus.success;
      notifyListeners();
      return 1;
    } catch (e) {
      requesting = false;
      action = ActionStatus.failure;
      notifyListeners();
      return -1;
    }
  }
}
