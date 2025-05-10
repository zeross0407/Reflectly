class ServerException implements Exception {
  final String message;
  final int statusCode;

  ServerException({required this.message, required this.statusCode});
}

class CacheException implements Exception {
  final String message;

  CacheException({required this.message});
}

class AuthException implements Exception {
  final String message;
  final int code;

  AuthException({required this.message, required this.code});
}

class ValidationException implements Exception {
  final String message;
  final String field;

  ValidationException({required this.message, required this.field});
} 