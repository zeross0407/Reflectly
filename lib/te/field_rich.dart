import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String initialText;

  const CustomTextField({Key? key, required this.initialText}) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;
  late String _initialText;
  late int _startIndex;
  late int _endIndex;

  @override
  void initState() {
    super.initState();
    _initialText = widget.initialText;
    _controller = TextEditingController(text: _removeHashMarks(_initialText));
    _controller.addListener(_onTextChanged);

    _startIndex = _initialText.indexOf('#');
    _endIndex = _initialText.lastIndexOf('#');
  }

  String _removeHashMarks(String text) {
    return text.replaceAll('#', '');
  }

  void _onTextChanged() {
    final cursorPosition = _controller.selection.baseOffset;

    // Nếu cursor nằm ngoài vùng có thể chỉnh sửa, trả nó về vị trí cũ
    if (cursorPosition < _startIndex || cursorPosition > _endIndex - 2) {
      _controller.text = _removeHashMarks(_initialText);
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: cursorPosition < _startIndex ? _startIndex : _endIndex - 2),
      );
    } else {
      // Cập nhật vùng giữa hai dấu `#`
      final editableText = _controller.text.substring(_startIndex, _endIndex - 2);
      _initialText = _initialText.substring(0, _startIndex + 1) +
          editableText +
          _initialText.substring(_endIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Nhập vào giữa dấu #...',
      ),
    );
  }
}
