class RegisterResult {
  final bool success;
  final ErrorCode? errorCode;
  
  RegisterResult({required this.success, this.errorCode});
}

enum ErrorCode {
  invalidEmail,
  invalidPassword,
  passwordsDoNotMatch,
  invalidUsername,
  accountExists,
  serverError,
  networkError,
  unknownError,
} 