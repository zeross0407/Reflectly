class UserEntity {
  final String email;
  final String username;
  final String refreshToken;
  final String accessToken;

  UserEntity({
    required this.email,
    required this.username,
    required this.refreshToken,
    required this.accessToken,
  });
} 