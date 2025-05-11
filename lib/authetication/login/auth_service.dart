import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/response_model.dart';

class AuthService {
  final String baseUrl = server_root_url + "/api/Account";

  Future<UserData> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return UserData.fromJson(json.decode(response.body));
    } else {
      throw AuthException(code: response.statusCode, message: "Login failed");
    }
  }
}

class AuthException implements Exception {
  final int code;
  final String message;

  AuthException({required this.code, required this.message});
}
