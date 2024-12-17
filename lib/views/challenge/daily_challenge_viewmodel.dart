import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myrefectly/help/compress_image.dart';
import 'package:myrefectly/help/enum.dart';
import 'package:myrefectly/main.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/models/entry.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:path/path.dart';

class Daily_Challenge_Viewmodel extends ChangeNotifier {
  late Repository<String, HomeModel> _homeRepo;
  HomeModel? week_home;

  bool is_loading = true;
  late DateTime _checkinTime;

  late Timer _timer;
  Duration _timeLeft = const Duration();
  late Repository<String, Entry> _entryRepo;
  late Repository<String, Challenge> _challengeRepo;

  bool _isDisposed = false;

  List<File> image_list = [];
  final ImagePicker _picker = ImagePicker();

  bool uploading = false;
  ActionStatus actionStatus = ActionStatus.waiting;

  Daily_Challenge_Viewmodel() {
    _initData();
  }

  Future<void> _initData() async {
    _entryRepo = await Repository<String, Entry>(name: 'entry_box');
    _challengeRepo = await Repository<String, Challenge>(name: 'challenge_box');
    _homeRepo = await Repository<String, HomeModel>(name: 'home_box');

    await Future.wait([
      _entryRepo.init(),
      _challengeRepo.init(),
      _homeRepo.init(),
    ]);

    week_home = await _homeRepo.getAt(0);
    if (week_home?.todayChallenge == null) {
      Challenge firstChallenge = await _challengeRepo.getAt(0);
      week_home?.todayChallenge = firstChallenge;
      await _challengeRepo.delete(firstChallenge.id);
      await week_home?.save();
    }

    is_loading = false;
    _startTimer();
    notifyListeners();
  }

  Future<void> addImage() async {
    if (image_list.length >= 3) return;

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image_list.add(File(pickedFile.path));
    }
    notifyListeners();
  }

  void removeImage(int index) {
    if (index >= 0 && index < image_list.length) {
      image_list.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> CompleteChallenge() async {
    if (image_list.isEmpty) return;

    uploading = true;
    actionStatus = ActionStatus.running;
    notifyListeners();

    try {
      FormData formData = FormData.fromMap({
        'challengeId': week_home?.todayChallenge?.id,
        'description': week_home?.todayChallenge?.description,
      });

      for (var file in image_list) {
        Uint8List? webpImage = await compressIMG(file);
        if (webpImage != null) {
          formData.files.add(MapEntry(
            'Files',
            MultipartFile.fromBytes(
              webpImage,
              filename: '${basenameWithoutExtension(file.path)}.png',
            ),
          ));
        }
      }

      final response = await dio.post(
        '$server_root_url/api/Challenge/completechallenge',
        data: formData,
      );

      if (response.statusCode == 200) {
        var jsonData =
            response.data is String ? jsonDecode(response.data) : response.data;

        ChallengeResponse rs = ChallengeResponse.fromJson(jsonData);

        User_Challenge newChallenge = User_Challenge(
          UUID: rs.uuid,
          description: week_home?.todayChallenge?.description ?? '',
          submitTime: rs.submitTime.toLocal(),
          photos: rs.photos,
          challenge_id: rs.challengeId,
        );

        await _entryRepo.add(newChallenge.UUID, newChallenge);
        week_home?.challenge_completed[DateTime.now().weekday - 1] = 2;

        actionStatus = ActionStatus.success;
      } else {
        actionStatus = ActionStatus.failure;
        print('Failed to complete challenge: ${response.statusCode}');
      }
    } catch (e) {
      actionStatus = ActionStatus.failure;
      print('Error completing challenge: $e');
    } finally {
      uploading = false;
      notifyListeners();
    }
  }

  void _startTimer() {
    DateTime now = DateTime.now();
    DateTime endTime = DateTime(now.year, now.month, now.day, 23, 59, 0);

    if (now.isAfter(endTime)) {
      endTime = endTime.add(const Duration(days: 1));
    }

    _timeLeft = endTime.difference(now);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds <= 0) {
        _timer.cancel();
      } else {
        _timeLeft -= const Duration(seconds: 1);
      }

      if (!_isDisposed) {
        notifyListeners();
      }
    });
  }

  String formatTime(Duration duration) {
    String hours = duration.inHours.toString().padLeft(2, '0');
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer.cancel();
    _isDisposed = true;
    super.dispose();
  }

  DateTime get checkinTime => _checkinTime;
  Duration get timeLeft => _timeLeft;

  set checkinTime(DateTime value) {
    _checkinTime = value;
    notifyListeners();
  }
}

class ChallengeResponse {
  final List<String> photos;
  final String challengeId;
  final String description;
  final String uuid;
  final DateTime submitTime;
  final String userId;

  ChallengeResponse({
    required this.photos,
    required this.challengeId,
    required this.description,
    required this.uuid,
    required this.submitTime,
    required this.userId,
  });

  factory ChallengeResponse.fromJson(Map<String, dynamic> json) {
    return ChallengeResponse(
      photos: List<String>.from(json['Photos']),
      challengeId: json['challenge_id'],
      description: json['description'],
      uuid: json['UUID'],
      submitTime: DateTime.parse(json['SubmitTime']),
      userId: json['UserId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Photos': photos,
      'challenge_id': challengeId,
      'description': description,
      'UUID': uuid,
      'SubmitTime': submitTime.toIso8601String(),
      'UserId': userId,
    };
  }
}
