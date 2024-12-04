import 'package:flutter/material.dart';
import 'dart:typed_data';

class ImageSwitcher extends StatefulWidget {
  Uint8List? imageData;

  ImageSwitcher({super.key, this.imageData});
  @override
  _ImageFromApiState createState() => _ImageFromApiState();
}

class _ImageFromApiState extends State<ImageSwitcher>
    with SingleTickerProviderStateMixin {
  // Dữ liệu hình ảnh dưới dạng byte
  late AnimationController _controller; // Controller cho Animation
  late Animation<double> _opacityAnimation; // Animation cho opacity
  late Animation<double> _scaleAnimation; // Animation cho scale

  @override
  void initState() {
    super.initState();

    // Khởi tạo AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    ));

    _scaleAnimation =
        Tween<double>(begin: 1.1, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.imageData == null
        ? Container()
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
                        widget.imageData!,
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
            ],
          );
  }
}
