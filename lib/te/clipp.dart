import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: ClipPath(
            clipper: MyCustomClipper(),
            child: Container(
              width: 200,
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade200, Colors.pink.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Mood check-in'),
                  SizedBox(height: 10),
                  Text('Voice note'),
                  SizedBox(height: 10),
                  Text('Add photo'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    double width = size.width;
    double height = size.height;
    double cornerRadius = 20;
    double bumpHeight = 30;
    double bumpWidth = 50;

    // Vẽ đường viền trên với các góc bo tròn
    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);
    path.lineTo(width - cornerRadius, 0);
    path.quadraticBezierTo(width, 0, width, cornerRadius);
    path.lineTo(width, height - bumpHeight - cornerRadius);
    path.quadraticBezierTo(width, height - bumpHeight, width - cornerRadius, height - bumpHeight);

    // Tạo phần nhô ra ở dưới
    path.lineTo((width + bumpWidth) / 2, height - bumpHeight);
    path.quadraticBezierTo(width / 2, height, (width - bumpWidth) / 2, height - bumpHeight);
    path.lineTo(cornerRadius, height - bumpHeight);
    path.quadraticBezierTo(0, height - bumpHeight, 0, height - bumpHeight - cornerRadius);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
