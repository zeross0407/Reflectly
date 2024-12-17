import 'package:flutter/material.dart';
import 'package:myrefectly/main.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/models/entry.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:myrefectly/repository/sync.dart';

class Entries_Viewmodel extends ChangeNotifier {
  bool _is_loading = true;
  late Repository<String, Entry> entry_repo;
  late Repository<String, Activity> _activity_repo;
  late Repository<String, Feeling> _feeling_repo;
  List<Entry> _items = [];
  List<dynamic> _entry_points = [];
  List<Activity> all_activity = List.from(activities_list_default);
  List<Feeling> all_feeling = List.from(feelings_list_default);
  Map<String, Activity> map_activity = {};
  Map<String, Feeling> map_feeling = {};
  int count_reflection = 0;
  int count_checkin = 0;
  int count_photo = 0;
  Entries_Viewmodel() {
    _init_data();
  }

  Future<void> _init_data() async {
    _activity_repo = await Repository<String, Activity>(name: 'activity_box');
    await _activity_repo.init();
    all_activity.addAll(await _activity_repo.getAll());

    _feeling_repo = await Repository<String, Feeling>(name: 'feeling_box');
    await _feeling_repo.init();
    all_feeling.addAll(await _feeling_repo.getAll());

    map_activity = {for (var activity in all_activity) activity.UUID: activity};
    map_feeling = {for (var feeling in all_feeling) feeling.UUID: feeling};

    entry_repo = Repository<String, Entry>(name: 'entry_box');
    await entry_repo.init();
    loadData();
    notifyListeners();
  }

  Future<void> loadData() async {
    count_reflection = 0;
    count_checkin = 0;
    count_photo = 0;
    _entry_points = [];
    await entry_repo.init(); // Mở hộp
    items = await entry_repo.getAll(); // Lấy tất cả dữ liệu
    items.sort((a, b) => b.submitTime.compareTo(a.submitTime));

    for (int i = 0; i < items.length; i++) {
      if (items[i] is Photo) count_photo++;
      if (items[i] is MoodCheckin) count_checkin++;
      if (items[i] is User_reflection) count_reflection++;
      _entry_points.add(items[i]);
    }
    List<int> split = [if (!_entry_points.isEmpty) 0];

    for (int i = 1; i < _entry_points.length; i++) {
      if (!isSameDay(
          _entry_points[i - 1].submitTime, _entry_points[i].submitTime)) {
        // entry_points.insert(i, items[i].time);
        // i++;
        split.add(i);
      }
    }

    int count = 0;
    for (int i = 0; i < split.length; i++) {
      _entry_points.insert(
          split[i] + count, _entry_points[split[i] + count].submitTime);
      count++;
    }
    _is_loading = await false;
    notifyListeners();
    // print(items);
    // print("OK");
  }

  Future<void> delete_entry(String id, CollectionEnum collection) async {
    try {
      await entry_repo.delete(id);
      entryPoints.removeWhere((entry) => entry is Entry && entry.UUID == id);
      await loadData();

      Data_Sync_Trigger().syncDataWithServer(Data_Sync(
          id: uuid.v1(),
          name: collection.index,
          action: ActionEnum.Delete.index,
          jsonData: id,
          timeStamp: DateTime.now()));
      notifyListeners();
      return;
    } catch (e) {
      print('Lỗi khi xoa: $e');
    }
  }

  // Hàm so sánh chỉ phần ngày (bỏ qua giờ, phút, giây)
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Getter cho _is_loading
  bool get isLoading => _is_loading;

  // Setter cho _is_loading
  set isLoading(bool value) {
    _is_loading = value;
  }

  // Getter cho _repo
  Repository<String, Entry> get repo => entry_repo;

  // Setter cho _repo
  set repo(Repository<String, Entry> value) {
    entry_repo = value;
  }

  // Getter cho _items
  List<Entry> get items => _items;

  // Setter cho _items
  set items(List<Entry> value) {
    _items = value;
  }

  // Getter cho _entry_points
  List<dynamic> get entryPoints => _entry_points;

  // Setter cho _entry_points
  set entryPoints(List<dynamic> value) {
    _entry_points = value;
  }
}
