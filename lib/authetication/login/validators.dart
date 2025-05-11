class Validators {
  static final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  
  static bool isValidEmail(String email) {
    return emailRegex.hasMatch(email);
  }
  
  static bool isValidPassword(String password) {
    // Kiểm tra mật khẩu không rỗng
    return password.isNotEmpty;
  }
} 