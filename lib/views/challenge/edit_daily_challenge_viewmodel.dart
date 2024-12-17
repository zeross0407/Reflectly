import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myrefectly/help/compress_image.dart';
import 'package:myrefectly/help/enum.dart';
import 'package:myrefectly/main.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/models/entry.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Edit_Daily_Challenge_Viewmodel extends ChangeNotifier {
  final String ID;
  late User_Challenge dailyChallenge_Complete;
  bool is_loading = true;
  bool has_changed = false;
  bool img_loaded = false;

  late Repository<String, Entry> _repo_entry;
  late Repository<String, Challenge> _challenge_repo;

  Edit_Daily_Challenge_Viewmodel({required this.ID}) {
    _init_data();
  }

  Future<void> _init_data() async {
    _repo_entry = await Repository<String, Entry>(name: 'entry_box');
    _challenge_repo =
        await Repository<String, Challenge>(name: 'Challenge_box');
    await _challenge_repo.init();
    await _repo_entry.init();

    dailyChallenge_Complete = await _repo_entry.getById(ID) as User_Challenge;
    get_image();
    is_loading = false;

    notifyListeners();
  }

  List<File> image_list = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> AddImage() async {
    if (image_list.length >= 3) return;
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image_list.add(File(pickedFile.path));
    } else {
      print('No image selected.');
    }

    notifyListeners();
  }

  void removeImage(int index) {
    if (image_list.length <= index) return;
    image_list.removeAt(index);
  }

  // Future<void> get_image() async {
  //   try {
  //     for (var i = 0; i < dailyChallenge_Complete.photos.length; i++) {
  //       var response = await http.get(
  //         Uri.parse(
  //             '${server_root_url}/api/Account/media/${dailyChallenge_Complete.photos[i]}'),
  //         headers: {
  //           'Authorization': 'Bearer $refresh_token',
  //         },
  //       );

  //       if (response.statusCode == 200) {
  //         Uint8List data = response.bodyBytes;
  //         // Lấy đường dẫn thư mục tạm thời
  //         final directory = await getTemporaryDirectory();
  //         final filePath = '${directory.path}/temp_image$i.jpg';

  //         // Tạo file và ghi dữ liệu
  //         final file = File(filePath);
  //         await file.writeAsBytes(data);
  //         image_list.add(file);
  //         img_loaded = true;
  //         notifyListeners();
  //       } else {
  //         print('------Failed to load image: ${response.statusCode}');
  //       }
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }
  Future<void> get_image() async {
    try {
      for (var i = 0; i < dailyChallenge_Complete.photos.length; i++) {
        final url =
            '${server_root_url}/api/Account/media/${dailyChallenge_Complete.photos[i]}';

        final response = await dio.get(
          url,
          options: Options(
            headers: {
              'Authorization': 'Bearer $refresh_token',
            },
            responseType: ResponseType.bytes, // Lấy dữ liệu dạng bytes
          ),
        );

        if (response.statusCode == 200) {
          Uint8List data = Uint8List.fromList(response.data);

          // Lấy đường dẫn thư mục tạm thời
          final directory = await getTemporaryDirectory();
          final filePath = '${directory.path}/temp_image$i.jpg';

          // Tạo file và ghi dữ liệu
          final file = File(filePath);
          await file.writeAsBytes(data);

          image_list.add(file);
          img_loaded = true;
          notifyListeners();
        } else {
          print('------Failed to load image: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  bool uploading = false;
  ActionStatus actionStatus = ActionStatus.waiting;

  // Future<void> savechange() async {
  //   if (image_list.length < 1) return;
  //   // uploading = await true;

  //   actionStatus = ActionStatus.running;
  //   notifyListeners();

  //   var url = Uri.parse('$server_root_url/api/Challenge/updatechallenge');

  //   var request = http.MultipartRequest('POST', url)
  //     ..fields['user_challenge_id'] = dailyChallenge_Complete.UUID;

  //   for (var file in image_list) {
  //     var stream = http.ByteStream(file.openRead());
  //     var length = await file.length();

  //     var multipartFile = http.MultipartFile('Files', stream, length,
  //         filename: basename(file.path));
  //     request.files.add(multipartFile);
  //   }
  //   request.headers['Authorization'] = await 'Bearer $refresh_token';

  //   var response = await request.send();

  //   var responseData = await http.Response.fromStream(response);

  //   if (response.statusCode == 200) {
  //     print('edit Challenge completed and files uploaded.');

  //     Map<String, dynamic> jsonMap = jsonDecode(responseData.body);
  //     ChallengeResponse rs = ChallengeResponse.fromJson(jsonMap);
  //     dailyChallenge_Complete.photos = rs.photos;
  //     await dailyChallenge_Complete.save();
  //     await clearTemporaryDirectory();
  //     actionStatus = await ActionStatus.success;
  //     notifyListeners();
  //   } else {
  //     print('Failed to complete challenge: ${response.statusCode}');
  //     actionStatus = ActionStatus.failure;
  //   }
  //   uploading = await false;
  //   //actionStatus = ActionStatus.success;
  //   notifyListeners();
  // }

  Future<void> savechange() async {
    if (image_list.isEmpty) return;

    actionStatus = ActionStatus.running;
    notifyListeners();

    var url = '$server_root_url/api/Challenge/updatechallenge';

    try {
      // Khởi tạo Dio

      // Tạo dữ liệu body và headers
      FormData formData = FormData.fromMap({
        'user_challenge_id': dailyChallenge_Complete.UUID,
        // 'Files': [
        //   for (var file in image_list)
        //     await MultipartFile.fromFile(
        //       file.path,
        //       filename: basename(file.path),
        //     ),
        // ],
      });

      for (var file in image_list) {
        Uint8List? webpImage = await compressIMG(file);
        if (webpImage != null) {
          formData.files.add(MapEntry(
            'Files',
            MultipartFile.fromBytes(
              webpImage,
              filename: '${basenameWithoutExtension(file.path)}.png',
            ),
          ));
        }
      }

      Options options = Options(
        headers: {
          'Authorization': 'Bearer $refresh_token',
        },
      );

      // Gửi request POST
      var response = await dio.post(url, data: formData, options: options);

      if (response.statusCode == 200) {
        print('Edit Challenge completed and files uploaded.');

        // Parse response và cập nhật dữ liệu

        var jsonData =
            response.data is String ? jsonDecode(response.data) : response.data;
        ChallengeResponse rs = ChallengeResponse.fromJson(jsonData);
        dailyChallenge_Complete.photos = rs.photos;

        await dailyChallenge_Complete.save();
        await clearTemporaryDirectory();

        actionStatus = ActionStatus.success;
        notifyListeners();
      } else {
        print('Failed to complete challenge: ${response.statusCode}');
        actionStatus = ActionStatus.failure;
        notifyListeners();
      }
    } catch (e) {
      print('Error while uploading: $e');
      actionStatus = ActionStatus.failure;
      notifyListeners();
    } finally {
      uploading = false;
      notifyListeners();
    }
  }

  Future<void> clearTemporaryDirectory() async {
    // Lấy đường dẫn thư mục tạm
    final directory = await getTemporaryDirectory();

    // Kiểm tra nếu thư mục tồn tại
    if (await directory.exists()) {
      // Duyệt qua tất cả các file và thư mục con trong thư mục tạm
      final files = directory.listSync();
      for (var fileOrDir in files) {
        try {
          // Xóa từng file hoặc thư mục con
          await fileOrDir.delete(recursive: true);
        } catch (e) {
          print("Không thể xóa ${fileOrDir.path}: $e");
        }
      }
    }
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
class ChallengeResponse {
  final List<String> photos;
  final String challengeId;
  final String uuid;
  final DateTime submitTime;
  final String userId;

  ChallengeResponse({
    required this.photos,
    required this.challengeId,
    required this.uuid,
    required this.submitTime,
    required this.userId,
  });

  // Hàm để chuyển từ JSON thành đối tượng
  factory ChallengeResponse.fromJson(Map<String, dynamic> json) {
    return ChallengeResponse(
      photos: List<String>.from(json['Photos']),
      challengeId: json['challenge_id'],
      uuid: json['UUID'],
      submitTime: DateTime.parse(json['SubmitTime']),
      userId: json['UserId'],
    );
  }
}
