import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:myrefectly/help/enum.dart';
import 'package:myrefectly/main.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entry.dart';
import 'package:myrefectly/models/reflection.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Edit_Reflection_ViewModel extends ChangeNotifier {
  bool loading = true;
  late Repository<String, Entry> _repo_entry;
  List<File> image_list = [];
  late User_reflection user_reflection;
  String ref = "";
  bool img_loaded = false;
  String UUID;
  Edit_Reflection_ViewModel({required this.UUID}) {
    _init_data();
  }

  Future<void> _init_data() async {
    _repo_entry = await Repository<String, Entry>(name: 'entry_box');
    await _repo_entry.init();
    user_reflection = await _repo_entry.getById(UUID) as User_reflection;
    loading = await false;
    get_image();
    notifyListeners();
  }

  Future<void> get_image() async {
    try {
      for (var i = 0; i < user_reflection.photos.length; i++) {
        var response = await http.get(
          Uri.parse(
              '${server_root_url}/api/Account/media/${user_reflection.photos[i]}'),
          headers: {
            'Authorization': 'Bearer $refresh_token',
          },
        );

        if (response.statusCode == 200) {
          Uint8List data = response.bodyBytes;
          // Lấy đường dẫn thư mục tạm thời
          final directory = await getTemporaryDirectory();
          final filePath = '${directory.path}/temp_image$i.jpg';

          // Tạo file và ghi dữ liệu
          final file = File(filePath);
          await file.writeAsBytes(data);
          image_list.add(file);
          
          notifyListeners();
        } else {
          print('------Failed to load image: ${response.statusCode}');
        }
      }
      img_loaded = true;
    } catch (e) {
      print('Error: $e');
    }
  }

  String replaceTextBetweenHashes(String input, String replacement) {
    final regex = RegExp(r'#(.*?)#'); // Tìm chuỗi giữa cặp dấu #
    return input.replaceAllMapped(regex, (match) => '#$replacement#');
  }

  bool uploading = false;
  ActionStatus actionStatus = ActionStatus.waiting;
  bool image_changed = false;

  Future<void> Save_Changes() async {
    uploading = await true;

    actionStatus = ActionStatus.running;
    notifyListeners();

    var url = Uri.parse('$server_root_url/api/UserReflection/editreflection');

    var request = http.MultipartRequest('POST', url)
      ..fields['ReflectionId'] = user_reflection.reflection_id
      ..fields['UserReflection'] =
          replaceTextBetweenHashes(user_reflection.reflection, ref)
      ..fields['Id'] = user_reflection.UUID;
    for (var file in image_list) {
      var stream = http.ByteStream(file.openRead());
      var length = await file.length();

      var multipartFile = http.MultipartFile('Files', stream, length,
          filename: basename(file.path));
      request.files.add(multipartFile);
    }
    request.headers['Authorization'] = await 'Bearer $refresh_token';

    var response = await request.send();

    var responseData = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      print('Challenge completed and files uploaded.');
      Map<String, dynamic> jsonMap = jsonDecode(responseData.body);
      ReflectionResponse rs = ReflectionResponse.fromJson(jsonMap);

      User_reflection data = await User_reflection(
          UUID: rs.uuid,
          reflection: rs.reflection,
          submitTime: rs.submitTime,
          photos: rs.photos,
          reflection_id: rs.reflectionId);
      await _repo_entry.add(data.UUID, data);
    } else {
      print('Failed to complete challenge: ${response.statusCode}');
    }
    uploading = await false;
    actionStatus = ActionStatus.success;
    notifyListeners();
  }
}
