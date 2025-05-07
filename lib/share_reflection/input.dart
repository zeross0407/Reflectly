import 'package:flutter/material.dart';
import 'package:myrefectly/help/color.dart';

class CustomTextEditor extends StatefulWidget {
  final String initialText;
  final double fontsize;
  final ValueChanged<String>
      onReflectionChanged; // Callback để gửi dữ liệu ngược lại
  String reflection;

  CustomTextEditor({
    Key? key,
    required this.initialText,
    required this.fontsize,
    required this.reflection,
    required this.onReflectionChanged, // Nhận callback
  }) : super(key: key);

  @override
  _CustomTextEditorState createState() => _CustomTextEditorState();
}

class _CustomTextEditorState extends State<CustomTextEditor> {
  late TextEditingController _controller;

  String prefix = "";
  String suffix = "";
  String reflection = "________";

  List<String> splitByHash(String input) {
    int firstHashIndex = input.indexOf('#');
    int lastHashIndex = input.lastIndexOf('#');

    if (firstHashIndex == -1 ||
        lastHashIndex == -1 ||
        firstHashIndex == lastHashIndex) {
      // Nếu không có dấu `#`, hoặc chỉ có một dấu `#`
      return [input, ''];
    }

    String prefix = input.substring(0, firstHashIndex);
    String suffix = input.substring(lastHashIndex + 1);

    return [prefix, suffix];
  }

  final FocusNode _focusNode = FocusNode();

  // Hàm này sẽ set con trỏ của TextField vào vị trí mong muốn
  void focusAtPosition(int position) {
    _focusNode.requestFocus();
    _controller.selection = TextSelection.collapsed(offset: position);
  }

  @override
  void initState() {
    super.initState();
    reflection = widget.reflection.length == 0 ? "________" : widget.reflection;
    _controller = TextEditingController()
      ..addListener(
        () {},
      );
    _focusNode.addListener(
      () {
        if (reflection == "________") {
          reflection = "";

          _controller.text = prefix + reflection + suffix;
          _controller.selection =
              TextSelection.collapsed(offset: prefix.length);
        }
      },
    );
    updateTextParts(widget.initialText);
  }

  @override
  void didUpdateWidget(covariant CustomTextEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialText != oldWidget.initialText) {
      updateTextParts(widget.initialText);
    }
  }

  void updateTextParts(String initialText) {
    List<String> parts = splitByHash(initialText);
    prefix = parts[0];
    suffix = parts[1];
    _controller.text = (prefix + reflection + suffix);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          // RichText(
          //   maxLines: null,
          //   text: TextSpan(
          //     style: TextStyle(
          //         color: Colors.black,
          //         fontSize: widget.fontsize,
          //         fontFamily: "Google",
          //         letterSpacing: 1.1,
          //         height: 1.5,
          //         wordSpacing: 2,
          //         fontWeight: FontWeight.w200,
          //         ),
          //     children: [
          //       TextSpan(text: prefix,
          //       ),
          //       TextSpan(
          //         text: widget.reflection.isNotEmpty
          //             ? widget.reflection
          //             : "_______",
          //         style: TextStyle(
          //           fontWeight: FontWeight.bold,
          //           height: 1.5,
          //         ),
          //       ),
          //       TextSpan(text: suffix),
          //     ],
          //   ),
          // ),

          TextField(
            focusNode: _focusNode,
            maxLines: null,
            controller: _controller,
            style: TextStyle(
                color: is_darkmode ? Colors.white : Colors.black,
                fontSize: widget.fontsize,
                fontFamily: "Google",
                letterSpacing: 1.1,
                height: 1.5,
                wordSpacing: 2,
                fontWeight: FontWeight.bold),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              border: InputBorder.none, // Bỏ đường viền
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            ),
            onChanged: (value) {
              setState(() {
                if (value.length <= prefix.length) {
                  reflection = "";
                } else {
                  reflection = value.substring(
                      prefix.length, value.length - suffix.length);
                }
                _controller.text = prefix + reflection + suffix;
                _controller.selection = TextSelection.collapsed(
                    offset: prefix.length + reflection.length);
                widget.onReflectionChanged(reflection); // Gọi callback
              });
            },
          ),
        ],
      ),
    );
  }
}
