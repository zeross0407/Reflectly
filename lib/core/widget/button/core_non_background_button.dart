import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../animation/bouncy_anim.dart';

class CoreNonBackgroundButton extends StatefulWidget {
  final VoidCallback? onTap;
  final String? text;
  final Color color_text;
  final String? icon;
  final double? max_width;
  final double? padding;
  final Color? icon_color;
  final double? height;
  final bool fitWidth;

  const CoreNonBackgroundButton(
      {super.key,
      this.onTap,
      this.text,
      required this.color_text,
      this.icon,
      this.max_width,
      this.padding,
      this.icon_color,
      this.height,
      this.fitWidth = false});

  @override
  CoreNonBackgroundButtonState createState() => CoreNonBackgroundButtonState();
}

class CoreNonBackgroundButtonState extends State<CoreNonBackgroundButton> {
  bool is_pressing = false;
  @override
  Widget build(BuildContext context) {
    return BouncyAnimation(
      duration: Durations.long2,
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
        );
      },
    );
  }
}
