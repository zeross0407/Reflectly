import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myrefectly/main.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:myrefectly/repository/sync.dart';

class Archive_Viewmodel<T> extends ChangeNotifier {
  late Repository<String, T> _activity_repo;

  Archive_Viewmodel() {
    _init_data();
  }

  List<T> icon = [];
  List<T> icon_active = [];
  List<T> icon_archive = [];

  Future<void> _init_data() async {
    String box_name = T == Activity ? 'activity_box' : 'feeling_box';

    // Kiểm tra xem Box đã mở chưa, nếu chưa thì mở
    if (!Hive.isBoxOpen(box_name)) {
      await Hive.openBox<T>(box_name);
    }

    _activity_repo = Repository<String, T>(name: box_name);
    await filt_data();
    notifyListeners();
  }

  Future<void> filt_data() async {
    icon = [];
    icon_active = [];
    icon_archive = [];
// Sau khi đảm bảo box đã mở, khởi tạo và lấy dữ liệu
    await _activity_repo.init();
    icon = await _activity_repo.getAll();

    for (var activity in icon) {
      if (activity is Activity) {
        // Nếu là Activity, kiểm tra thuộc tính archive
        if (!activity.archive) {
          icon_active.add(activity);
        } else {
          icon_archive.add(activity);
        }
      }
      ///////
      else if (activity is Feeling) {
        if (!activity.archive) {
          icon_active.add(activity);
        } else {
          icon_archive.add(activity);
        }
      }
    }
  }

  Future<void> toggle_archive_item(String id) async {
    T item = await _activity_repo.getById(id);
    if (item is Activity) {
      item.archive = await !item.archive;
      await item.save();
    } else if (item is Feeling) {
      item.archive = !item.archive;
      await item.save();
    }
    await filt_data();

    Data_Sync_Trigger().syncDataWithServer(Data_Sync(
        id: uuid.v1(),
        name: item is Activity
            ? CollectionEnum.Activity.index
            : CollectionEnum.Feeling.index,
        action: ActionEnum.Update.index,
        jsonData: id,
        timeStamp: DateTime.now()));
    notifyListeners();
  }
}
