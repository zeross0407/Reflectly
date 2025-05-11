class Validators {
  static final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  
  static bool isValidEmail(String email) {
    return emailRegex.hasMatch(email);
  }
  
  static bool isValidCode(String code) {
    // Kiểm tra mã xác nhận có đúng 4 ký tự
    return code.length == 4;
  }
  
  static bool isValidPassword(String password) {
    // Kiểm tra mật khẩu không rỗng
    return password.isNotEmpty;
  }
  
  static bool doPasswordsMatch(String newPassword, String retypePassword) {
    return newPassword == retypePassword;
  }
} 