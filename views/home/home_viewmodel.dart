import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myrefectly/main.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/models/entry.dart';
import 'package:myrefectly/repository/DIOInterceptor.dart';
import 'package:myrefectly/repository/repository.dart';

class HomeViewmodel extends ChangeNotifier {
  bool loading = true;

  // Thuộc tính
  List<DateTime> weekDays = [];
  DateTime currentDay = DateTime.now();
  int dailyChallengeStep = 0;
  String dailyChallengeContent = '';
  late Repository<int, DailyChallenge> repo;
  late Repository<int, Entry> entryRepo;
  late List<String> weeklyQuotes;
  bool dailyCheckInComplete = false;
  List<String> weekly_quotes = [
    "Success is not final, failure is not fatal: It is the courage to continue that counts.",
    "The only limit to our realization of tomorrow is our doubts of today.",
    "Believe you can and you're halfway there.",
    "Don't watch the clock; do what it does. Keep going.",
    "The future belongs to those who believe in the beauty of their dreams.",
    "Hardships often prepare ordinary people for an extraordinary destiny.",
    "It always seems impossible until it's done."
  ];

  DailyChallenge todayChallenge = DailyChallenge(
      id: 1,
      step: 0,
      description: "It always seems impossible until it's done.");

  late Repository<int, Challenge> challengeRepo;
  late Repository<String, HomeModel> homeRepo;
  HomeModel? HomeData;

  HomeViewmodel() {
    getCurrentWeekDays();
    initData();
  }

  List<DateTime> getCurrentWeekDays() {
    DateTime today = DateTime.now();

    // Tính số ngày cần trừ đi để ra ngày Thứ Hai
    int mondayOffset = today.weekday - DateTime.monday;

    // Ngày Thứ Hai trong tuần hiện tại
    DateTime monday = today.subtract(Duration(days: mondayOffset));

    // Tạo danh sách các ngày trong tuần từ Thứ Hai đến Chủ Nhật
    weekDays = List.generate(7, (index) => monday.add(Duration(days: index)));

    return weekDays;
  }

  void reset() async {
    homeRepo = await Repository<String, HomeModel>(name: 'home_box');
    await homeRepo.init();
    HomeData = await homeRepo.getAt(0);
    notifyListeners();
  }

  Future<void> initData() async {
    dio.interceptors.add(TokenInterceptor(
        dio: dio, accessToken: access_token, refreshToken: refresh_token));

    challengeRepo = await Repository<int, Challenge>(name: 'Challenge_box');
    await challengeRepo.init();
    homeRepo = await Repository<String, HomeModel>(name: 'home_box');
    await homeRepo.init();
    HomeData = await homeRepo.getAt(0);
    entryRepo = await Repository<int, Entry>(name: 'entry_box');
    await entryRepo.init();
    List<Entry> entryList = await entryRepo.getAll();
    HomeData!.reflectionShared = [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ];
    if (entryList.any((element) {
      final submitDate = element.submitTime;
      return submitDate.year == DateTime.now().year &&
          submitDate.month == DateTime.now().month &&
          submitDate.day == DateTime.now().day &&
          element is MoodCheckin;
    })) {
      dailyCheckInComplete = true;
      notifyListeners();
    }

    if (entryList.any((element) {
      final submitDate = element.submitTime;
      return submitDate.year == DateTime.now().year &&
          submitDate.month == DateTime.now().month &&
          submitDate.day == DateTime.now().day &&
          element is User_Challenge;
    })) {
      dailyChallengeCompleted = true;
      notifyListeners();
    }

    repo = await Repository<int, DailyChallenge>(name: 'Challenge');
    await repo.init();
    DailyChallenge? challenge;
    try {
      challenge = await repo.getById(1);
      print(challenge);
    } catch (e) {
      // Handle exception
    }
    if (challenge == null) {
      repo.add(todayChallenge.id, todayChallenge);
    }

    final dailyBox = await Hive.openBox('Daily');
    dailyChallengeStep =
        await dailyBox.get('dailyChallengeStep', defaultValue: 0);
    dailyChallengeContent =
        await dailyBox.get('dailyChallengeContent', defaultValue: '');

    loading = false;

    notifyListeners();
  }

  bool dailyChallengeCompleted = false;
}
