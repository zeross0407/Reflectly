import 'package:dartz/dartz.dart';

import 'package:myrefectly/core/network/models/failure.dart';
import 'package:myrefectly/features/auth/domain/entity/auth_entity.dart';

/// Abstract auth repository — the **swap point** for backends.
///
/// Current implementation: Supabase GoTrue REST API.
/// To swap backend (Firebase, custom, mock), create a new impl
/// and register it in the DI container. Zero changes needed in
/// domain or presentation layers.
///
/// ```dart
/// // In DI setup:
/// getIt.registerLazySingleton<AuthRepository>(
///   () => AuthRepositoryImpl(...), // or MockAuthRepository()
/// );
/// ```
abstract class AuthRepository {
  /// Sign in with email and password.
  Future<Either<Failure, AuthSession>> login({
    required String email,
    required String password,
  });

  /// Create a new account with email and password.
  Future<Either<Failure, AuthSession>> register({
    required String email,
    required String password,
    String? username,
  });

  /// Send a password recovery email.
  Future<Either<Failure, void>> requestPasswordReset({
    required String email,
  });

  /// Sign out the current user and clear tokens.
  Future<Either<Failure, void>> logout();

  /// Get the currently authenticated user's profile.
  Future<Either<Failure, AuthUser>> getCurrentUser();
}
