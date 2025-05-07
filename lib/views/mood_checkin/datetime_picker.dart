// import 'package:flutter/material.dart';
// import 'package:myrefectly/help/color.dart';
// import 'package:myrefectly/models/data.dart';
// import 'package:myrefectly/share/button.dart';
// import 'package:myrefectly/share/complete_time_picker.dart';
// import 'package:myrefectly/theme/color.dart';
// import 'package:calendar_date_picker2/calendar_date_picker2.dart';

// class DateTimeSetter extends StatefulWidget {
//   final double padding_width;
//   DateTime time_picked;

//   DateTimeSetter({required this.padding_width, required this.time_picked});

//   @override
//   _DateTimeSetterState createState() => _DateTimeSetterState();
// }

// class _DateTimeSetterState extends State<DateTimeSetter>
//     with SingleTickerProviderStateMixin {
//   DateTime date_selected = DateTime.now();
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 400),
//       vsync: this,
//     );

//     // Thêm CurvedAnimation
//     final curvedAnimation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut, // Chọn curve bạn muốn ở đây
//     );

//     _animation = Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation);

//     // Bắt đầu hiệu ứng khi widget được tạo
//     _controller.forward();
//   }

//   @override
//   void dispose() async {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final double screenWidth = MediaQuery.of(context).size.width;

//     return FadeTransition(
//       opacity: _animation,
//       child: SlideTransition(
//         position: Tween<Offset>(
//           begin: const Offset(0.0, 0.1), // Xuất hiện từ dưới lên
//           end: Offset.zero,
//         ).animate(_controller),
//         child: Center(
//           child: SizedBox(
//             height: screenHeight * 0.6 + screenWidth * 0.12,
//             child: Stack(
//               alignment: Alignment.topCenter,
//               children: [
//                 Container(
//                   margin: EdgeInsets.only(
//                       top: widget.padding_width, bottom: screenWidth * 0.05),
//                   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
//                   height: screenHeight * 0.6,
//                   width: screenWidth * 0.9,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: all_color[theme_selected],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                     borderRadius: BorderRadius.circular(screenWidth * 0.05),
//                   ),
//                   child: CustomScrollView(
//                     slivers: <Widget>[
//                       SliverToBoxAdapter(
//                         child: Padding(
//                           padding: EdgeInsets.only(top: screenWidth * 0.15),
//                           child: CalendarDatePicker2(
//                             config: CalendarDatePicker2Config(
//                               daySplashColor: Colors.transparent,
//                               dayBuilder: (
//                                   {required date,
//                                   decoration,
//                                   isDisabled,
//                                   isSelected,
//                                   isToday,
//                                   textStyle}) {
//                                 return Container(
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: isSelected ?? false
//                                         ? Colors.white
//                                         : Colors.transparent,
//                                   ),
//                                   alignment: Alignment.center,
//                                   child: Text(
//                                     '${date.day}',
//                                     style: TextStyle(
//                                       color: isSelected ?? false
//                                           ? all_color[theme_selected][0]
//                                           : Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               lastMonthIcon: Icon(
//                                 Icons.arrow_back_ios,
//                                 color: Colors.white,
//                               ),
//                               nextMonthIcon: Icon(
//                                 Icons.arrow_forward_ios,
//                                 color: Colors.white,
//                               ),
//                               centerAlignModePicker: true,
//                               disableModePicker: true,
//                               dynamicCalendarRows: false,
//                               controlsTextStyle: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: "Second",
//                                 fontSize: screenWidth * 0.035,
//                               ),
//                               calendarType: CalendarDatePicker2Type.single,
//                               dayTextStyle: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: "Second",
//                               ),
//                               weekdayLabelTextStyle: TextStyle(
//                                 color: Colors.black.withOpacity(0.2),
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: "Second",
//                               ),
//                             ),
//                             value: [widget.time_picked],
//                             onValueChanged: (dates) {
//                               setState(() {
//                                 widget.time_picked = setDate(
//                                   widget.time_picked,
//                                   dates[0].year,
//                                   dates[0].month,
//                                   dates[0].day,
//                                 );
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                       SliverToBoxAdapter(
//                         child: Padding(
//                           padding: EdgeInsets.only(
//                             bottom: screenWidth * 0.05,
//                           ),
//                           child: Center(
//                               child: TimeSetter(
//                             time: widget.time_picked,
//                             onTimeChanged: (value) {
//                               setState(() {
//                                 widget.time_picked = value;
//                               });
//                             },
//                           )),
//                         ),
//                       ),
//                       // SliverToBoxAdapter(
//                       //   child: Padding(
//                       //     padding: EdgeInsets.only(bottom: screenWidth * 0.2),
//                       //     child: Row(
//                       //       mainAxisAlignment: MainAxisAlignment.center,
//                       //       children: [
//                       //         Text(
//                       //           "AM",
//                       //         ),
//                       //         Text("-"),
//                       //         Text("PM"),
//                       //       ],
//                       //     ),
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//                 Column(
//                   children: [
//                     Container(
//                       width: screenWidth * 0.75,
//                       height: screenWidth * 0.125,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(screenWidth * 0.5),
//                         boxShadow: my_shadow,
//                       ),
//                       child: Center(
//                         child: Text(
//                           get_full_time_string(widget.time_picked),
//                           style: TextStyle(
//                             fontFamily: 'Second',
//                             fontWeight: FontWeight.bold,
//                             color: all_color[theme_selected][0],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const Expanded(child: SizedBox()),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CustomElement(
//                           child: Container(
//                             padding: EdgeInsets.all(screenWidth * 0.025),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Icon(
//                               Icons.close,
//                               color: all_color[theme_selected][0],
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: screenWidth * 0.15),
//                         CustomElement(
//                           child: Container(
//                             padding: EdgeInsets.all(screenWidth * 0.025),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Icon(
//                               Icons.check,
//                               color: all_color[theme_selected][0],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   DateTime setHour(DateTime dateTime, int hour, int minute) {
//     return DateTime(
//       dateTime.year,
//       dateTime.month,
//       dateTime.day,
//       hour,
//       minute,
//       dateTime.second,
//       dateTime.millisecond,
//       dateTime.microsecond,
//     );
//   }

//   DateTime setDate(DateTime original, int year, int month, int day) {
//     return DateTime(
//       year,
//       month,
//       day,
//       original.hour,
//       original.minute,
//       original.second,
//       original.millisecond,
//       original.microsecond,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/share/button.dart';
import 'package:myrefectly/share/complete_time_picker.dart';
import 'package:myrefectly/theme/color.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

class DateTimeSetter extends StatefulWidget {
  final double padding_width;
  DateTime time_picked;
  final Function(DateTime) onTimeChanged; // Thêm callback

  DateTimeSetter({
    required this.padding_width,
    required this.time_picked,
    required this.onTimeChanged, // Khai báo callback
  });

  @override
  _DateTimeSetterState createState() => _DateTimeSetterState();
}

class _DateTimeSetterState extends State<DateTimeSetter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation);

    // Bắt đầu hiệu ứng khi widget được tạo
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 0.1),
          end: Offset.zero,
        ).animate(_controller),
        child: Center(
          child: SizedBox(
            height: screenHeight * 0.6 + screenWidth * 0.12,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: widget.padding_width, bottom: screenWidth * 0.05),
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  height: screenHeight * 0.6,
                  width: screenWidth * 0.9,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: all_color[theme_selected],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: screenWidth * 0.15),
                          child: CalendarDatePicker2(
                            config: CalendarDatePicker2Config(
                              daySplashColor: Colors.transparent,
                              dayBuilder: (
                                  {required date,
                                  decoration,
                                  isDisabled,
                                  isSelected,
                                  isToday,
                                  textStyle}) {
                                bool isFutureDate =
                                    date.isAfter(DateTime.now());
                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected == true && !isFutureDate
                                        ? Colors.white
                                        : Colors.transparent,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${date.day}',
                                    style: TextStyle(
                                      color: isFutureDate
                                          ? Colors.black.withOpacity(
                                              0.2) // Màu xám cho ngày không thể chọn
                                          : (isSelected == true
                                              ? all_color[theme_selected][0]
                                              : Colors.white),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                              lastMonthIcon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              nextMonthIcon: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                              centerAlignModePicker: true,
                              disableModePicker: true,
                              dynamicCalendarRows: false,
                              controlsTextStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Second",
                                fontSize: screenWidth * 0.035,
                              ),
                              calendarType: CalendarDatePicker2Type.single,
                              dayTextStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Second",
                              ),
                              weekdayLabelTextStyle: TextStyle(
                                color: Colors.black.withOpacity(0.2),
                                fontWeight: FontWeight.bold,
                                fontFamily: "Second",
                              ),
                            ),
                            value: [widget.time_picked],
                            onValueChanged: (dates) {
                              if (dates[0].isAfter(DateTime.now())) {
                                setState(() {
                                  widget.time_picked = setDate(
                                    widget.time_picked,
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                  );
                                });
                                return;
                              }
                              setState(() {
                                widget.time_picked = setDate(
                                  widget.time_picked,
                                  dates[0].year,
                                  dates[0].month,
                                  dates[0].day,
                                );
                              });
                              widget.onTimeChanged(widget
                                  .time_picked); // Gọi callback khi thay đổi
                            },
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: screenWidth * 0.05,
                          ),
                          child: Center(
                              child: TimeSetter(
                            time: widget.time_picked,
                            onTimeChanged: (value) {
                              setState(() {
                                widget.time_picked = value;
                                widget.onTimeChanged(widget
                                    .time_picked); // Gọi callback khi thay đổi
                              });
                            },
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: screenWidth * 0.75,
                      height: screenWidth * 0.125,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(screenWidth * 0.5),
                        boxShadow: my_shadow,
                      ),
                      child: Center(
                        child: Text(
                          get_full_time_string(widget.time_picked),
                          style: TextStyle(
                            fontFamily: 'Second',
                            fontWeight: FontWeight.bold,
                            color: all_color[theme_selected][0],
                          ),
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomElement(
                          onTap: () {
                            setState(() {
                              widget.time_picked = DateTime.now();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(screenWidth * 0.025),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.close,
                              color: all_color[theme_selected][0],
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.15),
                        CustomElement(
                          onTap: () {
                            
                          },
                          child: Container(
                            padding: EdgeInsets.all(screenWidth * 0.025),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.check,
                              color: all_color[theme_selected][0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DateTime setHour(DateTime dateTime, int hour, int minute) {
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      hour,
      minute,
      dateTime.second,
      dateTime.millisecond,
      dateTime.microsecond,
    );
  }

  DateTime setDate(DateTime original, int year, int month, int day) {
    return DateTime(
      year,
      month,
      day,
      original.hour,
      original.minute,
      original.second,
      original.millisecond,
      original.microsecond,
    );
  }
}
