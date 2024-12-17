import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey _key = GlobalKey(); // GlobalKey để truy cập vào widget
  Offset _position = Offset.zero;
  Size _size = Size.zero;

  void _getPositionAndSize() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
          _key.currentContext?.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;
      setState(() {
        _position = position;
        _size = size;
      });
      print('Position: $_position');
      print('Size: $_size');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Widget Position & Size'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              key: _key, // Đặt GlobalKey vào widget mà bạn muốn lấy tọa độ và kích thước
              width: 150,
              height: 150,
              color: Colors.green,
              child: const Center(child: Text('Target Widget')),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _getPositionAndSize,
            child: const Text('Get Position & Size'),
          ),
          const SizedBox(height: 20),
          Text('Position: $_position'),
          Text('Size: $_size'),
        ],
      ),
    );
  }
}
