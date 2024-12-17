// import 'package:flutter/material.dart';
// import 'package:myrefectly/models/data.dart';
// import 'package:myrefectly/views/mood_checkin/edit_mood_checkin_viewmodel.dart';
// import 'package:provider/provider.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Animated List Example',
//       home: EditMoodCheckinScreen(modelId: ""),
//     );
//   }
// }

// class EditMoodCheckinScreen extends StatefulWidget {
//   final String modelId;

//   EditMoodCheckinScreen({required this.modelId});

//   @override
//   _EditMoodCheckinScreenState createState() => _EditMoodCheckinScreenState();
// }

// class _EditMoodCheckinScreenState extends State<EditMoodCheckinScreen> {
//   final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double paddingCard = screenWidth * 0.03;

//     return ChangeNotifierProvider<Edit_Mood_Checkin_Viewmodel>(
//       create: (context) => Edit_Mood_Checkin_Viewmodel(widget.modelId),
//       child: Consumer<Edit_Mood_Checkin_Viewmodel>(
//         builder: (context, viewModel, child) {
//           return Scaffold(
//             backgroundColor: Colors.white,
//             appBar: AppBar(title: Text("Activities")),
//             body: AnimatedList(

              
//               key: _listKey,
//               padding: EdgeInsets.all(paddingCard),
//               initialItemCount: viewModel.activities.length,
//               itemBuilder: (context, index, animation) {
//                 return _buildListItem(context, index, animation, viewModel);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildListItem(BuildContext context, int index,
//       Animation<double> animation, Edit_Mood_Checkin_Viewmodel viewModel) {
//     return SizeTransition(
//       sizeFactor: animation,
//       child: ListTile(
//         title: Text(activities_list_default[viewModel.activities[index]].title),
//         trailing: IconButton(
//           icon: Icon(Icons.delete),
//           onPressed: () {
//             _removeItem(index, viewModel);
//           },
//         ),
//       ),
//     );
//   }

//   void _removeItem(int index, Edit_Mood_Checkin_Viewmodel viewModel) {
//     if (index < 0 || index >= viewModel.activities.length) {
//       return; // Tránh truy cập chỉ số không hợp lệ
//     }

//     //String removedItem = viewModel.activities[index];

//     _listKey.currentState?.removeItem(
//       index,
//       (context, animation) =>
//           _buildListItem(context, index, animation, viewModel),
//       duration: Duration(milliseconds: 300),
//     );

//     Future.delayed(Duration(milliseconds: 300), () {
//       viewModel.remove_activity(index);
//     });
//   }
// }

// // class Edit_Mood_Checkin_Viewmodel with ChangeNotifier {
// //   List<String> activities = [];
// //   bool _isLoading = true;

// //   bool get isLoading => _isLoading;

// //   Edit_Mood_Checkin_Viewmodel(String modelId) {
// //     Future.delayed(Duration(seconds: 2), () {
// //       activities = ['Activity 1', 'Activity 2', 'Activity 3'];
// //       _isLoading = false;
// //       notifyListeners();
// //     });
// //   }

// //   void removeActivity(int index) {
// //     if (activities.isNotEmpty) {
// //       activities.removeAt(index);
// //       notifyListeners();
// //     }
// //   }
// // }
