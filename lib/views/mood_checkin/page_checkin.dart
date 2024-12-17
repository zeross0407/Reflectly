// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:myrefectly/help/color.dart';
// import 'package:myrefectly/main.dart';
// import 'package:myrefectly/models/data.dart';
// import 'package:myrefectly/share/button.dart';
// import 'package:myrefectly/share/custominp.dart';
// import 'package:myrefectly/test.dart';
// import 'package:myrefectly/theme/color.dart';
// import 'package:myrefectly/viewmodels/check_in_viewmodel.dart';
// import 'package:myrefectly/views/mood_checkin/checkin.dart';

// List<Widget> list_page(
//     {required PageController pageViewController,
//     required BuildContext context,
//     required String icon,
//     required String text,
//     required double mood,
//     required bool adding_actitvity_mode,
//     required Check_in_Viewmodel view_model,
//     required VoidCallback next_step,
//     required VoidCallback set_mood(double value),
//     required VoidCallback adding_activity,
//     required bool note_typing,
//     required bool title_typing}) {
//   double screenWidth = MediaQuery.sizeOf(context).width;
//   double screenHeight = MediaQuery.sizeOf(context).height;
//   double padding_width = screenWidth * 0.075;
//   return [
//     FadeTransitionPage(
//       controller: pageViewController,
//       index: 0,
//       child: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
//             child: text_intro(
//                 text:
//                     "Hey bro . How are you this fine ${get_time_str(DateTime.now())} ?",
//                 color: Colors.white,
//                 fontsize: 20),
//           ),
//           SizedBox(
//             height: screenHeight * 0.2,
//           ),
//           SvgPicture.asset(
//             icon,
//             height: 100,
//             colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
//           ),
//           Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               child: Text(
//                 text,
//                 style: const TextStyle(color: Colors.white),
//               )),
//           Slider(
//             activeColor: Colors.white,
//             inactiveColor: const Color.fromARGB(32, 0, 0, 0),
//             value: mood,
//             max: 4,
//             //divisions: 5,
//             //label: _currentSliderValue.round().toString(),
//             onChanged: (double value) {
//               //print(value);
//               //setState(() {
//               //mood = value;
//               set_mood(value);
//               view_model.mood = value.toInt();
//               //});
//             },
//           ),
//           Expanded(child: Container()),
//           Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
//               child: CustomElement(
//                 onTap: next_step,
//                 child: Container(
//                   width: screenWidth * 0.7,
//                   padding: EdgeInsets.symmetric(
//                       //horizontal: screenWidth * 0.25,
//                       vertical: screenWidth * 0.05),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(1000),
//                       color: Colors.white),
//                   child: Text(
//                     "CONTINUE",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         color: all_color[theme_selected][0],
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ))
//         ],
//       ),
//     ),
//     FadeTransitionPage(
//       controller: pageViewController,
//       index: 1,
//       child: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
//             child: text_intro(
//                 text:
//                     "${subtitle(view_model.mood)} What's making your ${get_time_str(DateTime.now())} ${text.toLowerCase()}?",
//                 color: Colors.white,
//                 fontsize: 20),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Text(
//             "Select up to 10 activities",
//             style: TextStyle(
//                 fontFamily: 'Second',
//                 color: Colors.black.withOpacity(0.15),
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18),
//           ),
//           Expanded(
//             child: SizedBox(
//               height: screenHeight * 0.1,
//             ),
//           ),
//           Container(
//             height: screenWidth * 0.8,
//             child: GridView.count(
//                 padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
//                 scrollDirection: Axis.horizontal,
//                 mainAxisSpacing: screenWidth * 0.04,
//                 crossAxisSpacing: screenWidth * 0.02,
//                 crossAxisCount: 3,
//                 children: [
//                   ...List.generate(8, (index) {
//                     return Activity_Widget(
//                       onPressed: () {
//                         if (view_model.activities.contains(index)) {
//                           view_model.activities.remove(index);
//                         } else {
//                           view_model.activities.add(index);
//                         }

//                         view_model.activities_widget[index] =
//                             !view_model.activities_widget[index];

//                         print(view_model.activities);
//                       },
//                       id: index,
//                       icon: activities_list_default[index].url,
//                       title: activities_list_default[index].title,
//                       istapping: view_model.activities_widget[index],
//                     );
//                   }),
//                   GestureDetector(
//                     onTap: () {
//                       adding_activity();
//                       // setState(() {
//                       //   adding_actitvity_mode = true;

//                       // });
//                       next_step();
//                     },
//                     child: Icon(
//                       Icons.add,
//                       color: Colors.white,
//                       size: screenWidth * 0.075,
//                     ),
//                   ),
//                 ]),
//           ),
//           SizedBox(
//             height: screenHeight * 0.05,
//           ),
//           Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
//               child: CustomElement(
//                 onTap: next_step,
//                 child: Container(
//                   width: screenWidth * 0.7,
//                   padding: EdgeInsets.symmetric(
//                       //horizontal: screenWidth * 0.25,
//                       vertical: screenWidth * 0.05),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(1000),
//                       color: Colors.white),
//                   child: Text(
//                     "CONTINUE",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         color: all_color[theme_selected][0],
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ))
//         ],
//       ),
//     ),

// ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//     if (adding_actitvity_mode)
//       FadeTransitionPage(
//           controller: pageViewController,
//           index: 2,
//           child: Stack(children: [
//             Column(
//               children: [
//                 SizedBox(
//                   height: screenWidth * 0.5,
//                 ),
//                 Container(
//                   child: Scrollable(
//                     viewportBuilder: (context, position) {
//                       return Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: screenWidth * 0.05),
//                             child: Custom_Input(
//                               limit: 40,
//                               viewing: false,
//                               need_focus: true,
//                               hint: "Type here...",
//                             ),
//                           ),
//                           Text(
//                             "One word , no special characters",
//                             style: TextStyle(
//                                 color: Colors.white.withOpacity(0.75),
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: screenWidth * 0.038),
//                           ),
//                           SizedBox(
//                             height: screenWidth * 0.3,
//                           )
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//                 Expanded(child: SizedBox()),
//                 Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 20, horizontal: 60),
//                     child: CustomElement(
//                       onTap: next_step,
//                       child: Container(
//                         width: screenWidth * 0.7,
//                         padding: EdgeInsets.symmetric(
//                             //horizontal: screenWidth * 0.25,
//                             vertical: screenWidth * 0.05),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(1000),
//                             color: Colors.white),
//                         child: Text(
//                           "NEXT",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               color: all_color[theme_selected][0],
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ))
//               ],
//             ),
//             Padding(
//               padding: EdgeInsets.all(screenWidth * 0.05),
//               child: Align(
//                   alignment: Alignment.bottomRight,
//                   child: AnimatedScale(
//                     curve: Curves.elasticOut,
//                     duration: Duration(milliseconds: 500),
//                     scale: MediaQuery.of(context).viewInsets.bottom > 0 ? 1 : 0,
//                     child: CustomElement(
//                         child: Container(
//                       padding: EdgeInsets.all(screenWidth * 0.025),
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10)),
//                       child: const Icon(Icons.check),
//                     )),
//                   )),
//             ),
//           ])),

//     if (adding_actitvity_mode)
//       FadeTransitionPage(
//           controller: pageViewController,
//           index: 3,
//           child: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
//                 child: Text(
//                   "Now, select an icon that best represents ",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: screenWidth * 0.042),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.only(top: screenWidth * 0.4),
//                 height: screenWidth * 0.7, // Đặt chiều cao phù hợp cho GridView
//                 child: GridView.builder(
//                   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
//                   scrollDirection: Axis.horizontal, // Cuộn ngang
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 4, // Số hàng
//                     mainAxisSpacing: 8.0, // Khoảng cách giữa các ô
//                     crossAxisSpacing: 8.0, // Khoảng cách giữa các hàng
//                     childAspectRatio: 1, // Tỉ lệ của các ô (rộng:cao = 1:1)
//                   ),
//                   itemCount: 200, // Số lượng item
//                   itemBuilder: (context, index) {
//                     return Container(
//                       //color: Colors.blueAccent,
//                       child: Center(
//                         child:
//                             SvgPicture.asset("assets/all/ (${index + 1}).svg"),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               Expanded(child: Container()),
//               Padding(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
//                   child: CustomElement(
//                     onTap: next_step,
//                     child: Container(
//                       width: screenWidth * 0.7,
//                       padding: EdgeInsets.symmetric(
//                           //horizontal: screenWidth * 0.25,
//                           vertical: screenWidth * 0.05),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(1000),
//                           color: Colors.white),
//                       child: Text(
//                         "CREATE ACTIVITY",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             color: all_color[theme_selected][0],
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ))
//             ],
//           )),

// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//     FadeTransitionPage(
//       controller: pageViewController,
//       index: 2,
//       child: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
//             child: text_intro(
//                 text: ".. and how are you felling about this ?",
//                 color: Colors.white,
//                 fontsize: 20),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Text(
//             "Select up to 10 fellings",
//             style: TextStyle(
//                 fontFamily: 'Second',
//                 color: Colors.black.withOpacity(0.15),
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18),
//           ),
//           Expanded(
//             child: SizedBox(
//               height: screenHeight * 0.15,
//             ),
//           ),
//           Container(
//             height: screenWidth * 0.8,
//             child: GridView.count(
//                 padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
//                 scrollDirection: Axis.horizontal,
//                 mainAxisSpacing: screenWidth * 0.04,
//                 crossAxisSpacing: screenWidth * 0.02,
//                 crossAxisCount: 3,
//                 children: List.generate(
//                   8,
//                   (index) {
//                     return Activity_Widget(
//                       onPressed: () {
//                         if (view_model.feelings.contains(index)) {
//                           view_model.feelings.remove(index);
//                         } else {
//                           view_model.feelings.add(index);
//                         }
//                         view_model.feelings_widget[index] =
//                             !view_model.feelings_widget[index];

//                         print(view_model.feelings);
//                       },
//                       id: index,
//                       icon: feelings_list_default[index].url,
//                       title: feelings_list_default[index].title,
//                       istapping: view_model.feelings_widget[index],
//                     );
//                   },
//                 )),
//           ),
//           SizedBox(
//             height: screenHeight * 0.05,
//           ),
//           Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
//               child: CustomElement(
//                 onTap: next_step,
//                 child: Container(
//                   width: screenWidth * 0.7,
//                   padding: EdgeInsets.symmetric(
//                       //horizontal: screenWidth * 0.25,
//                       vertical: screenWidth * 0.05),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(250),
//                       color: Colors.white),
//                   child: Text(
//                     "CONTINUE",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         color: all_color[theme_selected][0],
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ))
//         ],
//       ),
//     ),
//     FadeTransitionPage(
//       controller: pageViewController,
//       index: 3,
//       child: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: screenWidth * 0),
//             child: Center(
//               child: Stack(alignment: Alignment.center, children: [
//                 SvgPicture.asset(
//                   "assets/ico/calendar.svg",
//                   colorFilter: ColorFilter.mode(
//                       Colors.black.withOpacity(0.03), BlendMode.srcIn),
//                   width: 50,
//                 ),
//                 text_intro(
//                     text:
//                         "${fullMonth[DateTime.now().month]!.toUpperCase()} ${DateTime.now().day},  ${DateTime.now().hour}:${DateTime.now().minute}",
//                     color: Colors.white.withOpacity(0.5),
//                     fontsize: screenWidth * 0.04),
//               ]),
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Container(
//             width: double.infinity,
//             child: Stack(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(left: padding_width),
//                   child: Text(
//                     "Activities",
//                     style: TextStyle(
//                         fontFamily: "Second",
//                         fontWeight: FontWeight.bold,
//                         fontSize: screenWidth * 0.12,
//                         color: const Color.fromARGB(26, 0, 0, 0)),
//                   ),
//                 ),
//                 SingleChildScrollView(
//                   padding: EdgeInsets.only(
//                       top: screenHeight * 0.06,
//                       left: padding_width,
//                       right: padding_width),
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: List.generate(
//                       view_model.activities.length,
//                       (index) => Container(
//                         margin: EdgeInsets.symmetric(
//                             horizontal: screenWidth * 0.02),
//                         padding: EdgeInsets.symmetric(
//                             horizontal: screenWidth * 0.025,
//                             vertical: screenWidth * 0.02),
//                         decoration: BoxDecoration(
//                             boxShadow: my_shadow,
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10)),
//                         child: Row(
//                           children: [
//                             SvgPicture.asset(
//                               activities_list_default[
//                                       view_model.activities[index]]
//                                   .url,
//                               colorFilter: ColorFilter.mode(
//                                   all_color[theme_selected][0],
//                                   BlendMode.srcIn),
//                             ),
//                             SizedBox(
//                               width: screenWidth * 0.01,
//                             ),
//                             Text(
//                               activities_list_default[
//                                       view_model.activities[index]]
//                                   .title,
//                               style: TextStyle(
//                                   fontSize: screenWidth * 0.025,
//                                   color: all_color[theme_selected][0]),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Container(
//             width: double.infinity,
//             child: Stack(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(left: padding_width),
//                   child: Text(
//                     "Feelings",
//                     style: TextStyle(
//                         fontFamily: "Second",
//                         fontWeight: FontWeight.bold,
//                         fontSize: screenWidth * 0.12,
//                         color: const Color.fromARGB(26, 0, 0, 0)),
//                   ),
//                 ),
//                 SingleChildScrollView(
//                   padding: EdgeInsets.only(
//                       top: screenHeight * 0.06,
//                       left: padding_width,
//                       right: padding_width),
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: List.generate(
//                       view_model.feelings.length,
//                       (index) => Container(
//                         margin: EdgeInsets.symmetric(
//                             horizontal: screenWidth * 0.02),
//                         padding: EdgeInsets.symmetric(
//                             horizontal: screenWidth * 0.025,
//                             vertical: screenWidth * 0.02),
//                         decoration: BoxDecoration(
//                             boxShadow: my_shadow,
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10)),
//                         child: Row(
//                           children: [
//                             SvgPicture.asset(
//                               feelings_list_default[view_model.feelings[index]]
//                                   .url,
//                               colorFilter: ColorFilter.mode(
//                                   all_color[theme_selected][0],
//                                   BlendMode.srcIn),
//                             ),
//                             Text(
//                               feelings_list_default[view_model.feelings[index]]
//                                   .title,
//                               style: TextStyle(
//                                   fontSize: screenWidth * 0.025,
//                                   color: all_color[theme_selected][0]),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               //setState(() {
//               title_typing = true;
//               //});
//             },
//             child: Container(
//               margin: EdgeInsets.symmetric(
//                   horizontal: padding_width, vertical: padding_width),
//               width: 10000000,
//               padding: EdgeInsets.all(screenWidth * 0.05),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.black.withOpacity(0.05)),
//               child: Text(
//                 view_model.title.length == 0 ? "Title ..." : view_model.title,
//                 style: TextStyle(
//                     color: const Color.fromARGB(153, 255, 255, 255),
//                     fontSize: screenWidth * 0.045,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               //setState(() {
//               note_typing = true;
//               //});
//             },
//             child: Container(
//               margin:
//                   EdgeInsets.symmetric(horizontal: padding_width, vertical: 0),
//               width: 10000000,
//               height: screenHeight * 0.15,
//               padding: EdgeInsets.all(screenWidth * 0.05),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.black.withOpacity(0.05)),
//               child: Text(
//                 view_model.notes.length == 0
//                     ? "Add some notes ..."
//                     : view_model.notes,
//                 style: TextStyle(
//                   color: Color.fromARGB(153, 255, 255, 255),
//                   //fontSize: screenWidth * 0.045,
//                   //fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(child: Container()),
//           Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
//               child: CustomElement(
//                 onTap: () async {
//                   await view_model.submit_checkin();
//                   Navigator.pop(context);
//                 },
//                 child: Container(
//                   width: screenWidth * 0.7,
//                   padding: EdgeInsets.symmetric(
//                       //horizontal: screenWidth * 0.25,
//                       vertical: screenWidth * 0.05),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(1000),
//                       color: Colors.white),
//                   child: Text(
//                     "COMPLETE CHECK-IN",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         color: all_color[theme_selected][0],
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ))
//         ],
//       ),
//     ),
//   ];
// }
