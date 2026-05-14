import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Manages auth tokens using secure storage.
///
/// Replaces the global `access_token` / `refresh_token` variables
/// from the old codebase with a secure, encapsulated solution.
///
/// Usage:
/// ```dart
/// final tokenManager = TokenManager();
/// await tokenManager.saveTokens(accessToken: '...', refreshToken: '...');
/// final token = await tokenManager.accessToken;
/// ```
class TokenManager {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  final FlutterSecureStorage _storage;

  TokenManager({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  // ── Read ────────────────────────────────────────────────────

  /// Returns the stored access token, or `null` if not set.
  Future<String?> get accessToken =>
      _storage.read(key: _accessTokenKey);

  /// Returns the stored refresh token, or `null` if not set.
  Future<String?> get refreshToken =>
      _storage.read(key: _refreshTokenKey);

  /// Returns `true` if an access token exists in storage.
  Future<bool> get hasToken async =>
      (await _storage.read(key: _accessTokenKey)) != null;

  // ── Write ───────────────────────────────────────────────────

  /// Saves both tokens to secure storage.
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }

  /// Updates only the access token (e.g. after a token refresh).
  Future<void> updateAccessToken(String accessToken) =>
      _storage.write(key: _accessTokenKey, value: accessToken);

  // ── Delete ──────────────────────────────────────────────────

  /// Clears all stored tokens (e.g. on logout).
  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);
  }
}
