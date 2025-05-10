import 'package:myrefectly/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required String email,
    required String username,
    required String refreshToken,
    required String accessToken,
  }) : super(
          email: email,
          username: username,
          refreshToken: refreshToken,
          accessToken: accessToken,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      accessToken: json['access_token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'refreshToken': refreshToken,
      'accessToken': accessToken,
    };
  }
}
// To parse this JSON data, do

//     final UserModel = UserModelFromJson(jsonString);
