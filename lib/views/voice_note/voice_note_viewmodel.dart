import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myrefectly/main.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/models/entry.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:myrefectly/repository/sync.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceNote_Viewmodel extends ChangeNotifier {
  bool updating = false;
  int status_code = 0;
  late Repository<String, Entry> _repo;

  bool loading = true;

  // Speech to Text
  SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';
  String title = "";
  bool is_listening = false;

  VoiceNote_Viewmodel() {
    _init_data();
    _initSpeech();
  }

  // Khởi tạo dữ liệu và quyền lắng nghe giọng nói
  void _initSpeech() async {
    speechEnabled = await speechToText.initialize();
    notifyListeners();
  }

  Future<void> _init_data() async {
    _repo = await Repository<String, Entry>(name: 'entry_box');
    await _repo.init();

    loading = false;
    notifyListeners();
  }

  void startListening() async {
    is_listening = true;
    notifyListeners();
    await speechToText.listen(onResult: _onSpeechResult);
  }

  void stopListening() async {
    is_listening = false;
    await speechToText.stop();
    notifyListeners();
  }

  void _onSpeechStatusChanged(String status) {
    if (!speechToText.isListening) {
      //notifyListeners();
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    lastWords = result.recognizedWords;
    print(lastWords);
    notifyListeners();
  }

  Future<int> save_voice_note() async {
    if (lastWords.isEmpty) return -1;

    VoiceNote vn = VoiceNote(
      UUID: uuid.v1(),
      description: lastWords,
      title: title,
      submitTime: DateTime.now(),
    );

    await _repo.add(vn.UUID, vn);

    Data_Sync entry_sync = Data_Sync(
      id: uuid.v1(),
      name: CollectionEnum.VoiceNote.index,
      action: ActionEnum.Create.index,
      jsonData: jsonEncode(vn),
      timeStamp: DateTime.now(),
    );

    Data_Sync_Trigger().syncDataWithServer(entry_sync);
    notifyListeners();
    return 1;
  }
}
