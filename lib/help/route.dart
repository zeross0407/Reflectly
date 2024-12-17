// import 'package:flutter/material.dart';

// Route Slide_up_Route({required Widget secondPage}) {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => secondPage,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const beginOffset = Offset(0.0, 0.2); // Bắt đầu từ giữa màn hình
//       const endOffset = Offset.zero;
//       const curve = Curves.easeIn;

//       var offsetTween = Tween(begin: beginOffset, end: endOffset)
//           .chain(CurveTween(curve: curve));

//       var fadeTween = Tween<double>(begin: 0.0, end: 1.0);

//       return SlideTransition(
//         position: animation.drive(offsetTween),
//         child: FadeTransition(
//           opacity: animation.drive(fadeTween),
//           child: child,
//         ),
//       );
//     },
//   );
// }
import 'package:flutter/material.dart';

Route Slide_up_Route({
  required Widget secondPage,
  Duration duration = const Duration(milliseconds: 300), // Đặt thời gian mặc định là 300ms
}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => secondPage,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const beginOffset = Offset(0.0, 0.1); // Bắt đầu từ dưới
      const endOffset = Offset.zero;
      const curve = Curves.easeInOut;

      var offsetTween = Tween(begin: beginOffset, end: endOffset)
          .chain(CurveTween(curve: curve));

      var fadeTween = Tween<double>(begin: 0.0, end: 1.0);

      return SlideTransition(
        position: animation.drive(offsetTween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 300), // Thiết lập thời gian chạy animation
  );
}
