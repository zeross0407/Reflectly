class LoginResult {
  final bool success;
  final ErrorCode? errorCode;

  LoginResult({required this.success, this.errorCode});
}

enum ErrorCode {
  invalidEmail,
  invalidPassword,
  serverError,
  networkError,
  unknownError,
}
