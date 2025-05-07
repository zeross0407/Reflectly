import 'package:flutter/material.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/repository/repository.dart';

class Root_Viewmodel extends ChangeNotifier {
  bool loading = true;

  late Repository<int, User> _user_repo;

  late User user;
  Root_Viewmodel() {
    _init_data();
  }

  Future<void> _init_data() async {
    _user_repo = await Repository<int, User>(name: 'user_box');
    await _user_repo.init();
    try {
      user = await _user_repo.getAt(0);
      loading = false;
      notifyListeners();
    } catch (e) {
      print("");
    }
  }
}
