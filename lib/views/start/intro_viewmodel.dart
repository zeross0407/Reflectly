import 'package:flutter/material.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/repository/repository.dart';

class Intro_Viewmodel extends ChangeNotifier {
  bool loading = true;
  late Repository<int, User> _user_repo;
  User? user;
  Intro_Viewmodel() {
    _init_data();
  }

  Future<void> _init_data() async {
    _user_repo = await Repository<int, User>(name: 'user_box');
    await _user_repo.init();
    try {
      user = await _user_repo.getAt(0);
    } catch (e) {}
    loading = await false;
    notifyListeners();
  }
}
