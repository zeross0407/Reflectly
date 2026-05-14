import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../animation/bouncy_anim.dart';

class CoreButton extends StatefulWidget {
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Function(LongPressStartDetails)? onLongPressStart;
  final Function(LongPressEndDetails)? onLongPressEnd;
  final String? text;
  final Color color;
  final Color color_text;
  final bool have_shadow;
  final String? icon;
  final double? radius;
  final double? max_width;
  final double? padding;
  final Color? icon_color;
  final double? height;
  final bool fitWidth;

  const CoreButton(
      {super.key,
      this.onTap,
      this.onLongPress,
      this.onLongPressStart,
      this.onLongPressEnd,
      this.text,
      required this.color,
      required this.color_text,
      required this.have_shadow,
      this.icon,
      this.radius,
      this.max_width,
      this.padding,
      this.icon_color,
      this.height,
      this.fitWidth = false});

  @override
  CoreButtonState createState() => CoreButtonState();
}

class CoreButtonState extends State<CoreButton> {
  bool is_pressing = false;
  @override
  Widget build(BuildContext context) {
    return BouncyAnimation(
      scaleDownHold: 0.95,
      scaleDownTap: 0.975,
      durationDown: Duration(milliseconds: 500),
      durationUp: Duration(milliseconds: 400),
      duration: Duration(milliseconds: 500),
      onTap: () {
        widget.onTap?.call();
      },
      builder: (context, progress, child) {
        return AnimatedContainer(
          duration: Durations.long2,
          padding: EdgeInsets.symmetric(vertical: 16),
          width: widget.fitWidth
              ? double.infinity
              : widget.height ?? widget.max_width,
          height: widget.max_width,
          decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(widget.radius ?? 10000),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity((0.05 - progress * 0.1).clamp(0, 1)),
                  spreadRadius: 5, // Kích thước của bóng
                  blurRadius: 7, // Độ mờ của bóng
                  //offset: const Offset(0, 4), // Vị trí của bóng
                ),
              ]),
          child: Center(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null)
                    SvgPicture.asset(
                      widget.icon!,
                      colorFilter: ColorFilter.mode(
                          widget.icon_color ??
                              const Color.fromARGB(255, 255, 255, 255),
                          BlendMode.srcIn),
                    ),
                  if (widget.text != null)
                    Text(
                      widget.text!,
                      style: TextStyle(
                          color: widget.color_text,
                          fontWeight: FontWeight.w800),
                    ),
                ]),
          ),
        );
      },
    );
  }
}

class CustomLongPressGestureRecognizer extends LongPressGestureRecognizer {
  CustomLongPressGestureRecognizer({required super.duration});
}

class CustomElement extends StatefulWidget {
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final Function(DragUpdateDetails)? onPanUpdate;
  final Function(TapDownDetails)? onTapDown;
  final Function(TapUpDetails)? onTapUp;
  final Function(LongPressStartDetails)? onLongPressStart;
  final Function(LongPressMoveUpdateDetails)? onLongPressMoveUpdate;
  final Function(LongPressEndDetails)? onLongPressEnd;
  final Function(DragStartDetails)? onPanStart;
  final Function(DragEndDetails)? onPanEnd;
  final Widget child;

  const CustomElement({
    super.key,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onPanUpdate,
    this.onTapDown,
    this.onTapUp,
    this.onLongPressStart,
    this.onLongPressMoveUpdate,
    this.onLongPressEnd,
    this.onPanStart,
    this.onPanEnd,
    required this.child,
  });

  @override
  CustomElementState createState() => CustomElementState();
}

class CustomElementState extends State<CustomElement> {
  bool is_pressing = false;

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: {
        CustomLongPressGestureRecognizer: GestureRecognizerFactoryWithHandlers<
            CustomLongPressGestureRecognizer>(
          () => CustomLongPressGestureRecognizer(
            duration:
                const Duration(milliseconds: 200), // Thời gian nhận LongPress
          ),
          (CustomLongPressGestureRecognizer instance) {
            instance.onLongPress = () {
              setState(() {
                is_pressing = true;
              });
              widget.onLongPress;
            };
            instance.onLongPressStart = widget.onLongPressStart;
            instance.onLongPressMoveUpdate = widget.onLongPressMoveUpdate;
            instance.onLongPressEnd = (detail) {
              setState(() {
                is_pressing = false;
              });
              widget.onLongPressEnd;
            };
          },
        ),
      },
      child: GestureDetector(
        onTap: widget.onTap,
        onDoubleTap: widget.onDoubleTap,
        onPanUpdate: widget.onPanUpdate,
        onTapDown: widget.onTapDown,
        onTapUp: widget.onTapUp,
        onPanStart: widget.onPanStart,
        onPanEnd: widget.onPanEnd,
        onLongPress: widget.onLongPress,
        onLongPressStart: widget.onLongPressStart,
        onLongPressMoveUpdate: widget.onLongPressMoveUpdate,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 100),
          scale: is_pressing ? 0.9 : 1.0,
          curve: Curves.linear,
          child: widget.child,
        ),
      ),
    );
  }
}
