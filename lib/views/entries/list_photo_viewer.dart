// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:myrefectly/help/image_viewer.dart';
// import 'package:myrefectly/help/route.dart';
// import 'package:myrefectly/views/entries/entry_photo_viewer.dart';

// class ListPhotoViewer extends StatelessWidget {
//   List<String> photos;
//   bool? route;
//   List<Uint8List> photo_data = [];

//   ListPhotoViewer({required this.photos, this.route});
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.sizeOf(context).width;
//     double screenHeight = MediaQuery.sizeOf(context).height;
//     return GestureDetector(
//       onTap: () async {
//         if (route != null && photos.length > 0) {
//           await Navigator.push(
//               context,
//               Slide_up_Route(
//                   secondPage: View_Photo(
//                 photo_data: photo_data,
//               )));

//         }
//       },
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(screenWidth * 0.03),
//         child: StaggeredGrid.count(
//           crossAxisCount: 6,
//           mainAxisSpacing: screenWidth * 0.02,
//           crossAxisSpacing: screenWidth * 0.02,
//           children: [
//             StaggeredGridTile.count(
//               crossAxisCellCount: photos.length == 1 ? 6 : 3,
//               mainAxisCellCount: 4,
//               child: Stack(fit: StackFit.expand, children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(screenWidth * 0.025),
//                   child: Container(
//                       child: ImageFromApi(
//                     url: '/api/Account/media/${photos[0]}',
//                     onImageLoaded: (p0) {
//                       photo_data.add(p0);
//                     },
//                   )),
//                 ),
//               ]),
//             ),
//             if (photos.length > 1)
//               StaggeredGridTile.count(
//                 crossAxisCellCount: 3,
//                 mainAxisCellCount: photos.length == 2 ? 4 : 2,
//                 child: Stack(fit: StackFit.expand, children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(screenWidth * 0.025),
//                     child: Container(
//                         child: ImageFromApi(
//                       url: '/api/Account/media/${photos[1]}',
//                       onImageLoaded: (p0) {
//                         photo_data.add(p0);
//                       },
//                     )),
//                   ),
//                 ]),
//               ),
//             if (photos.length > 2)
//               StaggeredGridTile.count(
//                 crossAxisCellCount: 3,
//                 mainAxisCellCount: 2,
//                 child: Stack(fit: StackFit.expand, children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(screenWidth * 0.025),
//                     child: Container(
//                         child: ImageFromApi(
//                       url: '/api/Account/media/${photos[2]}',
//                       onImageLoaded: (p0) {
//                         photo_data.add(p0);
//                       },
//                     )),
//                   ),
//                 ]),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:myrefectly/help/image_viewer.dart';
import 'package:myrefectly/help/route.dart';
import 'package:myrefectly/views/entries/entry_photo_viewer.dart';

class ListPhotoViewer extends StatefulWidget {
  final List<String> photos;
  final bool? route;

  ListPhotoViewer({required this.photos, this.route});

  @override
  _ListPhotoViewerState createState() => _ListPhotoViewerState();
}

class _ListPhotoViewerState extends State<ListPhotoViewer> {
  List<Uint8List> photo_data = [];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return GestureDetector(
      onTap: () async {
        if (widget.route != null && widget.photos.length == photo_data.length) {
          await Navigator.push(
            context,
            Slide_up_Route(
              secondPage: View_Photo(
                photo_data: photo_data,
              ),
            ),
          );
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        child: StaggeredGrid.count(
          crossAxisCount: 6,
          mainAxisSpacing: screenWidth * 0.02,
          crossAxisSpacing: screenWidth * 0.02,
          children: [
            StaggeredGridTile.count(
              crossAxisCellCount: widget.photos.length == 1 ? 6 : 3,
              mainAxisCellCount: 4,
              child: Stack(fit: StackFit.expand, children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(screenWidth * 0.025),
                  child: Container(
                    child: ImageFromApi(
                      url: '/api/Account/media/${widget.photos[0]}',
                      onImageLoaded: (p0) {
                        setState(() {
                          photo_data.add(p0);
                        });
                      },
                    ),
                  ),
                ),
              ]),
            ),
            if (widget.photos.length > 1)
              StaggeredGridTile.count(
                crossAxisCellCount: 3,
                mainAxisCellCount: widget.photos.length == 2 ? 4 : 2,
                child: Stack(fit: StackFit.expand, children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(screenWidth * 0.025),
                    child: Container(
                      child: ImageFromApi(
                        url: '/api/Account/media/${widget.photos[1]}',
                        onImageLoaded: (p0) {
                          setState(() {
                            photo_data.add(p0);
                          });
                        },
                      ),
                    ),
                  ),
                ]),
              ),
            if (widget.photos.length > 2)
              StaggeredGridTile.count(
                crossAxisCellCount: 3,
                mainAxisCellCount: 2,
                child: Stack(fit: StackFit.expand, children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(screenWidth * 0.025),
                    child: Container(
                      child: ImageFromApi(
                        url: '/api/Account/media/${widget.photos[2]}',
                        onImageLoaded: (p0) {
                          setState(() {
                            photo_data.add(p0);
                          });
                        },
                      ),
                    ),
                  ),
                ]),
              ),
          ],
        ),
      ),
    );
  }
}
