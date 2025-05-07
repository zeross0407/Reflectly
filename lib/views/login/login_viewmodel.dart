import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myrefectly/help/enum.dart';
import 'package:myrefectly/main.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/models/entry.dart';
import 'package:myrefectly/models/response_model.dart';
import 'package:myrefectly/repository/api_service.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:http/http.dart' as http;

class Login_Viewmodel extends ChangeNotifier {
  String email = "";
  String password = "";
  bool logging_in = false;
  int status_code = 0;
  late Repository<String, User> _repo;
  late Repository<String, Entry> _repo_entry;
  late Repository<String, Activity> _repo_activity;
  late Repository<String, Feeling> _repo_feeling;
  late User user;
  final apiService = ApiService(baseUrl: server_root_url + "/api/Account");
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  ActionStatus action = ActionStatus.waiting;
  Login_Viewmodel() {
    _init_data();
  }

  Future<void> _init_data() async {
    _repo = await Repository<String, User>(name: 'user_box');
    await _repo.init();
    user = await _repo.getAt(0);
    _repo_entry = await Repository<String, Entry>(name: 'entry_box');
    await _repo_entry.init();
    _repo_activity = await Repository<String, Activity>(name: 'activity_box');
    await _repo_activity.init();
    _repo_feeling = await Repository<String, Feeling>(name: 'feeling_box');
    await _repo_feeling.init();
    notifyListeners();
  }

  Future<int> request_login() async {
    logging_in = true;
    notifyListeners();
    if (!emailRegex.hasMatch(email)) {
      logging_in = false;
      notifyListeners();
      return -1;
    }

    final response = await http.post(
      Uri.parse('${server_root_url}/api/Account/login'),
      headers: {
        'Content-Type':
            'application/json', // Đặt Content-Type là application/json
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      UserData userData = userDataFromJson(response.body);
      userData.moodCheckinList.forEach(
        (element) async {
          await _repo_entry.add(
              element.uuid,
              MoodCheckin(
                  UUID: element.uuid,
                  submitTime: element.submitTime.toLocal(),
                  title: element.title,
                  description: element.description,
                  mood: element.mood.toDouble(),
                  activities: element.activities,
                  feelings: element.feelings));
        },
      );
      userData.photoList.forEach(
        (element) async {
          await _repo_entry.add(
            element.uuid,
            Photo(UUID: element.uuid, submitTime: element.submitTime.toLocal()),
          );

          // if (element.containsKey('uuid')) {
          //   await _repo_entry.add(
          //     element['uuid'], // Truy cập giá trị của uuid
          //     Photo(
          //         UUID: element['uuid'],
          //         submitTime: DateTime.parse(element['submitTime']).toLocal()),
          //   );
          // } else {
          //   print('Không tìm thấy uuid trong element: $element');
          // }
        },
      );

      userData.userChallengeList.forEach(
        (element) async {
          await _repo_entry.add(
              element.uuid,
              User_Challenge(
                  UUID: element.uuid,
                  description: element.description,
                  submitTime: element.submitTime.toLocal(),
                  photos: element.photos,
                  challenge_id: element.challengeId));
        },
      );
      userData.userReflectionList.forEach(
        (element) async {
          await _repo_entry.add(
              element.uuid,
              User_reflection(
                  UUID: element.uuid,
                  submitTime: element.submitTime.toLocal(),
                  photos: element.photos,
                  reflection: element.reflection,
                  reflection_id: element.reflectionId));
        },
      );
      userData.voicenoteList.forEach(
        (element) async {
          await _repo_entry.add(
            element.uuid,
            VoiceNote(
              UUID: element.uuid,
              submitTime: element.submitTime.toLocal(),
              description: element.description,
              title: element.title,
            ),
          );
        },
      );
      userData.activityList.forEach(
        (element) async {
          await _repo_activity.add(
              element.uuid,
              Activity(
                  UUID: element.uuid,
                  icon: element.icon,
                  title: element.title,
                  archive: element.archive));
        },
      );
      userData.feelingList.forEach(
        (element) async {
          await _repo_feeling.add(
              element.uuid,
              Feeling(
                  UUID: element.uuid,
                  icon: element.icon,
                  title: element.title,
                  archive: element.archive));
        },
      );

      user.email = userData.email;
      user.user_name = userData.username;
      user.refresh_token = userData.refreshToken;
      user.save();
      refresh_token = userData.refreshToken;
    } else {
      logging_in = false;
      action = ActionStatus.failure;
      notifyListeners();
      return -1;
    }

    logging_in = false;

    notifyListeners();

    return 1;
  }
}
