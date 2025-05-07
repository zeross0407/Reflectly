import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myrefectly/models/data.dart';

class RegisterResponse {
  final String refreshToken;
  final UserRS user;

  RegisterResponse({required this.refreshToken, required this.user});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      refreshToken: json["refreshToken"],
      user: UserRS.fromJson(json["user"]),
    );
  }
}

class UserRS {
  final String id;
  final String username;
  final String email;
  final dynamic avatar;

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
}

class AuthService {
  final String baseUrl = server_root_url + "/api/Account";
  
  Future<RegisterResponse> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return RegisterResponse.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      throw AuthException(code: 400, message: "Account already exists");
    } else {
      throw AuthException(code: response.statusCode, message: "Registration failed");
    }
  }
}

class AuthException implements Exception {
  final int code;
  final String message;
  
  AuthException({required this.code, required this.message});
} 