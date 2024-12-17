// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:typed_data';

// import 'package:myrefectly/page/reflectionshare.dart';

// class ImageFromApi extends StatefulWidget {
//   @override
//   _ImageFromApiState createState() => _ImageFromApiState();
// }

// class _ImageFromApiState extends State<ImageFromApi>
//     with SingleTickerProviderStateMixin {
//   Uint8List? imageData; // Dữ liệu hình ảnh dưới dạng byte
//   String token =
//       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2NzA5ZmY2YWY3NzBlZDJkM2ZjMzM5ZWEiLCJqdGkiOiJmNTE5Zjg4Yi0zY2QzLTQxYmMtYmZkMy0wODJjZWFhZGE2MTEiLCJleHAiOjE3MzEzMTQyNDUsImlzcyI6InlvdXJkb21haW4uY29tIiwiYXVkIjoieW91cmRvbWFpbi5jb20ifQ.DL2bZ3z3-45V4qUHjXisvkke5KzNJtx7owaAeCuBjcA';
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
//       duration: Duration(milliseconds: 1500),
//     );

//     // Khởi tạo Animation cho opacity và scale
//     _opacityAnimation =
//         Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.decelerate, // Đường cong cho hiệu ứng scale
//     ));

//     _scaleAnimation =
//         Tween<double>(begin: 1.2, end: 1.0).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.decelerate, // Đường cong cho hiệu ứng scale
//     ));
//   }

//   // Hàm để gọi API và lấy hình ảnh
//   Future<void> fetchImage() async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//             'https://97c0-113-191-94-18.ngrok-free.app/api/Account/media/dfdf'), // Thay thế với URL API của bạn
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
//         print('Failed to load image: ${response.statusCode}');
//       }
//     } catch (e) {}
//   }

//   @override
//   void dispose() {
//     _controller.dispose(); // Giải phóng tài nguyên
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return imageData == null
//         ? LoadingCircles() // Hiển thị loading khi đang tải ảnh
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
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               // Hiển thị CircularProgressIndicator trên hình ảnh
//               if (!isImageLoaded) LoadingCircles(),
//             ],
//           );
//   }
// }

// void main() {
//   runApp(MaterialApp(home: ImageFromApi()));
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myrefectly/help/effect.dart';
import 'dart:typed_data';


class ImageFromApiWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300, // Chiều cao cố định
      width: 300, // Chiều rộng cố định
      child: ImageFromApi(), // Đặt widget ImageFromApi ở đây
    );
  }
}

class ImageFromApi extends StatefulWidget {
  final bool? need_loading_effect;

  const ImageFromApi({super.key, this.need_loading_effect});
  @override
  _ImageFromApiState createState() => _ImageFromApiState();
}

class _ImageFromApiState extends State<ImageFromApi>
    with SingleTickerProviderStateMixin {
  Uint8List? imageData; // Dữ liệu hình ảnh dưới dạng byte
  String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2NzA5ZmY2YWY3NzBlZDJkM2ZjMzM5ZWEiLCJqdGkiOiJmNTE5Zjg4Yi0zY2QzLTQxYmMtYmZkMy0wODJjZWFhZGE2MTEiLCJleHAiOjE3MzEzMTQyNDUsImlzcyI6InlvdXJkb21haW4uY29tIiwiYXVkIjoieW91cmRvbWFpbi5jb20ifQ.DL2bZ3z3-45V4qUHjXisvkke5KzNJtx7owaAeCuBjcA';
  late AnimationController _controller; // Controller cho Animation
  late Animation<double> _opacityAnimation; // Animation cho opacity
  late Animation<double> _scaleAnimation; // Animation cho scale
  bool isImageLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchImage();

    // Khởi tạo AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    // Khởi tạo Animation cho opacity và scale
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate, // Đường cong cho hiệu ứng scale
    ));

    _scaleAnimation =
        Tween<double>(begin: 1.2, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate, // Đường cong cho hiệu ứng scale
    ));
  }

  // Hàm để gọi API và lấy hình ảnh
  Future<void> fetchImage() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://97c0-113-191-94-18.ngrok-free.app/api/Account/media/dfdf'), // Thay thế với URL API của bạn
        headers: {
          'Authorization': 'Bearer $token', // Thêm token vào header
        },
      );

      if (response.statusCode == 200) {
        // Nếu thành công, lưu dữ liệu hình ảnh vào biến imageData
        setState(() {
          imageData = response.bodyBytes; // Lưu dữ liệu hình ảnh dưới dạng byte
          isImageLoaded = true; // Đánh dấu hình ảnh đã được tải
        });

        // Bắt đầu hiệu ứng hiện dần
        _controller.forward();
      } else {
        // Xử lý lỗi nếu không thành công
        print('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e'); // In ra lỗi
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Giải phóng tài nguyên
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return imageData == null
        ? Center(child: widget.need_loading_effect??true ? LoadingCircles() : Container() ) // Hiển thị loading khi đang tải ảnh
        : Stack(
            alignment: Alignment.center,
            children: [
              // Sử dụng AnimatedBuilder để lắng nghe thay đổi animation
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Image.memory(
                        imageData!,
                        fit: BoxFit.cover, // Điều chỉnh cách hiển thị ảnh
                        width:
                            double.infinity, // Lấp đầy chiều rộng của Container
                        height:
                            double.infinity, // Lấp đầy chiều cao của Container
                      ),
                    ),
                  );
                },
              ),
              // Hiển thị CircularProgressIndicator trên hình ảnh
              //if (!isImageLoaded) LoadingCircles(),
            ],
          );
  }
}

// class LoadingCircles extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return CircularProgressIndicator();
//   }
// }

void main() {
  runApp(MaterialApp(home: Scaffold(body: ImageFromApiWrapper())));
}
