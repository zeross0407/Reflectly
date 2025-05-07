import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myrefectly/main.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:http/http.dart' as http;
import 'package:myrefectly/repository/sync.dart';

class Init_Viewmodel extends ChangeNotifier {
  late Repository<String, Challenge> _challenge_repo;
  late Repository<String, Reflection> _reflection_repo;
  late Repository<String, HomeModel> _home_repo;
  late Repository<String, User> _user_repo;

  late User user;
  bool loading = true;
  Init_Viewmodel() {
    _init_data();
  }

  Future<void> _init_data() async {
    _challenge_repo =
        await Repository<String, Challenge>(name: 'Challenge_box');
    await _challenge_repo.init();

    _reflection_repo =
        await Repository<String, Reflection>(name: 'reflection_box');
    await _reflection_repo.init();

    _user_repo = await Repository<String, User>(name: 'user_box');
    await _user_repo.init();

    user = await _init_user_profile();
    refresh_token = user.refresh_token;
    Data_Sync_Trigger.init_data();

    if (await _challenge_repo.count() < 7) {
      await get_challenge(7 - await _challenge_repo.count());

      notifyListeners();
    }

    await get_reflection();

    _home_repo = await Repository<String, HomeModel>(name: 'home_box');
    await _home_repo.init();
    if (await _home_repo.count() >= 1) {
      HomeModel home = await _home_repo.getAt(0);
      if (!isSameWeek(home.start)) {
        await _home_repo.clearAll();
        HomeModel new_home = await HomeModel(
          start: DateTime.now(),
          completeCheckin: List.generate(
            7,
            (index) => false,
          ),
          reflectionShared: List.generate(
            7,
            (index) => false,
          ),
          todayChallenge: null,
          weeklyQuote: [],
          weeklyReflection: [],
          challenge_completed: List.generate(
            7,
            (index) => 0,
          ),
        );

        await _home_repo.add("week", new_home);
      }
    } else {
      HomeModel new_home = await HomeModel(
        start: DateTime.now(),
        completeCheckin: List.generate(
          7,
          (index) => false,
        ),
        reflectionShared: List.generate(
          7,
          (index) => false,
        ),
        todayChallenge: null,
        weeklyQuote: [],
        weeklyReflection: [],
        challenge_completed: List.generate(
          7,
          (index) => 0,
        ),
      );

      await _home_repo.add("week", new_home);
    }

    HomeModel home = await _home_repo.getAt(0);
    home.weeklyReflection = await _reflection_repo.getAll();
    await home.save();
    loading = await false;
    notifyListeners();
  }

// Khoi tao du lieu khoi dau cho nguoi dung khi chua dang nhap
  Future<User> _init_user_profile() async {
    try {
      if ((await _user_repo.getAll()).length == 0) {
        User u = User(
            user_name: "",
            email: "",
            refresh_token: "",
            quotesTheme: 0,
            darkmode: false,
            passcode: false,
            checkin_reminder: false,
            possitive_reminder: false,
            theme_color: 0,
            quote_category: 0,
            quote_hearted: [],
            count_positivity_reminder: 1,
            end_positivity_reminder: DateTime(0, 1, 1, 16, 0),
            start_positivity_reminder: DateTime(0, 1, 1, 16, 0),
            time_checkin_reminder: DateTime(0, 1, 1, 16, 0),
            access_token: "");
        await _user_repo.add("0", u);
      }
    } catch (e) {
      print(e);
    }

    return await _user_repo.getAt(0);
  }

  Future<void> get_challenge(int number) async {
    try {

      final response = await http.get(
        Uri.parse(
            '${server_root_url}/api/Challenge/getchallenge?number=$number'),
        headers: {
          'Authorization': 'Bearer ${user.refresh_token}', // Thêm token vào header
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse JSON response body thành List<dynamic>
        List<dynamic> jsonData = jsonDecode(response.body);

        // Ánh xạ List<dynamic> thành List<Challenge>
        List<Challenge> data =
            jsonData.map((item) => Challenge.fromJson(item)).toList();

        for (var i = 0; i < data.length; i++) {
          _challenge_repo.add(data[i].id, data[i]);
        }
      } else {
        print('Failed to init: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e'); // In ra lỗi
    }
  }

  Future<void> get_reflection() async {
    try {
      final response = await http.get(
        Uri.parse('${server_root_url}/api/UserReflection/getreflection'),
        headers: {
          'Authorization': 'Bearer $refresh_token', // Thêm token vào header
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse JSON response body thành List<dynamic>
        List<dynamic> jsonData = jsonDecode(response.body);

        // Ánh xạ List<dynamic> thành List<Challenge>
        List<Reflection> data =
            jsonData.map((item) => Reflection.fromJson(item)).toList();

        for (var i = 0; i < data.length; i++) {
          _reflection_repo.add(data[i].id, data[i]);
        }
      } else {
        print('Failed to init: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e'); // In ra lỗi
    }
  }

  bool isSameWeek(DateTime date) {
    // Lấy ngày hôm nay
    DateTime now = DateTime.now();

    // Lấy ngày đầu tuần (thứ 2) của tuần hiện tại
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    // Lấy ngày cuối tuần (chủ nhật) của tuần hiện tại
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    // Kiểm tra xem biến date có nằm giữa startOfWeek và endOfWeek không
    return date.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(seconds: 1)));
  }
}
