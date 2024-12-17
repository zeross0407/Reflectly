import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ShaderDemo extends StatefulWidget {
  @override
  _ShaderDemoState createState() => _ShaderDemoState();
}

class _ShaderDemoState extends State<ShaderDemo> {
  late ui.FragmentShader _shader;

  @override
  void initState() {
    super.initState();
    _loadShader();
  }

  void _loadShader() async {
    // Tải và biên dịch shader
    final program = await ui.FragmentProgram.fromAsset('assets/shaders/ink_sparkle.frag');
    setState(() {
      _shader = program.fragmentShader();
      _shader.setFloat(0, 1.0); // u_composite_1.x
      _shader.setFloat(1, 0.5); // u_composite_1.y
      // Đặt các giá trị khác cho shader như u_color, u_center,...
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shader Demo')),
      body: Center(
        child: CustomPaint(
          size: Size(300, 300),
          painter: ShaderPainter(_shader),
        ),
      ),
    );
  }
}

class ShaderPainter extends CustomPainter {
  final ui.FragmentShader shader;

  ShaderPainter(this.shader);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = shader;
    
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

void main() => runApp(MaterialApp(home: ShaderDemo()));
