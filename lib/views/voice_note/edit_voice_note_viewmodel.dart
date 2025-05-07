import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myrefectly/main.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/models/entry.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:myrefectly/repository/sync.dart';

class Edit_VoiceNote_Viewmodel extends ChangeNotifier {
  late VoiceNote voicenote;
  late VoiceNote voicenote_temp;
  late String _id;
  bool is_loading = true;

  late Repository<String, Entry> _repo;
  Check_in_Viewmodel() {
    _init_data();
  }

  Edit_VoiceNote_Viewmodel(String id) {
    _id = id;
    _init_data();
    notifyListeners();
  }

  Future<void> _init_data() async {
    _repo = Repository<String, Entry>(name: 'entry_box');
    await _repo.init();

    voicenote = await _repo.getById(_id) as VoiceNote;
    voicenote_temp = VoiceNote(
        UUID: voicenote.UUID,
        submitTime: voicenote.submitTime,
        title: voicenote.title,
        description: voicenote.description);
    is_loading = await false;
    notifyListeners();
  }

  Future<bool> submit_update() async {
    _repo.add(voicenote.UUID, voicenote_temp);
    Data_Sync_Trigger().syncDataWithServer(Data_Sync(
        id: uuid.v1(),
        name: CollectionEnum.VoiceNote.index,
        action: ActionEnum.Update.index,
        jsonData: jsonEncode(voicenote_temp),
        timeStamp: DateTime.now()));
    return true;
  }
}
