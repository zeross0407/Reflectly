// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:myrefectly/help/effect.dart';
// import 'package:myrefectly/models/data.dart';
// import 'dart:typed_data';

// class ImageFromApi extends StatefulWidget {
//   final bool? need_loading_effect;
//   final String? url;
//   List<Uint8List>? parent_data;

//   ImageFromApi(
//       {super.key, this.need_loading_effect, this.url, this.parent_data});
//   @override
//   _ImageFromApiState createState() => _ImageFromApiState();
// }

// class _ImageFromApiState extends State<ImageFromApi>
//     with SingleTickerProviderStateMixin {
//   Uint8List? imageData; // Dữ liệu hình ảnh dưới dạng byte
//   String token =
//       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2NzEwZTc3NGRjMTE2MjMwNDc2NzM1ZjgiLCJqdGkiOiJkOTNlZTBiMi0zYWU0LTQwODItOTdiYS0yMmViZDJhYWIzZjMiLCJleHAiOjE3NDQ4ODU4NzYsImlzcyI6InlvdXJkb21haW4uY29tIiwiYXVkIjoieW91cmRvbWFpbi5jb20ifQ.RhZwKrLc-XyBTnLn7oe6RhAIhn765kSvFz--1ctOUmU';
//   late AnimationController _controller; // Controller cho Animation
//   late Animation<double> _opacityAnimation; // Animation cho opacity
//   late Animation<double> _scaleAnimation; // Animation cho scale
//   bool isImageLoaded = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchImage();

//     // Khởi tạo AnimationController
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 1000),
//     );

//     // Khởi tạo Animation cho opacity và scale
//     _opacityAnimation =
//         Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.decelerate, // Đường cong cho hiệu ứng scale
//     ));

//     _scaleAnimation =
//         Tween<double>(begin: 1.1, end: 1.0).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.decelerate, // Đường cong cho hiệu ứng scale
//     ));
//   }

//   // Hàm để gọi API và lấy hình ảnh
//   Future<void> fetchImage() async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//             '${server_root_url}${widget.url ?? '/api/Account/media/avatar.jpg'}'), // Thay thế với URL API của bạn
//         headers: {
//           'Authorization': 'Bearer $token', // Thêm token vào header
//         },
//       );

//       if (response.statusCode == 200) {
//         // Nếu thành công, lưu dữ liệu hình ảnh vào biến imageData
//         setState(() {
//           imageData = response.bodyBytes; // Lưu dữ liệu hình ảnh dưới dạng byte
//           isImageLoaded = true; // Đánh dấu hình ảnh đã được tải
//         });

//         // Bắt đầu hiệu ứng hiện dần
//         _controller.forward();
//       } else {
//         // Xử lý lỗi nếu không thành công
//         print('------Failed to load image: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e'); // In ra lỗi
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose(); // Giải phóng tài nguyên
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return imageData == null
//         ? Center(
//             child: widget.need_loading_effect ?? true
//                 ? LoadingCircles()
//                 : Container()) // Hiển thị loading khi đang tải ảnh
//         : Stack(
//             alignment: Alignment.center,
//             children: [
//               // Sử dụng AnimatedBuilder để lắng nghe thay đổi animation
//               AnimatedBuilder(
//                 animation: _controller,
//                 builder: (context, child) {
//                   return Opacity(
//                     opacity: _opacityAnimation.value,
//                     child: ScaleTransition(
//                       scale: _scaleAnimation,
//                       child: Image.memory(
//                         imageData!,
//                         fit: BoxFit.cover, // Điều chỉnh cách hiển thị ảnh
//                         width:
//                             double.infinity, // Lấp đầy chiều rộng của Container
//                         height:
//                             double.infinity, // Lấp đầy chiều cao của Container
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               // Hiển thị CircularProgressIndicator trên hình ảnh
//               //if (!isImageLoaded) LoadingCircles(),
//             ],
//           );
//   }
// }
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myrefectly/help/caching.dart';
import 'package:myrefectly/help/effect.dart';
import 'package:myrefectly/main.dart';
import 'package:myrefectly/models/data.dart';
import 'dart:typed_data';


class ImageFromApi extends StatefulWidget {
  final bool? need_loading_effect;
  final String? url;
  final List<Uint8List>? parent_data;
  final Function(Uint8List)? onImageLoaded; // Thêm callback

  ImageFromApi({
    super.key,
    this.need_loading_effect,
    this.url,
    this.parent_data,
    this.onImageLoaded,
  });

  @override
  _ImageFromApiState createState() => _ImageFromApiState();
}

class _ImageFromApiState extends State<ImageFromApi>
    with SingleTickerProviderStateMixin {
  Uint8List? imageData;
  String token = refresh_token; // Token của bạn
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  bool isImageLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchImage();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.decelerate),
    );

    _scaleAnimation = Tween<double>(begin: 1.1, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.decelerate),
    );
  }

  // Future<void> fetchImage() async {
  //   try {
  //     final response = await dio.get(
  //       '${widget.url ?? '/api/Account/media/avatar.png'}',
  //       options: Options(
  //         responseType: ResponseType.bytes,
  //         headers: {
  //           'Authorization': 'Bearer $refresh_token',
  //         },
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       setState(() {
  //         imageData = Uint8List.fromList(response.data);
  //         isImageLoaded = true;
  //       });

  //       // Thêm imageData vào parent_data và gọi callback nếu có
  //       if (widget.parent_data != null && imageData != null) {
  //         widget.parent_data!.add(imageData!);
  //       }
  //       if (widget.onImageLoaded != null && imageData != null) {
  //         widget.onImageLoaded!(imageData!);
  //       }

  //       _controller.forward();
  //     } else {
  //       print('------Failed to load image: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }
  Future<void> fetchImage() async {
    try {
      final response = await dio.get(
        widget.url ?? '/api/Account/media/avatar.png',
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            'Authorization': 'Bearer $refresh_token',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          imageData = Uint8List.fromList(response.data);
          isImageLoaded = true;
        });

        // Thêm imageData vào parent_data và gọi callback nếu có
        if (widget.parent_data != null && imageData != null) {
          widget.parent_data!.add(imageData!);
        }
        if (widget.onImageLoaded != null && imageData != null) {
          widget.onImageLoaded!(imageData!);
        }

        _controller.forward();
      } else if (response.statusCode == 304) {
        //final directory = await getTemporaryDirectory();
        //final cacheStore = cacheStore;
        //HiveCacheStore('${directory.path}/dio_cache');
        final cachedResponse = await cacheStore.get(caching_key[
                (server_root_url) +
                    (widget.url ?? '/api/Account/media/avatar.png')] ??
            "");

        bool a = await cacheStore.exists(_generateCacheKey(RequestOptions()));

        if (cachedResponse != null) {
          setState(() {
            imageData = Uint8List.fromList(cachedResponse.content!);
            isImageLoaded = true;
          });

          // Thêm imageData vào parent_data và gọi callback nếu có
          if (widget.parent_data != null && imageData != null) {
            widget.parent_data!.add(imageData!);
          }
          if (widget.onImageLoaded != null && imageData != null) {
            widget.onImageLoaded!(imageData!);
          }

          _controller.forward();
        }
      } else {
        print('------Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String _generateCacheKey(RequestOptions options) {
    final uri = options.uri;
    final path = uri.path;
    final queryParams = uri.queryParameters;
    final key = path +
        queryParams.toString(); // Ghép đường dẫn và tham số query lại thành key
    return key;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return imageData == null
        ? Center(
            child: widget.need_loading_effect ?? true
                ? LoadingCircles()
                : Container(),
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Image.memory(
                        imageData!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  );
                },
              ),
            ],
          );
  }
}
