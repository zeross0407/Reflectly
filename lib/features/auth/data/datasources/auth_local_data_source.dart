import 'package:hive_flutter/hive_flutter.dart';
import 'package:myrefectly/features/auth/data/models/user_model.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:myrefectly/main.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUserData(UserModel user);
  Future<UserModel?> getCachedUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Repository<String, User> userRepository;

  AuthLocalDataSourceImpl({required this.userRepository});

  @override
  Future<void> saveUserData(UserModel userModel) async {
    // Ensure Hive is initialized
    if (!isHiveInitialized) {
      await Hive.initFlutter();
      isHiveInitialized = true;
    }

    // Initialize repository if not already initialized
    await userRepository.init();

    try {
      // Try to get the existing user
      User user = await userRepository.getAt(0);

      // Update existing user
      user.email = userModel.email;
      user.user_name = userModel.username;
      user.refresh_token = userModel.refreshToken;
      user.access_token = userModel.accessToken;

      // Save updated user
      await user.save();

      // Update global tokens
      refresh_token = userModel.refreshToken;
      access_token = userModel.accessToken;
    } catch (e) {
      // If no user exists, create a new one with default values
      final now = DateTime.now();
      final User newUser = User(
        email: userModel.email,
        user_name: userModel.username,
        refresh_token: userModel.refreshToken,
        access_token: userModel.accessToken,
        quotesTheme: 0,
        darkmode: false,
        passcode: false,
        checkin_reminder: false,
        possitive_reminder: false,
        theme_color: 0,
        quote_category: 0,
        quote_hearted: [],
        time_checkin_reminder: now,
        count_positivity_reminder: 3,
        start_positivity_reminder: DateTime(now.year, now.month, now.day, 8, 0),
        end_positivity_reminder: DateTime(now.year, now.month, now.day, 20, 0),
      );

      // Add the new user to the repository
      await userRepository.add('user', newUser);

      // Update global tokens
      refresh_token = userModel.refreshToken;
      access_token = userModel.accessToken;
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    // Ensure Hive is initialized
    if (!isHiveInitialized) {
      await Hive.initFlutter();
      isHiveInitialized = true;
    }

    // Initialize repository if not already initialized
    await userRepository.init();

    try {
      // Try to get the existing user
      User user = await userRepository.getAt(0);

      return UserModel(
        email: user.email,
        username: user.user_name,
        refreshToken: user.refresh_token,
        accessToken: user.access_token,
      );
    } catch (e) {
      return null;
    }
  }
}
