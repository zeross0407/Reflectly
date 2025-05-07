class Validators {
  static final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  
  static bool isValidEmail(String email) {
    return emailRegex.hasMatch(email);
  }
  
  static bool isPasswordValid(String password) {
    // Kiểm tra mật khẩu có độ dài tối thiểu 8 ký tự
    return password.length >= 8;
  }
  
  static bool doPasswordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }
  
  static bool isUserNameValid(String username) {
    // Kiểm tra tên người dùng có độ dài tối thiểu 3 ký tự và không chứa ký tự đặc biệt
    return username.length >= 3;
  }
} 