import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myrefectly/help/color.dart';

class Custom_Input extends StatefulWidget {
  final int limit;
  final String? text;
  final Color? text_color;
  final String? hint;
  final Color? hint_color;
  final double? fontsize;
  final String? icon;
  final bool? enable;
  final bool? is_password;
  final bool? need_focus;
  bool? viewing = false;
  FontWeight? fontWeight;
  bool? need_helper;
  void Function(String)? onChanged;

  Custom_Input({
    super.key,
    required this.limit,
    this.text,
    this.text_color,
    this.hint,
    this.hint_color,
    this.fontsize,
    this.icon,
    this.enable,
    this.is_password,
    this.need_focus,
    this.onChanged,
    this.viewing,
    this.fontWeight,
    this.need_helper,
  });

  @override
  State<StatefulWidget> createState() => Custom_Input_State();
}

class Custom_Input_State extends State<Custom_Input>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animate_controller;
  final FocusNode _focusNode = FocusNode();
  bool focus = false;
  @override
  void initState() {
    super.initState();
    _controller.text = widget.text ?? '';
    _controller.addListener(() {
      setState(() {
        // Reset lại hoạt ảnh và bắt đầu chạy lại
        _animate_controller.reset();
        _animate_controller.forward();
      });
    });
    _animate_controller = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: (1000),
        ));
    _focusNode
      ..addListener(
        () {
          if (_focusNode.hasFocus) {
            setState(() {
              focus = true;
            });
          } else {
            setState(() {
              focus = false;
            });
          }
        },
      );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.need_focus ?? false)
        FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _animate_controller.dispose();
    _controller.dispose();
    _focusNode.dispose(); // Giải phóng FocusNode khi không còn cần thiết
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(
              horizontal: widget.viewing ?? false ? 0 : 10,
              vertical: widget.viewing ?? false ? 0 : 10),
          child: TextField(
            onChanged: widget.onChanged,
            focusNode: _focusNode,
            obscureText: widget.is_password ?? false,
            enabled: widget.enable,
            inputFormatters: [
              LengthLimitingTextInputFormatter(widget.limit),
            ],
            controller: _controller,
            maxLines: (widget.is_password ?? false) == false ? null : 1,
            style: TextStyle(
                color: widget.text_color ?? Colors.white,
                fontWeight: widget.fontWeight ?? FontWeight.bold,
                fontSize: widget.fontsize),
            decoration: InputDecoration(
              border: const UnderlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide.none),
              contentPadding:
                  const EdgeInsets.only(left: 20, bottom: 20, top: 20),
              hintText: widget.hint ?? 'Title ...',
              hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: widget.fontsize ?? 24,
                  color: widget.hint_color ??
                      const Color.fromARGB(77, 209, 209, 209)),
              fillColor: (widget.viewing ?? true) == false
                  ? Colors.black.withOpacity(0.05)
                  : Colors.transparent,
              filled: true,
            ),
          ),
        ),
        if (widget.need_helper ?? true)
          Positioned(
              top: 0,
              right: 0,
              child: (widget.icon == null)
                  ? ScaleTransition(
                      scale: focus
                          ? Tween<double>(
                              begin: 0.9,
                              end: 1.0,
                            ).animate(
                              CurvedAnimation(
                                curve: Curves.elasticOut,
                                parent: _animate_controller,
                              ),
                            )
                          : Tween<double>(
                              begin: 0,
                              end: 0,
                            ).animate(
                              CurvedAnimation(
                                curve: Curves.elasticOut,
                                parent: _animate_controller,
                              ),
                            ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 7),
                        // width: 50,
                        // height: 35,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            '${(_controller).text.length}/${widget.limit}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: all_color[theme_selected][0],
                                fontFamily: 'Second'),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 247, 252, 255),
                          borderRadius: BorderRadius.circular(10)),
                      child: SvgPicture.asset(
                        widget.icon ?? '',
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5), BlendMode.srcIn),
                      ),
                    ))
      ],
    );
  }
}
