import 'package:flutter/material.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/models/entry.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:intl/intl.dart';

class Statistical_Viewmodel extends ChangeNotifier {
  late Repository<int, Entry> entry_repo;
  late Repository<String, Activity> activity_repo;
  late Repository<String, Feeling> feeling_repo;
  int negative_day = 0;
  int positive_day = 0;
  List<Entry> mood_checkin_list = [];
  List<double> mood_break_down = [0, 0, 0, 0, 0];
  List<Activity> shine = [];
  List<Activity> down = [];
  List<Activity> all_activity = List.from(activities_list_default);
  Map<Activity, double> most_activity = {};
  List<Feeling> all_feeling = List.from(feelings_list_default);
  Map<Feeling, double> frequent_feeling = {};
  Map<String, Activity> map_activity = {};
  Map<String, Feeling> map_feeling = {};
  double screenWidth = 0;
  double height = 0;
  List<Offset> current_data = [];
  List<DateTime> current_data_time = [];
  List<Offset> previous_data = [];
  DateTime time_statis = DateTime.now();
  double average_mood = 0;

  Statistical_Viewmodel(double width) {
    screenWidth = width;
    height = width * 0.55;
    _init_data();
  }

  Future<void> _init_data() async {
    entry_repo = await Repository<int, Entry>(name: 'entry_box');
    await entry_repo.init();
    activity_repo = await Repository<String, Activity>(name: 'activity_box');
    await activity_repo.init();
    feeling_repo = await Repository<String, Feeling>(name: 'feeling_box');
    await feeling_repo.init();
    all_activity.addAll(await activity_repo.getAll());
    map_activity = {for (var activity in all_activity) activity.UUID: activity};
    all_feeling.addAll(await feeling_repo.getAll());
    map_feeling = {for (var feeling in all_feeling) feeling.UUID: feeling};
    await statis(time_statis);
    notifyListeners();
  }

  Future<void> statis(DateTime time) async {
    // Clear các dữ liệu đã có trước đó
    negative_day = 0;
    positive_day = 0;
    mood_checkin_list.clear();
    mood_break_down = [0, 0, 0, 0, 0];
    shine.clear();
    down.clear();
    most_activity.clear();
    frequent_feeling.clear();
    current_data.clear();
    current_data_time.clear();
    previous_data.clear();

    mood_checkin_list = (await entry_repo.getAll())
        .where(
          (element) => element is MoodCheckin,
        )
        .toList();

    // Lọc dữ liệu của tuần hiện tại
    List<Entry> data_week = filterEntriesByWeek(mood_checkin_list, time);
    List<Entry> data_previous_week = filterEntriesByWeek(
        mood_checkin_list, time.subtract(Duration(days: 7)));
    // Tiến hành thống kê
    statis_neg_pos_day(data_week);
    statis_mood_break_down(data_week);
    statis_shine(data_week);
    statis_freq(data_week);
    statis_mood(data_week);
    statis_mood_previous(data_previous_week);
    notifyListeners();
  }

  Future<void> statis_mood_previous(List<Entry> data) async {
    List<List<Entry>> day_data = groupEntriesByDate(data);
    for (var i = 0; i < day_data.length; i++) {
      double mood_avg = 0;
      for (var j = 0; j < day_data[i].length; j++) {
        mood_avg += (day_data[i][j] as MoodCheckin).mood;
      }
      mood_avg /= day_data[i].length;
      previous_data.add(Offset(
          screenWidth * day_data[i][0].submitTime.weekday / 8,
          height * 0.65 * (1 - (mood_avg / 4))));
    }
    previous_data.sort(
      (a, b) => a.dx.compareTo(b.dx),
    );

    notifyListeners();
  }

  Future<void> statis_mood(List<Entry> data) async {
    if (data.length == 0) return;
    average_mood = 0;
    int count = 0;
    List<List<Entry>> day_data = groupEntriesByDate(data);
    for (var i = 0; i < day_data.length; i++) {
      current_data_time.add(day_data[i][0].submitTime);
      double mood_avg = 0;
      for (var j = 0; j < day_data[i].length; j++) {
        mood_avg += (day_data[i][j] as MoodCheckin).mood;
        average_mood += (day_data[i][j] as MoodCheckin).mood;
        count++;
      }
      mood_avg /= day_data[i].length;
      current_data.add(Offset(
          screenWidth * day_data[i][0].submitTime.weekday / 8,
          height * 0.65 * (1 - (mood_avg / 4))));
    }
    current_data.sort(
      (a, b) => a.dx.compareTo(b.dx),
    );
    current_data_time.sort();
    (average_mood /= count);
    notifyListeners();
  }

  Future<void> statis_freq(List<Entry> data) async {
    Map<String, int> freq_activity = {};
    Map<String, int> freq_feeling = {};
    int count_activity = 0;
    int count_feeling = 0;
    for (var i = 0; i < data.length; i++) {
      count_feeling += (data[i] as MoodCheckin).feelings.length;
      count_activity += (data[i] as MoodCheckin).activities.length;
      (data[i] as MoodCheckin).activities.forEach((element) {
        freq_activity[element] = freq_activity[element] ?? 0 + 1;
      });
      (data[i] as MoodCheckin).feelings.forEach((element) {
        freq_feeling[element] = freq_feeling[element] ?? 0 + 1;
      });
    }
    List<String> top3activity = (freq_activity.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        .take(3)
        .map((entry) => entry.key)
        .toList();
    top3activity.forEach(
      (element) {
        most_activity[map_activity[element]!] =
            freq_activity[element]! / count_activity;
      },
    );
    List<String> top3feeling = (freq_feeling.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        .take(3)
        .map((entry) => entry.key)
        .toList();
    top3feeling.forEach(
      (element) {
        frequent_feeling[map_feeling[element]!] =
            freq_feeling[element]! / count_feeling;
      },
    );
    notifyListeners();
  }

  Future<void> statis_mood_break_down(List<Entry> data) async {
    for (var i = 0; i < data.length; i++) {
      mood_break_down[((data[i] as MoodCheckin).mood.toInt()).toInt()]++;
    }
    for (var i = 0; i < 5; i++) {
      if (data.length > 0) mood_break_down[i] /= data.length;
    }
    notifyListeners();
  }

  Future<void> statis_shine(List<Entry> data) async {
    for (var i = 0; i < data.length; i++) {
      for (var j = 0; j < (data[i] as MoodCheckin).activities.length; j++) {
        ((data[i] as MoodCheckin).mood < 2.5 ? down : shine)
            .add(map_activity[(data[i] as MoodCheckin).activities[j]]!);
        Set<Activity> s1 = down.toSet();
        Set<Activity> s2 = shine.toSet();
        down = s1.toList();
        shine = s2.toList();
      }
    }
    notifyListeners();
  }

  int getIso8601WeekNumber(DateTime date) {
    // Lấy thứ của ngày hiện tại
    int dayOfWeek = date.weekday; // 1 = Monday, 7 = Sunday (ISO 8601 standard)

    // Chuyển ngày về thứ Hai đầu tiên của tuần đó
    DateTime monday = date.subtract(Duration(days: dayOfWeek - 1));

    // Bắt đầu tuần tính từ ngày 4 tháng 1 vì theo ISO 8601 tuần đầu tiên
    // là tuần có ngày thứ Năm đầu tiên của năm
    DateTime jan4 = DateTime(date.year, 1, 4);

    // Chuyển ngày 4 tháng 1 về thứ Hai đầu tiên của tuần đó
    DateTime jan4Monday = jan4.subtract(Duration(days: jan4.weekday - 1));

    // Tính số tuần từ ngày 4 tháng 1 đến ngày `date`
    return ((monday.difference(jan4Monday).inDays) / 7).ceil();
  }

  List<Entry> filterEntriesByWeek(List<Entry> entries, DateTime date) {
    int targetWeek = getIso8601WeekNumber(date);
    int targetYear = date.year;

    return entries.where((entry) {
      int entryWeek = getIso8601WeekNumber(entry.submitTime);
      int entryYear = entry.submitTime.year;
      return entryWeek == targetWeek && entryYear == targetYear;
    }).toList();
  }

  List<List<Entry>> groupEntriesByDate(List<Entry> entries) {
    if (entries.length == 0) return [];
    Map<String, List<Entry>> groupedMap = {};

    for (var entry in entries) {
      // Định dạng ngày cho mỗi `Entry`
      String dateKey = DateFormat('yyyy-MM-dd').format(entry.submitTime);

      // Thêm vào nhóm tương ứng với `dateKey`
      if (!groupedMap.containsKey(dateKey)) {
        groupedMap[dateKey] = [];
      }
      groupedMap[dateKey]!.add(entry);
    }

    // Chuyển từ Map sang List 2 chiều
    return groupedMap.values.toList();
  }

  Future<void> statis_neg_pos_day(List<Entry> data) async {
    List<List<Entry>> filted_data = groupEntriesByDate(data);
    for (var i = 0; i < filted_data.length; i++) {
      double mood_avg = 0;
      for (var j = 0; j < filted_data[i].length; j++) {
        mood_avg += (filted_data[i][j] as MoodCheckin).mood;
      }
      if (mood_avg / filted_data[i].length < 2.5) {
        negative_day++;
      } else {
        positive_day++;
      }
    }
  }
}
