/// Tập hợp các API Endpoint
/// Class này tập trung quản lý tất cả các endpoint API, giúp dễ dàng 
/// bảo trì và cập nhật khi có thay đổi
class ApiEndpoints {
  ApiEndpoints._();

  /// Base URL 
  static const String baseUrl = '/api';
  
  /// Auth endpoints
  static const String login = '$baseUrl/Account/login';
  static const String register = '$baseUrl/Account/register';
  static const String refreshToken = '$baseUrl/Account/get_access_token';
  static const String forgotPassword = '$baseUrl/Account/forgot_password';
  static const String resetPassword = '$baseUrl/Account/reset_password';
  static const String profile = '$baseUrl/Account/profile';
  static const String updateProfile = '$baseUrl/Account/update_profile';
  static const String deleteAccount = '$baseUrl/Account/deleteaccount';
  static const String avatar = '$baseUrl/Account/media/avatar.png';
  static const String exportData = '$baseUrl/Account/generate-html';
  
  /// MoodCheckin endpoints
  static const String moodCheckin = '$baseUrl/MoodCheckin';
  static const String getMoodCheckins = '$baseUrl/MoodCheckin/get_all';
  static const String createMoodCheckin = '$baseUrl/MoodCheckin/create';
  
  /// Challenge endpoints
  static const String challenge = '$baseUrl/Challenge';
  static const String dailyChallenge = '$baseUrl/Challenge/daily';
  
  /// Quote endpoints
  static const String quote = '$baseUrl/Quotes';
  static const String newQuotes = '$baseUrl/Quotes/new_quotes';
  
  /// Activity endpoints
  static const String activity = '$baseUrl/Activity';
  
  /// Feeling endpoints
  static const String feeling = '$baseUrl/Feeling';
} 