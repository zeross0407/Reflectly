// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:myrefectly/help/color.dart';
// import 'package:myrefectly/share/button.dart';

// class PhotoPicker extends StatefulWidget {
//   List<File> image_list;
//   bool dark;
//   PhotoPicker({required this.image_list, required this.dark});
//   @override
//   _PhotoPickerState createState() => _PhotoPickerState();
// }

// class _PhotoPickerState extends State<PhotoPicker> {
//   final ImagePicker _picker = ImagePicker();

//   Future<void> AddImage() async {
//     if (widget.image_list.length >= 3) return;
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       widget.image_list.add(File(pickedFile.path));
//     } else {
//       print('No image selected.');
//     }
//   }

//   Future<void> removeImage(int index) async {
//     if (widget.image_list.length <= index) return;
//     widget.image_list.removeAt(index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.sizeOf(context).width;
//     double screenHeight = MediaQuery.sizeOf(context).height;
//     return Column(
//       children: [
//         if (widget.image_list.length == 0)
//           CustomElement(
//             onTap: () async {
//               await AddImage();
//               setState(() {});
//             },
//             child: Container(
//               margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
//               padding: EdgeInsets.all(screenWidth * 0.03),
//               decoration: BoxDecoration(
//                 color: !widget.dark ?? false
//                     ? Colors.white.withOpacity(0.1)
//                     : Colors.black.withOpacity(0.025),

//                 borderRadius: BorderRadius.circular(8), // Thêm bo góc nếu cần
//               ),
//               child: Row(
//                 mainAxisSize:
//                     MainAxisSize.min, // Chỉ chiếm không gian tối thiểu
//                 children: [
//                   SvgPicture.asset(
//                     "assets/ico/photo.svg",
//                     colorFilter: ColorFilter.mode(
//                         !widget.dark ?? false ? Colors.white : Colors.black,
//                         BlendMode.srcIn),
//                   ),
//                   SizedBox(
//                       width:
//                           screenWidth * 0.02), // Khoảng cách giữa icon và text
//                   Text(
//                     "Add Photo",
//                     style: TextStyle(
//                         color: !widget.dark ?? false
//                             ? Colors.white
//                             : Colors.black),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         SizedBox(
//           height: screenWidth * 0.05,
//         ),
//         if (widget.image_list.length > 0)
//           Stack(alignment: Alignment.bottomRight, children: [
//             Padding(
//               padding: EdgeInsets.all(screenWidth * 0.05),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(screenWidth * 0.05),
//                 child: StaggeredGrid.count(
//                   crossAxisCount: 6,
//                   mainAxisSpacing: screenWidth * 0.02,
//                   crossAxisSpacing: screenWidth * 0.02,
//                   children: [
//                     StaggeredGridTile.count(
//                       crossAxisCellCount: widget.image_list.length == 1 ? 6 : 3,
//                       mainAxisCellCount: 4,
//                       child: Stack(fit: StackFit.expand, children: [
//                         ClipRRect(
//                           borderRadius:
//                               BorderRadius.circular(screenWidth * 0.025),
//                           child: Container(
//                             child: Image.file(
//                               widget.image_list[0],
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.topRight,
//                           child: GestureDetector(
//                             onTap: () async {
//                               await removeImage(0);
//                               setState(() {});
//                             },
//                             child: Container(
//                               margin: EdgeInsets.all(screenWidth * 0.02),
//                               padding: EdgeInsets.all(screenWidth * 0.01),
//                               decoration: BoxDecoration(
//                                   borderRadius:
//                                       BorderRadius.circular(screenWidth * 0.02),
//                                   color: Colors.black.withOpacity(0.1)),
//                               child: Icon(
//                                 Icons.close,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         )
//                       ]),
//                     ),
//                     if (widget.image_list.length > 1)
//                       StaggeredGridTile.count(
//                         crossAxisCellCount: 3,
//                         mainAxisCellCount:
//                             widget.image_list.length == 2 ? 4 : 2,
//                         child: Stack(fit: StackFit.expand, children: [
//                           ClipRRect(
//                             borderRadius:
//                                 BorderRadius.circular(screenWidth * 0.025),
//                             child: Container(
//                               child: Image.file(
//                                 widget.image_list[1],
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           Align(
//                             alignment: Alignment.topRight,
//                             child: GestureDetector(
//                               onTap: () async {
//                                 await removeImage(1);
//                                 setState(() {});
//                               },
//                               child: Container(
//                                 margin: EdgeInsets.all(screenWidth * 0.02),
//                                 padding: EdgeInsets.all(screenWidth * 0.01),
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(
//                                         screenWidth * 0.02),
//                                     color: Colors.black.withOpacity(0.1)),
//                                 child: Icon(
//                                   Icons.close,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           )
//                         ]),
//                       ),
//                     if (widget.image_list.length > 2)
//                       StaggeredGridTile.count(
//                         crossAxisCellCount: 3,
//                         mainAxisCellCount: 2,
//                         child: Stack(fit: StackFit.expand, children: [
//                           ClipRRect(
//                             borderRadius:
//                                 BorderRadius.circular(screenWidth * 0.025),
//                             child: Container(
//                               child: Image.file(
//                                 widget.image_list[2],
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           Align(
//                             alignment: Alignment.topRight,
//                             child: GestureDetector(
//                               onTap: () async {
//                                 await removeImage(2);
//                               },
//                               child: Container(
//                                 margin: EdgeInsets.all(screenWidth * 0.02),
//                                 padding: EdgeInsets.all(screenWidth * 0.01),
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(
//                                         screenWidth * 0.02),
//                                     color: Colors.black.withOpacity(0.1)),
//                                 child: Icon(
//                                   Icons.close,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           )
//                         ]),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//             if (widget.image_list.length < 3)
//               Padding(
//                 padding: EdgeInsets.all(screenWidth * 0.03),
//                 child: GestureDetector(
//                   onTap: () async {
//                     await AddImage();
//                     setState(() {});
//                   },
//                   child: Container(
//                     padding: EdgeInsets.all(screenWidth * 0.025),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius:
//                           BorderRadius.circular(10), // Thêm bo góc nếu cần
//                     ),
//                     child: SvgPicture.asset(
//                       "assets/ico/photo.svg",
//                       colorFilter: ColorFilter.mode(
//                           all_color[theme_selected][1], BlendMode.srcIn),
//                     ),
//                   ),
//                 ),
//               ),
//           ]),
//       ],
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/share/button.dart';

class PhotoPicker extends StatefulWidget {
  List<File> image_list;
  bool dark;
  final Function(List<File>)
      onImageListChanged; // Thêm callback để thông báo khi danh sách ảnh thay đổi

  PhotoPicker({
    required this.image_list,
    required this.dark,
    required this.onImageListChanged, // Yêu cầu truyền vào callback
  });

  @override
  _PhotoPickerState createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPicker> {
  final ImagePicker _picker = ImagePicker();

  Future<void> AddImage() async {
    if (widget.image_list.length >= 3) return;
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      widget.image_list.add(File(pickedFile.path));
      widget.onImageListChanged(
          widget.image_list); // Gọi callback sau khi thêm ảnh
      setState(() {}); // Cập nhật UI
    } else {
      print('No image selected.');
    }
  }

  Future<void> removeImage(int index) async {
    if (widget.image_list.length <= index) return;
    widget.image_list.removeAt(index);
    widget
        .onImageListChanged(widget.image_list); // Gọi callback sau khi xóa ảnh
    setState(() {}); // Cập nhật UI
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return Column(
      children: [
        if (widget.image_list.isEmpty)
          CustomElement(
            onTap: () async {
              await AddImage();
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(
                color: !widget.dark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.025),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    "assets/ico/photo.svg",
                    colorFilter: ColorFilter.mode(
                      !widget.dark ? Colors.white : Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    "Add Photo",
                    style: TextStyle(
                        color: !widget.dark ? Colors.white : Colors.black),
                  ),
                ],
              ),
            ),
          ),
        SizedBox(height: screenWidth * 0.05),
        if (widget.image_list.isNotEmpty)
          Stack(alignment: Alignment.bottomRight, children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(screenWidth * 0.05),
                child: StaggeredGrid.count(
                  crossAxisCount: 6,
                  mainAxisSpacing: screenWidth * 0.02,
                  crossAxisSpacing: screenWidth * 0.02,
                  children: [
                    StaggeredGridTile.count(
                      crossAxisCellCount: widget.image_list.length == 1 ? 6 : 3,
                      mainAxisCellCount: 4,
                      child: Stack(fit: StackFit.expand, children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.025),
                          child: Container(
                            child: Image.file(
                              widget.image_list[0],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () async {
                              await removeImage(0);
                              setState(() {});
                            },
                            child: Container(
                              margin: EdgeInsets.all(screenWidth * 0.02),
                              padding: EdgeInsets.all(screenWidth * 0.01),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(screenWidth * 0.02),
                                  color: Colors.black.withOpacity(0.1)),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ]),
                    ),
                    if (widget.image_list.length > 1)
                      StaggeredGridTile.count(
                        crossAxisCellCount: 3,
                        mainAxisCellCount:
                            widget.image_list.length == 2 ? 4 : 2,
                        child: Stack(fit: StackFit.expand, children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.025),
                            child: Container(
                              child: Image.file(
                                widget.image_list[1],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () async {
                                await removeImage(1);
                                setState(() {});
                              },
                              child: Container(
                                margin: EdgeInsets.all(screenWidth * 0.02),
                                padding: EdgeInsets.all(screenWidth * 0.01),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 0.02),
                                    color: Colors.black.withOpacity(0.1)),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ]),
                      ),
                    if (widget.image_list.length > 2)
                      StaggeredGridTile.count(
                        crossAxisCellCount: 3,
                        mainAxisCellCount: 2,
                        child: Stack(fit: StackFit.expand, children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.025),
                            child: Container(
                              child: Image.file(
                                widget.image_list[2],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () async {
                                await removeImage(2);
                              },
                              child: Container(
                                margin: EdgeInsets.all(screenWidth * 0.02),
                                padding: EdgeInsets.all(screenWidth * 0.01),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 0.02),
                                    color: Colors.black.withOpacity(0.1)),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ]),
                      ),
                  ],
                ),
              ),
            ),
            if (widget.image_list.length < 3)
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.03),
                child: GestureDetector(
                  onTap: () async {
                    await AddImage();
                  },
                  child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.025),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SvgPicture.asset(
                      "assets/ico/photo.svg",
                      colorFilter: ColorFilter.mode(
                        all_color[theme_selected][1],
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
          ]),
      ],
    );
  }
}
