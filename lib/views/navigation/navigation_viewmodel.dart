import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/help/compress_image.dart';
import 'package:myrefectly/help/enum.dart';
import 'package:myrefectly/main.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entry.dart';
import 'package:myrefectly/network/network_service.dart';
import 'package:myrefectly/repository/api_service.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:myrefectly/views/entries/entries_viewmodel.dart';
// Để lấy tên file
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class Navigation_viewmodel extends ChangeNotifier {
  int page = 0;
  List<Color> _color_theme = all_color[theme_selected];
  int _is_hidden = 1;
  List<Color> get color_theme => _color_theme;
  int get is_hidden => _is_hidden;
  bool uploading = false;
  ActionStatus actionStatus = ActionStatus.waiting;
  void updateUI() {
    // Thay đổi trạng thái và thông báo cho các widget lắng nghe
    _color_theme = all_color[theme_selected];
    notifyListeners();
  }

  void hidden_nav(int set_hidden) {
    _is_hidden = set_hidden;
    notifyListeners();
  }

  File? _image;
  final ImagePicker _picker = ImagePicker();

  late Repository<String, Entry> _repo;
  final apiService = ApiService(baseUrl: server_root_url + "/api/Account");

  Navigation_viewmodel() {
    _init_data();
    NetworkService networkMonitor = NetworkService();
    networkMonitor.startMonitoring();
  }

  Future<void> _init_data() async {
    _repo = await Repository<String, Entry>(name: 'entry_box');
    await _repo.init();
    notifyListeners();
  }

  void go_to(int index) {
    page = index;
    notifyListeners();
  }

  Future<void> uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      uploading = true;
      actionStatus = await ActionStatus.running;
      notifyListeners();

      File imageFile = File(pickedFile.path);

      Uint8List? webpImage = await compressIMG(imageFile);

      if (webpImage != null) {
        try {
          String newId = uuid.v1();

          final formData = FormData.fromMap({
            'photo': newId,
            'file': MultipartFile.fromBytes(
              webpImage,
              filename: path.basenameWithoutExtension(pickedFile.path) + '.png',
            ),
          });

          dio.options.headers['Authorization'] = 'Bearer $refresh_token';

          final response = await dio.post(
            '$server_root_url/addphoto',
            data: formData,
          );

          if (response.statusCode == 200) {
            final data = response.data;
            print('File uploaded successfully');
            print('Response data: $data');

            if (data != null && data.toString().isNotEmpty) {
              Photo photo = Photo(UUID: data, submitTime: DateTime.now());
              _repo = await Repository<String, Entry>(name: 'entry_box');
              await _repo.init();
              await _repo.add(photo.UUID, photo);
            }
            actionStatus = ActionStatus.success;
            notifyListeners();
          } else {
            print('Failed to upload file: ${response.statusCode}');
          }
        } catch (e) {
          actionStatus = ActionStatus.failure;
          notifyListeners();
          print('Error during file upload: $e');
        }
      } else {
        print('Failed to convert image');
      }
    } else {
      print('No image selected.');
    }

    uploading = false;
    notifyListeners();


  }
}
