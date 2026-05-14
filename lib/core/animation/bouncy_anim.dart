import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BouncyAnimation extends StatefulWidget {
  final VoidCallback onTap;
  final double scaleDownHold;
  final double scaleDownTap;
  final Duration duration;
  final Duration durationDown;
  final Duration durationUp;
  final Widget? child;

  // 2. Thêm builder để tuỳ biến UI nâng cao
  // progress: 0.0 (Bình thường) -> 1.0 (Chìm kịch kim)
  final Widget Function(BuildContext context, double progress, Widget? child)?
      builder;

  const BouncyAnimation({
    super.key,
    required this.onTap,
    this.child,
    this.builder,
    this.scaleDownHold = 0.92,
    this.scaleDownTap = 0.96,
    this.duration = const Duration(milliseconds: 100),
    this.durationDown = const Duration(milliseconds: 300),
    this.durationUp = const Duration(milliseconds: 100),
  }) : assert(
          child != null || builder != null,
          'Core_Project: Phải cung cấp child hoặc builder cho BouncyButton',
        );

  @override
  State<BouncyAnimation> createState() => _BouncyAnimationState();
}

class _BouncyAnimationState extends State<BouncyAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: 1.0,
      lowerBound: widget.scaleDownHold,
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) {
        _controller.animateTo(
          widget.scaleDownHold,
          duration: widget.durationDown,
          curve: Curves.easeOutCubic,
        );
      },
      onTapUp: (_) async {
        HapticFeedback.lightImpact();

        if (_controller.value > widget.scaleDownTap) {
          await _controller.animateTo(
            widget.scaleDownTap,
            duration: widget.durationUp,
            curve: Curves.easeInCubic,
          );
        }

        _controller.animateTo(
          1.0,
          duration: widget.durationUp,
          curve: Curves.easeOutBack,
        );

        widget.onTap();
      },
      onTapCancel: () {
        _controller.animateTo(1.0,
            curve: Curves.easeOutBack, duration: widget.durationUp);
      },

      // 3. Sử dụng AnimatedBuilder để lắng nghe sự thay đổi của controller
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, childNode) {
          // Quy đổi giá trị scale (1.0 -> 0.92) thành phần trăm progress (0.0 -> 1.0)
          // Để dev dùng builder tính toán màu sắc, shadow dễ dàng hơn
          final double progress =
              ((1.0 - _controller.value) / (1.0 - widget.scaleDownHold)).clamp(
            0.0,
            1.0,
          );

          // Render UI theo builder (nếu có) hoặc dùng child mặc định
          final Widget content = widget.builder != null
              ? widget.builder!(context, progress, widget.child)
              : widget.child!;

          // Vẫn giữ lại phần lõi là tự động thu nhỏ (Scale) để dev không phải tự viết
          return Transform.scale(scale: _controller.value, child: content);
        },
        child: widget.child,
      ),
    );
  }
}
