import 'package:flutter/material.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/repository/repository.dart';

class Categories_Viewmodel extends ChangeNotifier {

  bool loading = true;
  late int wallpaper_style;
  int category_selected = 0;
  late User user;
  late Repository<String, User> _user_repo;

  Categories_Viewmodel() {
    _init_data();
  }

  Future<void> _init_data() async {
    _user_repo = await Repository<String, User>(name: 'user_box');
    await _user_repo.init();
    user = await _user_repo.getAt(0);

    wallpaper_style = user.quotesTheme;
    loading = false;
    notifyListeners();
  }

  void change_wallpaper(int index) {
    user.quotesTheme = index;
    user.save();
    notifyListeners();
  }
}
