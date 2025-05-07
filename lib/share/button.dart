import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButton extends StatefulWidget {
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

  const CustomButton(
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
      this.height});

  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> {
  bool is_pressing = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: () {
        setState(() {
          is_pressing = true;
        });
        if (widget.onLongPress != null) widget.onLongPress!();
      },
      onLongPressStart: widget.onLongPressStart,
      onLongPressEnd: (detail) {
        setState(() {
          is_pressing = false;
        });
        widget.onLongPressEnd;
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: is_pressing ? 0.9 : 1.0,
        curve: Curves.linear,
        child: Container(
          padding: EdgeInsets.all(widget.padding ?? 15),

          // width: 270,
          // height: 55,
          width: widget.height ?? widget.max_width,
          height: widget.max_width,
          decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(widget.radius ?? 10000),
              boxShadow: widget.have_shadow
                  ? [
                      BoxShadow(
                        color: const Color.fromARGB(255, 141, 141, 141)
                            .withOpacity(is_pressing ? 0 : 0.1), // Màu của bóng
                        spreadRadius: 5, // Kích thước của bóng
                        blurRadius: 7, // Độ mờ của bóng
                        offset: const Offset(0, 4), // Vị trí của bóng
                      ),
                    ]
                  : []),
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
                          fontWeight: FontWeight.bold),
                    ),
                ]),
          ),
        ),
      ),
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
