import 'package:flutter/material.dart';
import 'package:myrefectly/help/enum.dart';
import 'package:myrefectly/main.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/models/entry.dart';
import 'package:myrefectly/models/response_model.dart';
import 'package:myrefectly/repository/repository.dart';
import 'auth_service.dart';
import 'login_result.dart';
import 'sync_repository.dart';
import 'validators.dart';

class Login_Viewmodel extends ChangeNotifier {
  String email = "";
  String password = "";
  bool logging_in = false;
  int status_code = 0;
  ActionStatus action = ActionStatus.waiting;

  final AuthService _authService = AuthService();
  late Repository<String, User> _repo;
  late SyncRepository _syncRepository;
  late User user;

  Login_Viewmodel() {
    _init_data();
  }

  Future<void> _init_data() async {
    // Khởi tạo user repository
    _repo = await Repository<String, User>(name: 'user_box');
    await _repo.init();
    user = await _repo.getAt(0);

    // Khởi tạo các repository khác
    var entryRepo = await Repository<String, Entry>(name: 'entry_box');
    await entryRepo.init();

    var activityRepo = await Repository<String, Activity>(name: 'activity_box');
    await activityRepo.init();

    var feelingRepo = await Repository<String, Feeling>(name: 'feeling_box');
    await feelingRepo.init();

    // Khởi tạo sync repository
    _syncRepository = SyncRepository(
        entryRepo: entryRepo,
        activityRepo: activityRepo,
        feelingRepo: feelingRepo);

    notifyListeners();
  }

  Future<LoginResult> validateCredentials() {
    if (!Validators.isValidEmail(email)) {
      return Future.value(
          LoginResult(success: false, errorCode: ErrorCode.invalidEmail));
    }
    if (!Validators.isValidPassword(password)) {
      return Future.value(
          LoginResult(success: false, errorCode: ErrorCode.invalidPassword));
    }
    return Future.value(LoginResult(success: true));
  }

  Future<int> request_login() async {
    logging_in = true;
    notifyListeners();

    // 1. Validate input
    final validationResult = await validateCredentials();
    if (!validationResult.success) {
      logging_in = false;
      notifyListeners();
      return -1;
    }

    try {
      // 2. Authenticate
      final userData = await _authService.login(email, password);

      // 3. Sync data
      await _syncRepository.syncUserData(userData);

      // 4. Update user
      _updateUserData(userData);

      logging_in = false;
      action = ActionStatus.success;
      notifyListeners();
      return 1;
    } catch (e) {
      logging_in = false;
      action = ActionStatus.failure;
      notifyListeners();
      return -1;
    }
  }

  void _updateUserData(UserData userData) {
    user.email = userData.email;
    user.user_name = userData.username;
    user.refresh_token = userData.refreshToken;
    user.save();
    // Cập nhật biến toàn cục nếu cần
    refresh_token = userData.refreshToken;
  }
}
