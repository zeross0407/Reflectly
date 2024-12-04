import 'dart:async';

import 'package:flutter/material.dart';

class DelayAnimation extends StatefulWidget {
  final Widget child;
  final int delay;
  final bool shouldFaded;
  late bool? sliding;
  final is_faded_animation;
  final double? max_siz;
  final int? time_run_animation;
  final double? offset_animation;
  bool? loading;
  DelayAnimation(
      {super.key,
      required this.child,
      required this.delay,
      required this.shouldFaded,
      this.sliding,
      this.is_faded_animation,
      this.max_siz,
      this.time_run_animation,
      this.offset_animation,
      this.loading});

  @override
  createState() => _DelayAnimationState();
}

class _DelayAnimationState extends State<DelayAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animOffset;
  late Animation<double> _animOpacity;
  late Animation<double> _animScale;
  bool flag = false;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.time_run_animation ?? 1000)),
    );

    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _controller);

    _animOffset = Tween<Offset>(
            begin: Offset(
                0.0,
                (widget.offset_animation != null)
                    ? (widget.offset_animation!)
                    : (widget.sliding ?? true)
                        ? (widget.max_siz ?? 0) != 0
                            ? (widget.max_siz ?? 0.3)
                            : 0.3
                        : 0),
            end: Offset.zero)
        .animate(curve);

    _animOpacity = Tween<double>(
      begin: widget.shouldFaded ? 1.0 : 0.0,
      end: 1.0,
    ).animate(curve);

    _animScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      curve: Curves.elasticOut,
      parent: _controller,
    ));

    Timer(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward().then((v) {
          if (widget.shouldFaded) {
            //_controller.reset();
          }
          flag = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.is_faded_animation ?? true)
        ? FadeTransition(
            opacity: _animOpacity,
            child: SlideTransition(
              position: _animOffset,
              child: widget.child,
            ),
          )
        : ScaleTransition(
            scale: _animScale,
            child: widget.child,
          );
  }
}
