class ForgotPasswordResult {
  final bool success;
  final ErrorCode? errorCode;
  
  ForgotPasswordResult({required this.success, this.errorCode});
}

enum ErrorCode {
  invalidEmail,
  invalidCode,
  invalidPassword,
  passwordsDoNotMatch,
  serverError,
  networkError,
  unknownError,
} 