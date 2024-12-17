// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text('Horizontal Row Example')),
//         body: HorizontalRow(),
//       ),
//     );
//   }
// }

// class HorizontalRow extends StatefulWidget {
//   @override
//   _HorizontalRowState createState() => _HorizontalRowState();
// }

// class _HorizontalRowState extends State<HorizontalRow> {
//   final List<String> items = List.generate(10, (index) => 'Item $index');
//   List<bool> itemShowing = List.generate(10, (index) => true);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 150, // Chiều cao của Row
//       padding: EdgeInsets.all(8.0),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: List.generate(items.length, (index) {
//             return GestureDetector(
//               onTap: () {
//                 setState(() {
//                   itemShowing[index] = false; // Thu nhỏ phần tử trước khi xóa
//                 });
//               },
//               child: AnimatedContainer(
//                 duration: Duration(milliseconds: 400),
//                 width:
//                     itemShowing[index] ? 120 : 0, // Chiều rộng của từng phần tử
//                 margin: EdgeInsets.symmetric(
//                     horizontal: itemShowing[index] ? 8 : 0),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: AnimatedScale(
//                   duration: Duration(milliseconds: 250),
//                   scale: itemShowing[index] ? 1 : 0, // Hiệu ứng thu nhỏ
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.amber,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     padding: EdgeInsets.all(10),
//                     child: Row(
//                       children: [
//                         SvgPicture.asset("assets/activities/a (6).svg"),
//                         Text(
//                           items[index],
//                           style: TextStyle(color: Colors.black, fontSize: 18),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated ListView Example',
      home: AnimatedListViewExample(),
    );
  }
}

class AnimatedListViewExample extends StatefulWidget {
  @override
  _AnimatedListViewExampleState createState() => _AnimatedListViewExampleState();
}

class _AnimatedListViewExampleState extends State<AnimatedListViewExample> {
  final List<String> _items = List.generate(10, (index) => 'Item ${index + 1}');
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void _removeItem(int index) {
    // Xóa phần tử từ danh sách
    String removedItem = _items[index];
    _items.removeAt(index);

    // Hiện hiệu ứng co lại
    _listKey.currentState?.removeItem(
      index,
      (context, animation) {
        return _buildItem(removedItem, animation);
      },
    );
  }

  Widget _buildItem(String item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: () {
                _removeItem(_items.indexOf(item));
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animated ListView'),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: AnimatedList(
          key: _listKey,
          scrollDirection: Axis.horizontal, // Đặt chiều ngang
          initialItemCount: _items.length,
          itemBuilder: (context, index, animation) {
            return _buildItem(_items[index], animation);
          },
        ),
      ),
    );
  }
}
