import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myrefectly/main.dart';
import 'package:myrefectly/models/data.dart' as data;
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/models/entry.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:myrefectly/repository/sync.dart';

class MoodCheck_in_Viewmodel extends ChangeNotifier {
  DateTime _checkin_time = DateTime.now();
  double mood = 2.0001;
  List<int> _activities = [];
  List<bool> _activities_widget = List.generate(
    data.activities_list_default.length,
    (index) => false,
  );
  List<int> _feelings = [];
  List<bool> _feelings_widget = List.generate(
    data.feelings_list_default.length,
    (index) => false,
  );
  String _title = "";
  String _notes = "";
  late Repository<String, Entry> _repo;
  late Repository<String, Activity> _activity_repo;
  late Repository<String, Feeling> _feeling_repo;
  MoodCheck_in_Viewmodel() {
    _init_data();
  }

  Future<void> _init_data() async {
    _repo = await Repository<String, Entry>(name: 'entry_box');
    await _repo.init();
    _activity_repo = await Repository<String, Activity>(name: 'activity_box');
    await _activity_repo.init();
    _feeling_repo = await Repository<String, Feeling>(name: 'feeling_box');
    await _feeling_repo.init();

    List<Activity> active_activity = await _activity_repo.getAll();

    active_activity = active_activity.where((element) {
      return !element.archive;
    }).toList();

    List<Feeling> active_feeling = await _feeling_repo.getAll();

    active_feeling = active_feeling.where((element) {
      return !element.archive;
    }).toList();

    all_activity = activities_list_default + active_activity;
    all_feeling = feelings_list_default + active_feeling;

    notifyListeners();
  }

  Future<bool> submit_checkin() async {
    MoodCheckin e = await MoodCheckin(
        UUID: uuid.v1(),
        submitTime: _checkin_time,
        title: _title,
        description: _notes,
        activities: List.generate(
          selected_activity.length,
          (index) => selected_activity[index].UUID,
        ),
        feelings: List.generate(
          selected_feeling.length,
          (index) => selected_feeling[index].UUID,
        ),
        mood: mood);

    try {
      await _repo.add(e.UUID, e);
      Data_Sync data = Data_Sync(
          id: uuid.v1(),
          name: CollectionEnum.MoodCheckin.index,
          action: ActionEnum.Create.index,
          jsonData: jsonEncode(e.toJson()),
          timeStamp: _checkin_time);
      Data_Sync_Trigger().syncDataWithServer(data);
    } catch (e) {
      print('Lỗi khi thêm dữ liệu: $e');
    }

    notifyListeners();

    return false;
  }

////////////////////////////////////////////////////  ACTIVITY  ////////////////////////////////////////////////////////////////////

  List<Activity> all_activity = [];

  int icon_selected = -1;
  void set_icon(int index) {
    icon_selected = index;
    notifyListeners();
  }

  String new_activity_title = "";

  Future<void> create_new_activity() async {
    if (new_activity_title == "" || icon_selected == -1) return;
    Activity a = await Activity(
        UUID: uuid.v1(),
        icon: icon_selected,
        title: new_activity_title,
        archive: false);
    await _activity_repo.add(a.UUID, a);
    List<Activity> user_activity = await _activity_repo.getAll();
    all_activity = activities_list_default + user_activity;

    Data_Sync_Trigger().syncDataWithServer(Data_Sync(
        id: uuid.v1(),
        name: CollectionEnum.Activity.index,
        action: ActionEnum.Create.index,
        jsonData: jsonEncode(a),
        timeStamp: DateTime.now()));

    notifyListeners();
  }

////////////////////////////////////////////////////  FEELING  ////////////////////////////////////////////////////////////////////
  List<Feeling> all_feeling = [];

  Future<void> create_new_feeling() async {
    if (new_activity_title == "" || icon_selected == -1) return;
    Feeling f = await Feeling(
        UUID: uuid.v1(),
        icon: icon_selected,
        title: new_activity_title,
        archive: false);
    await _feeling_repo.add(f.UUID, f);
    all_feeling = feelings_list_default + await _feeling_repo.getAll();

    Data_Sync_Trigger().syncDataWithServer(Data_Sync(
        id: uuid.v1(),
        name: CollectionEnum.Feeling.index,
        action: ActionEnum.Create.index,
        jsonData: jsonEncode(f),
        timeStamp: DateTime.now()));
    notifyListeners();
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  List<Activity> selected_activity = [];
  List<Feeling> selected_feeling = [];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Getters
  DateTime get checkin_time => _checkin_time;

  List<int> get activities => _activities;
  List<bool> get activities_widget => _activities_widget;
  List<int> get feelings => _feelings;
  List<bool> get feelings_widget => _feelings_widget;
  String get title => _title;
  String get notes => _notes;

  // Setters
  set checkin_time(DateTime value) {
    _checkin_time = value;
    notifyListeners();
  }

  set activities(List<int> value) {
    _activities = value;
    notifyListeners();
  }

  set activities_widget(List<bool> value) {
    _activities_widget = value;
    notifyListeners();
  }

  set feelings(List<int> value) {
    _feelings = value;
    notifyListeners();
  }

  set feelings_widget(List<bool> value) {
    _activities_widget = value;
    notifyListeners();
  }

  set title(String value) {
    _title = value;
    notifyListeners();
  }

  set notes(String value) {
    _notes = value;
    notifyListeners();
  }
}
