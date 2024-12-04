import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/help/compress_image.dart';
import 'package:myrefectly/main.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entry.dart';
import 'package:myrefectly/repository/api_service.dart';
import 'package:myrefectly/repository/repository.dart';
// Để lấy tên file
import 'package:path/path.dart' as path;

class Navigation_viewmodel extends ChangeNotifier {
  int page = 0;
  List<Color> _color_theme = all_color[theme_selected];
  int _is_hidden = 1;
  List<Color> get color_theme => _color_theme;
  int get is_hidden => _is_hidden;
  bool uploading = false;
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
      notifyListeners();

      File imageFile = File(pickedFile.path);

      Uint8List? webpImage = await compressIMG(imageFile);

      if (webpImage != null) {
        try {
          String newId = uuid.v1();

          // Tạo FormData cho request
          final formData = FormData.fromMap({
            'photo': newId, // Trường dữ liệu thêm vào form
            'file': MultipartFile.fromBytes(
              webpImage,
              filename: path.basenameWithoutExtension(pickedFile.path) + '.png',
            ),
          });

          // Thêm tiêu đề xác thực
          dio.options.headers['Authorization'] = 'Bearer $refresh_token';

          // Gửi request
          final response = await dio.post(
            '$server_root_url/addphoto',
            data: formData,
          );

          if (response.statusCode == 200) {
            // Xử lý phản hồi
            final data = response.data; // Phản hồi đã là JSON
            print('File uploaded successfully');
            print('Response data: $data');

            if (data != null && data.toString().isNotEmpty) {
              Photo photo = Photo(UUID: data, submitTime: DateTime.now());
              _repo = await Repository<String, Entry>(name: 'entry_box');
              await _repo.init();
              await _repo.add(photo.UUID, photo);
            }
          } else {
            print('Failed to upload file: ${response.statusCode}');
          }
        } catch (e) {
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
