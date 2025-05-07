import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myrefectly/models/data.dart';

class AuthService {
  final String baseUrl = server_root_url + "/api/Account";
  
  /// Gửi yêu cầu để nhận mã xác nhận reset mật khẩu
  Future<bool> requestResetCode(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forgotpassword?email=$email'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw AuthException(
        code: response.statusCode, 
        message: "Failed to send reset code"
      );
    }
  }
  
  /// Đổi mật khẩu với mã xác nhận đã nhận
  Future<bool> changePassword(String email, String code, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/changepassword?email=$email&code=$code&new_password=$newPassword'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw AuthException(
        code: response.statusCode, 
        message: "Failed to change password"
      );
    }
  }
}

class AuthException implements Exception {
  final int code;
  final String message;
  
  AuthException({required this.code, required this.message});
} 