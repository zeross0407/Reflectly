import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:myrefectly/help/compress_image.dart';
import 'package:myrefectly/help/enum.dart';
import 'package:myrefectly/main.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/models/entry.dart';
import 'package:myrefectly/models/reflection.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ReflectionShare_Viewmodel extends ChangeNotifier {
  bool loading = true;
  //String reflection = "";
  late Repository<String, Entry> _repo_entry;
  Reflection reflection;
  String ref = "";

  List<File> image_list = [];

  ReflectionShare_Viewmodel({required this.reflection}) {
    _init_data();
  }

  Future<void> _init_data() async {
    _repo_entry = await Repository<String, Entry>(name: 'entry_box');
    await _repo_entry.init();
    loading = false;

    notifyListeners();
  }

  bool uploading = false;
  ActionStatus actionStatus = ActionStatus.waiting;

  Future<void> Complete_share() async {
    if (ref.length < 1) return;
    uploading = await true;

    actionStatus = ActionStatus.running;
    notifyListeners();

    var url = Uri.parse('$server_root_url/api/UserReflection/sharereflection');

    var request = http.MultipartRequest('POST', url)
      ..fields['ReflectionId'] = reflection.id
      ..fields['UserReflection'] =
          reflection.description.replaceFirst('##', '#$ref#');
    for (var file in image_list) {
      Uint8List? webpImage = await compressIMG(file);
      var stream = http.ByteStream.fromBytes(webpImage!);
      var length = webpImage.length;

      var multipartFile = http.MultipartFile('Files', stream, length,
          filename: basenameWithoutExtension(file.path) + '.png');
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
          submitTime: rs.submitTime.toLocal(),
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
