// import 'package:flutter/material.dart';

// class SpreadOutEffect extends StatefulWidget {
//   final double? width;
//   final double? height;

//   const SpreadOutEffect({super.key, this.width, this.height});
//   @override
//   _SpreadOutEffectState createState() => _SpreadOutEffectState();
// }

// class _SpreadOutEffectState extends State<SpreadOutEffect>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _firstCircleAnimation;
//   late Animation<double> _opacityAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 1500), // Thời gian cho một chu kỳ scale
//     )..repeat(reverse: false); // Lặp lại và đảo ngược hiệu ứng

//     // Hình tròn (scale to)
//     _firstCircleAnimation = Tween<double>(begin: 0.7, end: 1.5).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeOut),
//     );

//     // Hiệu ứng mờ dần
//     _opacityAnimation = Tween<double>(begin: 0.05, end: 0).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose(); // Hủy bỏ controller khi không còn dùng đến
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.sizeOf(context).width;

//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         // Hình tròn từ nhỏ thành lớn với hiệu ứng mờ dần
//         FadeTransition(
//           opacity: _opacityAnimation,
//           child: ScaleTransition(
//             scale: _firstCircleAnimation,
//             child: Container(
//               width: widget.width ?? screenWidth * 0.4,
//               height: widget.height ?? screenWidth * 0.4,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myrefectly/help/color.dart';

class SpreadOutEffect extends StatefulWidget {
  final double? width;
  final double? height;

  const SpreadOutEffect({super.key, this.width, this.height});
  @override
  _SpreadOutEffectState createState() => _SpreadOutEffectState();
}

class _SpreadOutEffectState extends State<SpreadOutEffect>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late Animation<double> _circleAnimation1;
  late Animation<double> _circleAnimation2;
  late Animation<double> _circleAnimation3;
  late Animation<double> _opacityAnimation1;
  late Animation<double> _opacityAnimation2;
  late Animation<double> _opacityAnimation3;

  @override
  void initState() {
    super.initState();

    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: false);

    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1750),
    )..repeat(reverse: false);

    _controller3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: false);

    // Tạo các animation cho 3 hình tròn với độ trễ khác nhau
    _circleAnimation1 = Tween<double>(begin: 0.7, end: 1.4).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.easeOut),
    );

    _circleAnimation2 = Tween<double>(begin: 0.7, end: 1.3).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.easeOut),
    );

    _circleAnimation3 = Tween<double>(begin: 0.7, end: 1.2).animate(
      CurvedAnimation(parent: _controller3, curve: Curves.easeOut),
    );

    // Animation mờ dần cho từng hình tròn
    _opacityAnimation1 = Tween<double>(begin: 2, end: 0).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.easeInOut),
    );

    _opacityAnimation2 = Tween<double>(begin: 2, end: 0).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.easeInOut),
    );

    _opacityAnimation3 = Tween<double>(begin: 2, end: 0).animate(
      CurvedAnimation(parent: _controller3, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Hình tròn thứ nhất
        FadeTransition(
          opacity: _opacityAnimation1,
          child: ScaleTransition(
            scale: _circleAnimation1,
            child: Container(
              width: widget.width ?? screenWidth * 0.4,
              height: widget.height ?? screenWidth * 0.4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.015),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        // Hình tròn thứ hai (có độ trễ)
        FadeTransition(
          opacity: _opacityAnimation2,
          child: ScaleTransition(
            scale: _circleAnimation2,
            child: Container(
              width: (widget.width ?? screenWidth * 0.4) * 0.9,
              height: (widget.height ?? screenWidth * 0.4) * 0.9,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.01),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        // Hình tròn thứ ba (có độ trễ lớn hơn)
        FadeTransition(
          opacity: _opacityAnimation3,
          child: ScaleTransition(
            scale: _circleAnimation3,
            child: Container(
              width: (widget.width ?? screenWidth * 0.4) * 0.8,
              height: (widget.height ?? screenWidth * 0.4) * 0.8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.0015),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AnimatedCounter extends StatefulWidget {
  final int targetNumber;
  final TextStyle? textStyle;

  AnimatedCounter({
    super.key,
    required this.targetNumber,
    this.textStyle,
  });

  @override
  _AnimatedCounterState createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _counterAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _initAnimation();
    _controller.forward();
  }

  void _initAnimation() {
    _counterAnimation = IntTween(begin: 1, end: widget.targetNumber).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.targetNumber != widget.targetNumber) {
      // Nếu targetNumber thay đổi, khởi tạo lại animation với giá trị mới
      _controller.reset();
      _initAnimation();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _counterAnimation,
      builder: (context, child) {
        return Text(
          _counterAnimation.value.toString(),
          style: widget.textStyle ?? const TextStyle(fontSize: 40),
        );
      },
    );
  }
}

class RotatingSvgIcon extends StatefulWidget {
  @override
  _RotatingSvgIconState createState() => _RotatingSvgIconState();
}

class _RotatingSvgIconState extends State<RotatingSvgIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Khởi tạo AnimationController
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(); // Lặp lại animation

    // Tạo Animation cho rotation
    _animation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose(); // Giải phóng tài nguyên
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: SvgPicture.asset(
        "assets/ico/reload.svg", // Đường dẫn đến file SVG của bạn
        width: 20, // Chiều rộng của biểu tượng
        height: 20,
        colorFilter: ColorFilter.mode(
            is_darkmode ? Colors.white : Colors.black,
            BlendMode.srcIn), // Chiều cao của biểu tượng
      ),
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value, // Gán giá trị rotation
          child: child,
        );
      },
    );
  }
}

class LoadingCircles extends StatefulWidget {
  Color? color;
  LoadingCircles({this.color});
  @override
  _LoadingCirclesState createState() => _LoadingCirclesState();
}

class _LoadingCirclesState extends State<LoadingCircles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _firstCircleAnimation;
  late Animation<double> _secondCircleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Thời gian cho một chu kỳ scale
    )..repeat(reverse: true); // Lặp lại và đảo ngược hiệu ứng

    // Hình tròn thứ nhất (scale to)
    _firstCircleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Hình tròn thứ hai (scale ngược lại)
    _secondCircleAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Hủy bỏ controller khi không còn dùng đến
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Hình tròn thứ nhất
        ScaleTransition(
          scale: _firstCircleAnimation,
          child: Container(
            width: screenWidth * 0.1,
            height: screenWidth * 0.1,
            decoration: BoxDecoration(
              color: (widget.color ?? all_color[theme_selected][0])
                  .withOpacity(0.5),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Hình tròn thứ hai
        ScaleTransition(
          scale: _secondCircleAnimation,
          child: Container(
            width: screenWidth * 0.1,
            height: screenWidth * 0.1,
            decoration: BoxDecoration(
              color: (widget.color ?? all_color[theme_selected][0])
                  .withOpacity(0.25),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
