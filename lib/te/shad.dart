// import 'package:flutter/material.dart';

// class ReflectlyShadowWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Stack(
//           alignment: Alignment.topCenter,
//           children: [
//             // Hiệu ứng bóng hình oval
//             Container(
//               width: 220,
//               height: 200,
//               decoration: BoxDecoration(
//                 color: Colors.amber,
//                 borderRadius:
//                     BorderRadius.circular(50), // Bo góc thành hình oval
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     blurRadius: 50,
//                     spreadRadius: 0,
//                     offset: Offset(0, 30), // Đẩy bóng xuống dưới
//                   ),
//                 ],
//               ),
//             ),
//             // Phần tử chính với màu sắc và bo góc
//             Container(
//               margin: EdgeInsets.only(bottom: 20),
//               width: 300,
//               height: 200,
//               decoration: BoxDecoration(
//                 color: Colors.blueAccent,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: ReflectlyShadowWidget(),
//   ));
// }

// import 'package:flutter/material.dart';

// class ReflectlyShadow extends StatelessWidget {
//   final Color shadowColor; // Màu bóng đổ
//   final Widget child; // Widget con

//   const ReflectlyShadow({
//     Key? key,
//     required this.shadowColor,
//     required this.child,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           // Lấy kích thước của widget con
//           final double childHeight = constraints.minHeight;
//           final double childWidth =
//               constraints.maxWidth; // Chiều rộng tối đa của LayoutBuilder
//           final double shadowWidth = childWidth *
//               0.8; // Chiều rộng bóng đổ bằng 80% chiều rộng của child

//           return Stack(
//             alignment: Alignment.bottomCenter,
//             children: [
//               // Hiệu ứng bóng với chiều rộng 80% của child
//               Container(
//                 width: shadowWidth,
//                 height:
//                     50, // Chiều cao bóng có thể điều chỉnh, ở đây lấy 50% chiều cao child
//                 decoration: BoxDecoration(
//                   shape: BoxShape.rectangle,
//                   color: Colors.amber,
//                   borderRadius:
//                       BorderRadius.circular(10000), // Bo góc thành hình oval
//                   boxShadow: [
//                     BoxShadow(
//                       color: shadowColor.withOpacity(0.9),
//                       blurRadius: 50,
//                       spreadRadius: 0,
//                       offset: Offset(0, 1), // Đẩy bóng xuống dưới
//                     ),
//                   ],
//                 ),
//               ),
//               // Phần tử chính với kích thước của widget con
//               child,
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// class ReflectlyShadowWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: ReflectlyShadow(
//         shadowColor: Colors.black, // Màu bóng đổ
//         child: Container(
//           width: 300,
//           height: 200,
//           decoration: BoxDecoration(
//             color: Colors.blueAccent.withOpacity(1),
//             borderRadius: BorderRadius.circular(20),
//           ),
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: ReflectlyShadowWidget(),
//   ));
// }
import 'package:flutter/material.dart';

class ReflectlyShadow extends StatelessWidget {
  final Color shadowColor; // Màu bóng đổ
  final Widget child; // Widget con
  final GlobalKey _childKey =
      GlobalKey(); // GlobalKey để lấy kích thước của child

  ReflectlyShadow({
    Key? key,
    required this.shadowColor,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              // Phần bóng đổ
              Container(
                width: constraints.maxWidth *
                    0.8, // Bóng có chiều rộng 80% của chiều rộng LayoutBuilder
                height:_childKey.currentContext!.size!.width,
                   // (constraints.maxWidth * 0.8) * 0.5, // Chiều cao của bóng
                decoration: BoxDecoration(
                  color: shadowColor,
                  borderRadius: BorderRadius.circular(
                      (constraints.maxWidth * 0.8) *
                          0.5), // Bo góc thành hình elip
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 50,
                      spreadRadius: 0,
                      offset: Offset(0, 30), // Đẩy bóng xuống dưới
                    ),
                  ],
                ),
              ),
              // Phần tử chính với kích thước của widget con
              Container(
                key: _childKey, // Gán GlobalKey vào widget con
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: child,
              ),
            ],
          );
        },
      ),
    );
  }
}

class ReflectlyShadowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ReflectlyShadow(
        shadowColor: Colors.amber, // Màu bóng đổ
        child: Container(
          width: 200, // Chiều rộng cụ thể cho widget con
          height: 100, // Chiều cao cụ thể cho widget con
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ReflectlyShadowWidget(),
  ));
}
