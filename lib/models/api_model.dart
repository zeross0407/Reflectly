import 'package:json_annotation/json_annotation.dart';

part 'api_model.g.dart';


// @JsonSerializable()
// class UserAPI {
//   final String id;
//   String username;
//   String email;
//   String? avatar;
//   String refresh_token;

//   UserAPI(
//       {required this.id,
//       required this.username,
//       required this.email,
//       this.avatar,
//       required this.refresh_token});

//   // Phương thức chuyển đổi từ JSON sang User object
//   factory UserAPI.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

//   // Phương thức chuyển đổi từ User object sang JSON
//   Map<String, dynamic> toJson() => _$UserToJson(this);
// }

// @JsonSerializable()
// class AuthResponse {
//   final String accessToken;
//   final String refreshToken;
//   final UserAPI user;

//   AuthResponse({
//     required this.accessToken,
//     required this.refreshToken,
//     required this.user,
//   });

//   // Phương thức chuyển đổi từ JSON sang AuthResponse object
//   factory AuthResponse.fromJson(Map<String, dynamic> json) =>
//       _$AuthResponseFromJson(json);

//   // Phương thức chuyển đổi từ AuthResponse object sang JSON
//   Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
// }

@JsonSerializable()
class LoginResponse {
  final String refresh_token;
  final String email;
  final String? avatar; // Có thể null
  final String username;

  LoginResponse({
    required this.refresh_token,
    required this.email,
    this.avatar,
    required this.username,
  });

  // Phương thức chuyển đổi từ JSON sang AuthResponse
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  // Phương thức chuyển đổi từ AuthResponse sang JSON
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class QuotesResponse {
  final String id;
  final String title;
  final String? author; // Có thể null
  final int favorite;
  final String categoryid;

  QuotesResponse(
      {required this.id,
      required this.title,
      required this.author,
      required this.favorite,
      required this.categoryid});

  factory QuotesResponse.fromJson(Map<String, dynamic> json) =>
      _$QuotesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QuotesResponseToJson(this);
}

