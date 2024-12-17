import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SlideUpDownDemo(),
    );
  }
}

class SlideUpDownDemo extends StatefulWidget {
  const SlideUpDownDemo({Key? key}) : super(key: key);

  @override
  State<SlideUpDownDemo> createState() => _SlideUpDownDemoState();
}

class _SlideUpDownDemoState extends State<SlideUpDownDemo> {
  bool _isVisible = false;

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slide Up & Down Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _toggleVisibility,
              child: Text(_isVisible ? 'Hide Widget' : 'Show Widget'),
            ),
            const SizedBox(height: 20),
            SlideUpDownWidget(
              isVisible: _isVisible,
              child: Container(
                width: 200,
                height: 100,
                color: Colors.blue,
                alignment: Alignment.center,
                child: const Text(
                  'Sliding Widget',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SlideUpDownWidget extends StatefulWidget {
  final Widget child;
  final bool isVisible;

  const SlideUpDownWidget({
    required this.child,
    required this.isVisible,
    Key? key,
  }) : super(key: key);

  @override
  State<SlideUpDownWidget> createState() => _SlideUpDownWidgetState();
}

class _SlideUpDownWidgetState extends State<SlideUpDownWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start position (off-screen at the bottom)
      end: const Offset(0, 0), // End position (on-screen)
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant SlideUpDownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isVisible && !oldWidget.isVisible) {
      _controller.forward(); // Show widget with slide-up effect
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _controller.reverse(); // Hide widget with slide-down effect
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: true, // Always keep the widget in the tree
      maintainState: true,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
