import 'package:flutter/material.dart';

class ScalableIconWidget extends StatefulWidget {
  final double screenWidth;
  final Color iconColor;

  const ScalableIconWidget({
    Key? key,
    required this.screenWidth,
    required this.iconColor,
  }) : super(key: key);

  @override
  _ScalableIconWidgetState createState() => _ScalableIconWidgetState();
}

class _ScalableIconWidgetState extends State<ScalableIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    // Bắt đầu hiệu ứng khi widget được tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: EdgeInsets.all(widget.screenWidth * 0.02),
        width: widget.screenWidth * 0.075,
        height: widget.screenWidth * 0.075,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(widget.screenWidth * 0.02),
        ),
        child: Icon(
          Icons.check,
          color: widget.iconColor,
        ),
      ),
    );
  }
}
