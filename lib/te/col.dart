// import 'package:flutter/material.dart';

// void main() {
//   runApp(ColorSelectorApp());
// }

// class ColorSelectorApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Color Selector',
//       home: ColorSelectorScreen_Setting(),
//     );
//   }
// }

// class ColorSelectorScreen_Setting extends StatefulWidget {
//   @override
//   _ColorSelectorScreenState createState() => _ColorSelectorScreenState();
// }

// class _ColorSelectorScreenState extends State<ColorSelectorScreen_Setting> {
//   final PageController _controller =
//       PageController(viewportFraction: 0.3, initialPage: 0);
//   int _currentPage = 0;

//   final List<List<Color>> all_color = [
//     [
//       Color.fromARGB(255, 255, 255, 255),
//       Color.fromARGB(255, 0, 0, 0),
//     ],
//     [
//       const Color.fromARGB(255, 70, 168, 166),
//       const Color.fromARGB(255, 99, 208, 161),
//     ],
//     [
//       Colors.orange,
//       Colors.purple,
//     ],
//     [
//       Colors.blue,
//       Colors.yellow,
//     ],
//     // 10 cặp màu mới thêm vào
//     [
//       const Color(0xFFFDCBFF), // Pastel Pink
//       const Color(0xFFDFB7FF), // Lavender
//     ],
//     [
//       const Color(0xFFFFE5B4), // Peach
//       const Color(0xFFFFADAD), // Light Coral
//     ],
//     [
//       const Color(0xFF98FF98), // Mint Green
//       const Color(0xFFA0E8FF), // Light Cyan
//     ],
//     [
//       const Color(0xFFFFF9B0), // Soft Yellow
//       const Color(0xFFFFDCA8), // Pale Orange
//     ],
//     [
//       const Color(0xFFA0E4FF), // Baby Blue
//       const Color(0xFFB2DFFF), // Powder Blue
//     ],
//     [
//       const Color(0xFFFFC1CC), // Blush Pink
//       const Color(0xFFE5BBFF), // Soft Violet
//     ],
//     [
//       const Color(0xFFD4A5FF), // Lilac
//       const Color(0xFFFFC2D3), // Light Pink
//     ],
//     [
//       const Color(0xFFE4C1FF), // Lavender
//       const Color(0xFFB1E4FF), // Pale Blue
//     ],
//     [
//       const Color(0xFFAFF8D8), // Soft Green
//       const Color(0xFFFFE59E), // Lemon Yellow
//     ],
//     [
//       const Color(0xFFFFD1DC), // Sunset Pink
//       const Color(0xFFFFF1E8), // Light Peach
//     ],
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       //margin: EdgeInsets.symmetric(horizontal: 30),
//       decoration: BoxDecoration(
//         color: const Color.fromARGB(255, 169, 169, 169),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       //height: 220,
//       child: PageView.builder(
//         controller: _controller,
//         itemCount: all_color.length,
//         onPageChanged: (int index) {
//           setState(() {
//             _currentPage = index;
//           });
//         },
//         itemBuilder: (context, index) {
//           return AnimatedBuilder(
//             animation: _controller,
//             builder: (context, child) {
//               double pageOffset = 0.0;

//               if (_controller.hasClients &&
//                   _controller.position.haveDimensions) {
//                 pageOffset = _controller.page! - index;
//               } else {
//                 // Tính toán giá trị khởi tạo dựa trên _currentPage
//                 pageOffset = _currentPage - index.toDouble();
//               }

//               // Tính toán tỷ lệ và dịch chuyển
//               double scale = 1.0 - (pageOffset.abs() * 0.3);
//               double translationY =
//                   40 * (1 - scale); // Điều chỉnh dịch chuyển dọc

//               scale = scale.clamp(0.8, 1.0);

//               return Transform.translate(
//                 offset: Offset(0, translationY),
//                 child: Transform.scale(
//                   scale: scale - 0.1,
//                   child: Container(
//                     margin: EdgeInsets.symmetric(horizontal: 15),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                           colors: all_color[index],
//                           begin: Alignment.bottomLeft,
//                           end: Alignment.topRight),
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: Colors.white,
//                         width: 5,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// import 'dart:math';

// import 'package:flutter/material.dart';

// void main() {
//   runApp(ColorSelectorApp());
// }

// class ColorSelectorApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Color Selector',
//       home: ColorSelectorScreen(),
//     );
//   }
// }

// class ColorSelectorScreen extends StatefulWidget {
//   @override
//   _ColorSelectorScreenState createState() => _ColorSelectorScreenState();
// }

// class _ColorSelectorScreenState extends State<ColorSelectorScreen> {
//   final PageController _controller =
//       PageController(viewportFraction: 0.3, initialPage: 0);
//   int _currentPage = 0;
//   double _curr = 0.0;

//   final List<Color> colors = [
//     Colors.red,
//     Colors.green,
//     Colors.blue,
//     Colors.yellow,
//     Colors.orange,
//     Colors.purple,
//   ];

//   @override
//   void initState() {
//     super.initState();
//     // Add listener to controller to detect page scroll
//     _controller.addListener(() {
//       //print(_controller.page!);
//       setState(() {
//         _curr = _controller.page!;
//         //_curr = _controller.page! - _controller.page!.floor() - 0.5;
//         //print(_curr);
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           margin: EdgeInsets.symmetric(horizontal: 30),
//           decoration: BoxDecoration(
//             color: const Color.fromARGB(255, 169, 169, 169),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           height: 220,
//           child: PageView.builder(
//             physics: ClampingScrollPhysics(),
//             controller: _controller,
//             itemCount: colors.length,
//             onPageChanged: (int index) {
//               setState(() {
//                 _currentPage = index;
//               });
//             },
//             itemBuilder: (context, index) {
//               var random = Random();

//               return AnimatedBuilder(
//                 animation: _controller,
//                 builder: (context, child) {
//                   double pageOffset = 0.0;

//                   if (_controller.hasClients &&
//                       _controller.position.haveDimensions) {
//                     pageOffset = _controller.page! - index;
//                   } else {
//                     // Tính toán giá trị khởi tạo dựa trên _currentPage
//                     pageOffset = _currentPage - index.toDouble();
//                   }

//                   // Tính toán tỷ lệ và dịch chuyển
//                   double scale = 1.0 - (pageOffset.abs() * 0.3);
//                   double translationY =
//                       40 * (1 - scale); // Điều chỉnh dịch chuyển dọc

//                   scale = scale.clamp(0.8, 1.0);

//                   return Transform.translate(
//                     offset: Offset(0, ((_curr - index) * 30 ).clamp(-40, 40) ),
//                     child: Transform.scale(
//                       scale: scale - 0.1,
//                       child: Container(
//                         margin: EdgeInsets.symmetric(horizontal: 10),
//                         decoration: BoxDecoration(
//                           color: colors[index],
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: Colors.white,
//                             width: 5,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Fab overlay transition',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   void _onTap() {
//     Navigator.of(context).push(FadeRouteBuilder(page: NewPage()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Fab overlay transition')),
//       body: Center(
//         child: Container(
//           color: Colors.green,
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(

//               highlightColor: Colors.purple.withOpacity(0.5),
//               splashColor: Colors.pink.withOpacity(0.5),
//               onTap: () {},
//               child: Container(
//                 width: 400,
//                 height: 500,
//                 padding: EdgeInsets.all(12),
//                 child: Text('Flat Button'),
//               ),
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _onTap,
//         child: Icon(Icons.mail_outline),
//       ),
//     );
//   }
// }

// class FadeRouteBuilder<T> extends PageRouteBuilder<T> {
//   final Widget page;

//   FadeRouteBuilder({required this.page})
//       : super(
//           pageBuilder: (context, animation1, animation2) => page,
//           transitionsBuilder: (context, animation1, animation2, child) {
//             return FadeTransition(opacity: animation1, child: child);
//           },
//         );
// }

// class NewPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('NewPage'),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// void main() {
//   runApp(const LookThroughApp());
// }

// class LookThroughApp extends StatelessWidget {
//   const LookThroughApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: LookThroughScreen(),
//     );
//   }
// }

// class LookThroughScreen extends StatefulWidget {
//   const LookThroughScreen({super.key});

//   @override
//   _LookThroughScreenState createState() => _LookThroughScreenState();
// }

// class _LookThroughScreenState extends State<LookThroughScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   Offset _tapPosition = Offset.zero;
//   List<Widget> screen_color = [];
//   List<Color> col = [Colors.black, Colors.red];
//   bool flag = true;
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );
//     _animation = Tween<double>(begin: 0, end: 1000).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeOut),
//     );
//   }

//   void _onTapDown(TapDownDetails details) {
//     setState(() {
//       flag = !flag;
//       _tapPosition = details.globalPosition;
//       _controller.reset();
//       _controller.forward().then((value) {
//         col = flag ? [Colors.blue, Colors.amber] : [Colors.black, Colors.red];
//         _controller.reset();
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           decoration: const BoxDecoration(
//               gradient: LinearGradient(colors: [Colors.blue, Colors.amber])),
//         ),
//         GestureDetector(
//           onTapDown: _onTapDown,
//           child: AnimatedBuilder(
//             animation: _animation,
//             builder: (context, child) {
//               return ClipPath(
//                 clipper:
//                     MyCustomClipper3(pos: _tapPosition, siz: _animation.value),
//                 child: Container(
//                   decoration:
//                       BoxDecoration(gradient: LinearGradient(colors: col)),
//                   width: double.infinity,
//                   height: double.infinity,
//                 ),
//               );
//             },
//           ),
//         ),
//         const Center(child: ColorSelectorScreen())
//       ],
//     );
//   }
// }

// class MyCustomClipper3 extends CustomClipper<Path> {
//   final Offset pos;
//   final double siz;

//   MyCustomClipper3({required this.pos, required this.siz});

//   @override
//   Path getClip(Size size) {
//     final Path path = Path();

//     // Tạo hình tròn với bán kính là giá trị siz từ vị trí pos
//     path.addOval(Rect.fromCircle(center: pos, radius: siz));
//     path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
//     path.fillType = PathFillType.evenOdd; // Tạo hiệu ứng loang

//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => true;
// }

// class ColorSelectorApp extends StatelessWidget {
//   const ColorSelectorApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Color Selector',
//       home: ColorSelectorScreen(),
//     );
//   }
// }

// class ColorSelectorScreen extends StatefulWidget {
//   const ColorSelectorScreen({super.key});

//   @override
//   _ColorSelectorScreenState createState() => _ColorSelectorScreenState();
// }

// class _ColorSelectorScreenState extends State<ColorSelectorScreen> {
//   final PageController _controller =
//       PageController(viewportFraction: 0.3, initialPage: 0);
//   int _currentPage = 0;
//   double _curr = 0.0;

//   final List<Color> colors = [
//     Colors.red,
//     Colors.green,
//     Colors.blue,
//     Colors.yellow,
//     Colors.orange,
//     Colors.purple,
//   ];

//   @override
//   void initState() {
//     super.initState();
//     // Add listener to controller to detect page scroll
//     _controller.addListener(() {
//       //print(_controller.page!);
//       setState(() {
//         _curr = _controller.page!;
//         //_curr = _controller.page! - _controller.page!.floor() - 0.5;
//         //print(_curr);
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Center(
//         child: Container(
//           //margin: EdgeInsets.symmetric(horizontal: 30),
//           decoration: BoxDecoration(
//             //color: const Color.fromARGB(255, 169, 169, 169),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           height: 220,
//           child: PageView.builder(
//             physics: const ClampingScrollPhysics(),
//             controller: _controller,
//             itemCount: colors.length,
//             onPageChanged: (int index) {
//               setState(() {
//                 _currentPage = index;
//               });
//             },
//             itemBuilder: (context, index) {
//               return AnimatedBuilder(
//                 animation: _controller,
//                 builder: (context, child) {
//                   double pageOffset = 0.0;

//                   if (_controller.hasClients &&
//                       _controller.position.haveDimensions) {
//                     pageOffset = _controller.page! - index;
//                   } else {
//                     // Tính toán giá trị khởi tạo dựa trên _currentPage
//                     pageOffset = _currentPage - index.toDouble();
//                   }

//                   // Tính toán tỷ lệ và dịch chuyển
//                   double scale = 1.0 - (pageOffset.abs() * 0.3);
//                   double translationY =
//                       40 * (1 - scale); // Điều chỉnh dịch chuyển dọc

//                   scale = scale.clamp(0.8, 1.0);

//                   return Transform.translate(
//                     offset: Offset(0, ((_curr - index) * 30).clamp(-40, 40)),
//                     child: Transform.scale(
//                       scale: scale - 0.2,
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 10),
//                         decoration: BoxDecoration(
//                           color: colors[index],
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: Colors.white,
//                             width: 5,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }






































































// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: RippleColorChangeContainer(
//             width: 400,
//             height: 500,
//             child: Center(
//               child: Text(
//                 'Tap Me',
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class RippleColorChangeContainer extends StatefulWidget {
//   final Widget child;
//   final double width;
//   final double height;

//   RippleColorChangeContainer({
//     required this.child,
//     required this.width,
//     required this.height,
//   });

//   @override
//   _RippleColorChangeContainerState createState() =>
//       _RippleColorChangeContainerState();
// }

// class _RippleColorChangeContainerState extends State<RippleColorChangeContainer>
//     with SingleTickerProviderStateMixin {
//   AnimationController? _controller;
//   Offset? _tapPosition;
//   Color _currentColor = Colors.green;
//   Color _targetColor = Colors.blue;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 600),
//     )..addListener(() {
//         setState(() {});
//       });
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   void _onTapDown(TapDownDetails details) {
//     setState(() {
//       _tapPosition = details.localPosition;
//       _targetColor = Colors.purple; // Màu mới sẽ loang ra
//       _controller?.forward(from: 0.0);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: _onTapDown,
//       child: CustomPaint(
//         painter: RipplePainter(
//           progress: _controller!.value,
//           tapPosition: _tapPosition,
//           startColor: _currentColor,
//           endColor: _targetColor,
//         ),
//         child: Container(
//           width: widget.width,
//           height: widget.height,
//           child: widget.child,
//         ),
//       ),
//     );
//   }
// }

// class RipplePainter extends CustomPainter {
//   final double progress;
//   final Offset? tapPosition;
//   final Color startColor;
//   final Color endColor;

//   RipplePainter({
//     required this.progress,
//     required this.tapPosition,
//     required this.startColor,
//     required this.endColor,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (tapPosition == null) return;

//     final Paint paint = Paint()
//       ..color = endColor.withOpacity(progress)
//       ..style = PaintingStyle.fill;

//     double maxRadius = size.width * 1.5; // Kích thước tối đa của vòng tròn
//     double radius = progress * maxRadius;

//     canvas.drawCircle(tapPosition!, radius, paint);

//     // Fill background color with startColor
//     canvas.drawRect(
//         Rect.fromLTWH(0, 0, size.width, size.height),
//         Paint()
//           ..color = startColor
//           ..style = PaintingStyle.fill);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
