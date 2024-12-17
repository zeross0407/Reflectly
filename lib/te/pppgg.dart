import 'package:flutter/material.dart';

class InfinitePageView extends StatefulWidget {
  @override
  _InfinitePageViewState createState() => _InfinitePageViewState();
}

class _InfinitePageViewState extends State<InfinitePageView> {
  final PageController _pageController = PageController(initialPage: 1);
  final List<Widget> _pages = [
    Container(color: Colors.red),
    Container(color: Colors.green),
    Container(color: Colors.blue),
  ];

  // Hàm xác định trang tiếp theo
  int _getPageIndex(int index) {
    return (index - 1) % _pages.length;
  }

  @override
  void initState() {
    super.initState();
    // Nhảy đến trang giữa để bắt đầu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Infinite Page View')),
      body: PageView.builder(
        controller: _pageController,
        itemCount: null, // Để cho phép lặp vô hạn
        itemBuilder: (context, index) {
          return _pages[_getPageIndex(index)];
        },
        onPageChanged: (index) {
          // Nếu người dùng cuộn đến trang giả, nhảy đến trang thực tế
          if (index == 0) {
            _pageController.jumpToPage(_pages.length);
          } else if (index == _pages.length + 1) {
            _pageController.jumpToPage(1);
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: InfinitePageView(),
  ));
}
