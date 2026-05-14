import 'package:equatable/equatable.dart';

/// Represents an authenticated session returned after login/register.
///
/// Pure domain entity — no JSON logic, no framework dependencies.
class AuthSession extends Equatable {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final AuthUser user;

  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresIn, user];
}

/// Represents the authenticated user's profile.
class AuthUser extends Equatable {
  final String id;
  final String email;
  final String? username;
  final String? avatarUrl;

  const AuthUser({
    required this.id,
    required this.email,
    this.username,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, email, username, avatarUrl];
}
