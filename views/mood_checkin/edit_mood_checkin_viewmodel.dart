import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myrefectly/main.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/models/entry.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:myrefectly/repository/sync.dart';

class Edit_Mood_Checkin_Viewmodel extends ChangeNotifier {
  late MoodCheckin moodCheckin;
  late MoodCheckin moodCheckin_temp;
  List<Activity> all_activity = [];
  List<Feeling> all_feeling = [];
  Map<String, Activity> map_activity = {};
  Map<String, Feeling> map_feeling = {};
  late String _id;
  bool is_loading = true;
  late Repository<String, Activity> _activity_repo;
  late Repository<String, Feeling> _feeling_repo;

  late Repository<String, Entry> _repo;
  Check_in_Viewmodel() {
    _init_data();
  }

  Edit_Mood_Checkin_Viewmodel(String id) {
    _id = id;
    _init_data();
    notifyListeners();
  }

  Future<void> _init_data() async {
    _repo = Repository<String, Entry>(name: 'entry_box');
    await _repo.init();
    _activity_repo = await Repository<String, Activity>(name: 'activity_box');
    await _activity_repo.init();
    _feeling_repo = await Repository<String, Feeling>(name: 'feeling_box');
    await _feeling_repo.init();

    all_feeling = feelings_list_default + await _feeling_repo.getAll();
    all_activity = activities_list_default + await _activity_repo.getAll();
    map_activity = Map.fromIterable(
      all_activity,
      key: (item) => item.UUID,
      value: (item) => item,
    );
    map_feeling = Map.fromIterable(
      all_feeling,
      key: (item) => item.UUID,
      value: (item) => item,
    );

    moodCheckin = await _repo.getById(_id) as MoodCheckin;
    moodCheckin_temp = MoodCheckin(
        UUID: moodCheckin.UUID,
        submitTime: moodCheckin.submitTime,
        title: moodCheckin.title,
        mood: moodCheckin.mood,
        activities: moodCheckin.activities,
        feelings: moodCheckin.feelings,
        description: moodCheckin.description);
    is_loading = await false;
    notifyListeners();
  }

  Future<bool> submit_update() async {
    _repo.add(moodCheckin.UUID, moodCheckin_temp);
    Data_Sync_Trigger().syncDataWithServer(Data_Sync(
        id: uuid.v1(),
        name: CollectionEnum.MoodCheckin.index,
        action: ActionEnum.Update.index,
        jsonData: jsonEncode(moodCheckin_temp),
        timeStamp: DateTime.now()));
    return true;
  }
}
