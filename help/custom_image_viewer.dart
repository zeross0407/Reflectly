import 'package:flutter/material.dart';
import 'package:myrefectly/help/effect.dart';

class CustomImageWidget extends StatefulWidget {
  final Widget child; // Widget con sẽ thay thế cho hình ảnh
  final bool? needLoadingEffect;

  const CustomImageWidget({
    Key? key,
    required this.child,
    this.needLoadingEffect,
  }) : super(key: key);

  @override
  _CustomImageWidgetState createState() => _CustomImageWidgetState();
}

class _CustomImageWidgetState extends State<CustomImageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Controller cho Animation
  late Animation<double> _opacityAnimation; // Animation cho opacity
  late Animation<double> _scaleAnimation; // Animation cho scale

  @override
  void initState() {
    super.initState();

    // Khởi tạo AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    // Khởi tạo Animation cho opacity và scale
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    ));

    _scaleAnimation =
        Tween<double>(begin: 1.2, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    ));

    // Bắt đầu hiệu ứng hiện dần
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Giải phóng tài nguyên
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                child: widget.child, // Hiển thị widget con
              ),
            );
          },
        ),
        // Hiển thị LoadingCircles nếu cần
        if (widget.needLoadingEffect ?? true) LoadingCircles(),
      ],
    );
  }
}

