import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/share/button.dart';
import 'package:myrefectly/share/custominp.dart';
import 'package:myrefectly/theme/color.dart';
import 'package:myrefectly/views/login/login.dart';
import 'package:myrefectly/views/mood_checkin/datetime_picker.dart';
import 'package:myrefectly/views/mood_checkin/edit_mood_checkin_viewmodel.dart';
import 'package:myrefectly/views/share_component/exit_button.dart';
import 'package:provider/provider.dart';

class Edit_Mood_Checkin extends StatefulWidget {
  late String model_id;
  Edit_Mood_Checkin(String model_id) {
    this.model_id = model_id;
  }
  @override
  State<StatefulWidget> createState() => Edit_Mood_Checkin_State();
}

class Edit_Mood_Checkin_State extends State<Edit_Mood_Checkin> {
  bool editing = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<int> activities = [];
  List<bool> showing = [];
  List<int> feelings = [];
  Map<int, bool> feeling_showing = {};
  bool init_complete = false;
  bool time_piking = false;
  bool activity_adding = false;
  bool feeling_adding = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    double padding_width = screenWidth * 0.075;
    double padding_card = screenWidth * 0.03;

    return ChangeNotifierProvider<Edit_Mood_Checkin_Viewmodel>(
      create: (context) => Edit_Mood_Checkin_Viewmodel(widget.model_id),
      child: Consumer<Edit_Mood_Checkin_Viewmodel>(
          builder: (context, view_model, child) {
        if (view_model.is_loading) return Container();

        return Scaffold(
            backgroundColor: background_light,
            body: Stack(
              children: [
                if (!view_model.is_loading)
                  SingleChildScrollView(
                    child: Container(
                      height: !editing ? screenHeight : screenHeight + 100,
                      child: Column(
                        children: [
                          Flexible(
                            child: Stack(children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        top: screenWidth * 0.125,
                                        right: screenWidth * 0.05),
                                    child: exit_button(context, false)),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: screenWidth * 0.1),
                                child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.all(screenWidth * 0.025),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            time_piking = true;
                                          });
                                        },
                                        child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/all/(16).svg",
                                                colorFilter: ColorFilter.mode(
                                                  editing
                                                      ? Colors.black
                                                          .withOpacity(0.025)
                                                      : Colors.transparent,
                                                  BlendMode.srcIn,
                                                ),
                                                height: screenWidth * 0.1,
                                              ),
                                              Text(
                                                //"${fullMonth[view_model.moodCheckin_temp.submitTime.month]!.toUpperCase()} ${view_model.moodCheckin_temp.submitTime.hour}:${view_model.moodCheckin_temp.submitTime.minute}",
                                                "${get_full_time_string(view_model.moodCheckin_temp.submitTime)}",
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationThickness:
                                                        4.0, // Độ dày của gạch ngang
                                                    decorationColor: Colors
                                                        .black
                                                        .withOpacity(
                                                            0.2), // Màu của gạch ngang
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.black
                                                        .withOpacity(0.2)),
                                              ),
                                            ]),
                                      ),
                                    )),
                              ),
                              AnimatedPositioned(
                                top: editing
                                    ? screenHeight * 0.15
                                    : screenHeight * 0.2,
                                left: editing ? 0 : -screenWidth * 0.4,
                                curve: Curves.decelerate,
                                duration: Duration(milliseconds: 300),
                                child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.05),
                                    //color: Colors.amber,
                                    height: screenWidth * 0.4,
                                    width: screenWidth,
                                    child: Stack(
                                        alignment: Alignment.topCenter,
                                        children: [
                                          AnimatedScale(
                                            duration:
                                                Duration(milliseconds: 200),
                                            scale: editing ? 1 : 1.2,
                                            curve: Curves.bounceOut,
                                            child: SvgPicture.asset(
                                              mood[view_model
                                                  .moodCheckin_temp.mood
                                                  .toInt()]!,
                                              colorFilter: ColorFilter.mode(
                                                Colors.black.withOpacity(0.05),
                                                BlendMode.srcIn,
                                              ),
                                              height: screenWidth * 0.3,
                                              //fit: BoxFit.fill,
                                            ),
                                          ),
                                          AnimatedOpacity(
                                            duration:
                                                Duration(milliseconds: 100),
                                            opacity: editing ? 1 : 0,
                                            child: Align(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    mood_title[view_model
                                                        .moodCheckin_temp.mood
                                                        .toInt()],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: Colors.black
                                                            .withOpacity(0.7)),
                                                  ),
                                                  Slider(
                                                    activeColor: all_color[
                                                        theme_selected][0],
                                                    inactiveColor:
                                                        const Color.fromARGB(
                                                            32, 0, 0, 0),
                                                    value: view_model
                                                        .moodCheckin_temp.mood,
                                                    max: 4,
                                                    //divisions: 5,
                                                    //label: _currentSliderValue.round().toString(),
                                                    onChanged: (double value) {
                                                      setState(() {
                                                        view_model
                                                            .moodCheckin_temp
                                                            .mood = value;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ])),
                              ),
                              AnimatedPositioned(
                                top: editing
                                    ? screenHeight * 0.35
                                    : screenHeight * 0.175,
                                //left: editing ? 0 : 100,
                                curve: Curves.decelerate,
                                duration: Duration(milliseconds: 300),
                                child: AnimatedContainer(
                                    height: screenHeight * 0.3,
                                    width: screenWidth,
                                    curve: Curves.decelerate,
                                    duration: Duration(milliseconds: 300),
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            AnimatedContainer(
                                              width: screenWidth,
                                              curve: Curves.decelerate,
                                              duration:
                                                  Duration(milliseconds: 200),
                                              padding: EdgeInsets.only(
                                                  left: editing
                                                      ? screenWidth * 0.06
                                                      : screenWidth * 0.3),
                                              child: Text(
                                                "Activities",
                                                style: TextStyle(
                                                    fontFamily: "Second",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        screenWidth * 0.12,
                                                    color: Colors.black
                                                        .withOpacity(0.05)),
                                              ),
                                            ),
                                            SingleChildScrollView(
                                              padding: EdgeInsets.only(
                                                  top: screenHeight * 0.06,
                                                  //left: editing ? screenWidth * 0.3 : 10,
                                                  right: padding_width),
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                  children: <Widget>[
                                                        AnimatedContainer(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  300),
                                                          width: !editing
                                                              ? screenWidth *
                                                                      0.3 -
                                                                  padding_card *
                                                                      6
                                                              : screenWidth *
                                                                  0.05,
                                                          //color: Colors.amber,
                                                          height: 10,
                                                        ),
                                                        AnimatedScale(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  200),
                                                          scale:
                                                              editing ? 1 : 0,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                activity_adding =
                                                                    true;
                                                              });
                                                            },
                                                            child: Card(
                                                              color: Color.lerp(
                                                                  all_color[
                                                                      theme_selected][0],
                                                                  Colors.white,
                                                                  0.925)!,
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          screenWidth *
                                                                              0.03),
                                                              child: Padding(
                                                                padding: EdgeInsets.all(
                                                                    screenWidth *
                                                                        0.03),
                                                                child: ClipRRect(
                                                                    child: Icon(
                                                                  Icons.edit,
                                                                  color: all_color[
                                                                      theme_selected][0],
                                                                )),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ] +
                                                      List.generate(
                                                        view_model
                                                            .moodCheckin_temp
                                                            .activities
                                                            .length,
                                                        (index) {
                                                          return AnimatedSize(
                                                            duration: Duration(
                                                                milliseconds:
                                                                    300),
                                                            curve: Curves
                                                                .easeInOut, // Hiệu ứng co dãn mượt mà

                                                            child: Visibility(
                                                              visible:
                                                                  true, // Kiểm soát việc hiển thị

                                                              child: Container(
                                                                margin: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        screenWidth *
                                                                            0.02),
                                                                child: Stack(
                                                                    clipBehavior:
                                                                        Clip.none,
                                                                    children: [
                                                                      Card(
                                                                        color: Color.lerp(
                                                                            all_color[theme_selected][0],
                                                                            Colors.white,
                                                                            0.925)!,
                                                                        shadowColor: Colors
                                                                            .black
                                                                            .withOpacity(0.4),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              EdgeInsets.all(screenWidth * 0.03),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              SvgPicture.asset(
                                                                                height: screenWidth * 0.05,
                                                                                icon_url(
                                                                                  view_model.map_activity[view_model.moodCheckin_temp.activities[index]]?.icon ?? 0,
                                                                                ),
                                                                                colorFilter: ColorFilter.mode(all_color[theme_selected][0], BlendMode.srcIn),
                                                                              ),
                                                                              SizedBox(
                                                                                width: screenWidth * 0.02,
                                                                              ),
                                                                              Text(
                                                                                view_model.map_activity[view_model.moodCheckin_temp.activities[index]]?.title ?? "",
                                                                                style: TextStyle(fontSize: screenWidth_Global * 0.025, color: all_color[theme_selected][0]),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      // Positioned(
                                                                      //     top: -screenWidth *
                                                                      //         0.02,
                                                                      //     right: -screenWidth *
                                                                      //         0.02,
                                                                      //     child:
                                                                      //         ClipOval(
                                                                      //       child:
                                                                      //           AnimatedScale(
                                                                      //         scale: editing ? 1 : 0,
                                                                      //         duration: Duration(milliseconds: 300),
                                                                      //         child: GestureDetector(
                                                                      //           onTap: () {
                                                                      //             setState(() {
                                                                      //               showing[index] = false;
                                                                      //             });
                                                                      //             print(showing);
                                                                      //           },
                                                                      //           child: Container(
                                                                      //             padding: EdgeInsets.all(screenWidth * 0.01),
                                                                      //             decoration: BoxDecoration(color: Colors.white),
                                                                      //             child: Icon(
                                                                      //               Icons.close,
                                                                      //               size: screenWidth * 0.04,
                                                                      //               color: all_color[theme_selected][0],
                                                                      //             ),
                                                                      //           ),
                                                                      //         ),
                                                                      //       ),
                                                                      //     ))
                                                                    ]),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      )),
                                            )
                                          ],
                                        ),
                                        Stack(
                                          children: [
                                            AnimatedContainer(
                                              width: screenWidth,
                                              curve: Curves.decelerate,
                                              duration:
                                                  Duration(milliseconds: 200),
                                              padding: EdgeInsets.only(
                                                  left: editing
                                                      ? screenWidth * 0.06
                                                      : screenWidth * 0.3),
                                              child: Text(
                                                "Feelings",
                                                style: TextStyle(
                                                    fontFamily: "Second",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        screenWidth * 0.12,
                                                    color: Colors.black
                                                        .withOpacity(0.05)),
                                              ),
                                            ),
                                            SingleChildScrollView(
                                              padding: EdgeInsets.only(
                                                  top: screenHeight * 0.06,
                                                  //left: editing ? screenWidth * 0.3 : 10,
                                                  right: padding_width),
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                  children: <Widget>[
                                                        AnimatedContainer(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  300),
                                                          width: !editing
                                                              ? screenWidth *
                                                                      0.3 -
                                                                  padding_card *
                                                                      6
                                                              : screenWidth *
                                                                  0.05,
                                                          //color: Colors.amber,
                                                          height: 10,
                                                        ),
                                                        AnimatedScale(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  200),
                                                          scale:
                                                              editing ? 1 : 0,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                feeling_adding =
                                                                    true;
                                                              });
                                                            },
                                                            child: Card(
                                                              color: Color.lerp(
                                                                  all_color[
                                                                      theme_selected][0],
                                                                  Colors.white,
                                                                  0.925)!,
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          screenWidth *
                                                                              0.03),
                                                              child: Padding(
                                                                padding: EdgeInsets.all(
                                                                    screenWidth *
                                                                        0.03),
                                                                child: ClipRRect(
                                                                    child: Icon(
                                                                  Icons.edit,
                                                                  color: all_color[
                                                                      theme_selected][0],
                                                                )),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ] +
                                                      List.generate(
                                                        view_model
                                                            .moodCheckin_temp
                                                            .feelings
                                                            .length,
                                                        (index) {
                                                          return AnimatedSize(
                                                            duration: Duration(
                                                                milliseconds:
                                                                    300),
                                                            curve: Curves
                                                                .easeInOut, // Hiệu ứng co dãn mượt mà

                                                            child: Visibility(
                                                              visible:
                                                                  true, // Kiểm soát việc hiển thị

                                                              child: Container(
                                                                margin: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        screenWidth *
                                                                            0.02),
                                                                child: Stack(
                                                                    clipBehavior:
                                                                        Clip.none,
                                                                    children: [
                                                                      Card(
                                                                        color: Color.lerp(
                                                                            all_color[theme_selected][0],
                                                                            Colors.white,
                                                                            0.925)!,
                                                                        shadowColor: Colors
                                                                            .black
                                                                            .withOpacity(0.4),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              EdgeInsets.all(screenWidth * 0.03),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              SvgPicture.asset(
                                                                                height: screenWidth * 0.05,
                                                                                icon_url(
                                                                                  view_model.map_feeling[view_model.moodCheckin_temp.feelings[index]]?.icon ?? 0,
                                                                                ),
                                                                                colorFilter: ColorFilter.mode(all_color[theme_selected][0], BlendMode.srcIn),
                                                                              ),
                                                                              SizedBox(
                                                                                width: screenWidth * 0.02,
                                                                              ),
                                                                              Text(
                                                                                view_model.map_feeling[view_model.moodCheckin_temp.feelings[index]]?.title ?? "",
                                                                                style: TextStyle(fontSize: screenWidth_Global * 0.025, color: all_color[theme_selected][0]),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      // Positioned(
                                                                      //     top: -screenWidth *
                                                                      //         0.02,
                                                                      //     right: -screenWidth *
                                                                      //         0.02,
                                                                      //     child:
                                                                      //         ClipOval(
                                                                      //       child:
                                                                      //           AnimatedScale(
                                                                      //         scale: editing ? 1 : 0,
                                                                      //         duration: Duration(milliseconds: 300),
                                                                      //         child: GestureDetector(
                                                                      //           onTap: () async {
                                                                      //             setState(() {
                                                                      //               feeling_showing[0] = false;
                                                                      //             });
                                                                      //             Future.delayed(
                                                                      //               Duration(milliseconds: 400),
                                                                      //               () {},
                                                                      //             );
                                                                      //             print(showing);
                                                                      //           },
                                                                      //           child: Container(
                                                                      //             padding: EdgeInsets.all(screenWidth * 0.01),
                                                                      //             decoration: BoxDecoration(color: Colors.white),
                                                                      //             child: Icon(
                                                                      //               Icons.close,
                                                                      //               size: screenWidth * 0.04,
                                                                      //               color: all_color[theme_selected][0],
                                                                      //             ),
                                                                      //           ),
                                                                      //         ),
                                                                      //       ),
                                                                      //     ))
                                                                    ]),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      )),
                                            )
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                              AnimatedPositioned(
                                top: editing
                                    ? screenHeight * 0.6
                                    : screenHeight * 0.425,
                                curve: Curves.decelerate,
                                duration: Duration(milliseconds: 300),
                                child: Container(
                                  width: screenWidth,
                                  padding: EdgeInsets.all(padding_width * 0.5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Custom_Input(
                                        fontsize: screenWidth * 0.04,
                                        text: view_model.moodCheckin_temp.title,
                                        onChanged: (value) {
                                          view_model.moodCheckin_temp.title =
                                              value;
                                        },
                                        text_color: Colors.black,
                                        hint_color:
                                            Colors.black.withOpacity(0.1),
                                        limit: 40,
                                        need_focus: false,
                                        enable: editing,
                                        viewing: !editing,
                                      ),
                                      Custom_Input(
                                        hint: "Add some notes ...",
                                        fontsize: screenWidth * 0.035,
                                        text: view_model
                                            .moodCheckin_temp.description,
                                        onChanged: (value) {
                                          view_model.moodCheckin_temp
                                              .description = value;
                                        },
                                        hint_color:
                                            Colors.black.withOpacity(0.1),
                                        text_color: Colors.black,
                                        limit: 10000,
                                        need_focus: false,
                                        fontWeight: FontWeight.normal,
                                        enable: editing,
                                        need_helper: false,
                                        viewing: !editing,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  bottom: -screenWidth * 0.075 * 0.15,
                  right: -screenWidth * 0.075 * 0.15,
                  child: CustomElement(
                    onTap: () {
                      setState(() {
                        if (editing) {
                          view_model.submit_update().then(
                            (value) {
                              final overlay = Overlay.of(context);
                              final overlayEntry = OverlayEntry(
                                builder: (context) => NotificationPopup(
                                    background_color: Colors.green[300],
                                    message: value ? "Edit Success" : "Fail"),
                              );

                              overlay.insert(overlayEntry);

                              // Xóa popup sau 2 giây
                              Future.delayed(Duration(seconds: 5), () {
                                overlayEntry.remove();
                              });
                            },
                          );
                        }
                        editing = !editing;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.075),
                      decoration: BoxDecoration(
                        gradient:
                            LinearGradient(colors: all_color[theme_selected]),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(screenWidth * 0.07),
                        ),
                      ),
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        switchInCurve: Curves.decelerate,
                        switchOutCurve: Curves.decelerate,
                        transitionBuilder: (child, animation) {
                          // Sử dụng Animation Rotation quay từ 0 đến 90 độ và trở lại
                          return RotationTransition(
                            turns: Tween<double>(begin: 0.75, end: 1).animate(
                                animation), // Quay 360 độ nhưng bắt đầu từ 0
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: Icon(
                          editing ? Icons.check : Icons.edit,
                          color: Colors.white,
                          key: ValueKey<bool>(
                              editing), // Key đảm bảo hiệu ứng chạy khi đổi icon
                        ),
                      ),
                    ),
                  ),
                ),
                if (time_piking)
                  Stack(children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          time_piking = false;
                        });
                      },
                      child: Container(
                        width: screenWidth,
                        height: screenHeight,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                    DateTimeSetter(
                      padding_width: 16.0,
                      time_picked: view_model.moodCheckin_temp.submitTime,
                      onTimeChanged: (newTime) {
                        setState(() {
                          view_model.moodCheckin_temp.submitTime = newTime;
                        });
                      },
                    ),
                  ]),
                if (activity_adding)
                  Stack(alignment: Alignment.center, children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          activity_adding = false;
                        });
                      },
                      child: Container(
                        width: screenWidth,
                        height: screenHeight,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.075),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.1),
                          gradient: LinearGradient(
                              colors: all_color[theme_selected])),
                      height: screenHeight * 0.5,
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenWidth * 0.07,
                          ),
                          Text(
                            "SELECT UP TO 10 ACTIVITY",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: GridView.count(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.1,
                                      vertical: screenWidth * 0.15),
                                  scrollDirection: Axis.horizontal,
                                  mainAxisSpacing: screenWidth * 0.05,
                                  crossAxisSpacing: screenWidth * 0.02,
                                  crossAxisCount: 3,
                                  children: [
                                    ...List.generate(
                                      view_model.all_activity.length,
                                      (index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (view_model
                                                  .moodCheckin.activities
                                                  .contains(view_model
                                                      .all_activity[index]
                                                      .UUID)) {
                                                view_model
                                                    .moodCheckin.activities
                                                    .remove(view_model
                                                        .all_activity[index]
                                                        .UUID);
                                              } else {
                                                view_model
                                                    .moodCheckin.activities
                                                    .add(view_model
                                                        .all_activity[index]
                                                        .UUID);
                                              }
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: view_model
                                                        .moodCheckin.activities
                                                        .contains(view_model
                                                            .all_activity[index]
                                                            .UUID
                                                            .toString())
                                                    ? Colors.white
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        screenWidth * 0.03)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  width: screenWidth * 0.05,
                                                  icon_url(
                                                    view_model
                                                        .all_activity[index]
                                                        .icon,
                                                  ),
                                                  colorFilter: ColorFilter.mode(
                                                      view_model.moodCheckin
                                                              .activities
                                                              .contains(view_model
                                                                  .all_activity[
                                                                      index]
                                                                  .UUID)
                                                          ? all_color[
                                                              theme_selected][0]
                                                          : Colors.white,
                                                      BlendMode.srcIn),
                                                ),
                                                SizedBox(
                                                  height: screenWidth * 0.01,
                                                ),
                                                Text(
                                                    view_model
                                                        .all_activity[index]
                                                        .title,
                                                    style: TextStyle(
                                                        color: view_model
                                                                .moodCheckin
                                                                .activities
                                                                .contains(view_model
                                                                    .all_activity[
                                                                        index]
                                                                    .UUID)
                                                            ? all_color[
                                                                    theme_selected]
                                                                [0]
                                                            : Colors.white,
                                                        fontSize: screenWidth *
                                                            0.025))
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ]),
                            ),
                          ),
                          Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: screenWidth * 0.05,
                          )
                        ],
                      ),
                    ),
                  ]),
                if (feeling_adding)
                  Stack(alignment: Alignment.center, children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          feeling_adding = false;
                        });
                      },
                      child: Container(
                        width: screenWidth,
                        height: screenHeight,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.1),
                          gradient: LinearGradient(
                              colors: all_color[theme_selected])),
                      height: screenHeight * 0.5,
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenWidth * 0.07,
                          ),
                          Text(
                            "SELECT UP TO 10 FEELING",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Container(
                              child: GridView.count(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.1,
                                      vertical: screenWidth * 0.15),
                                  scrollDirection: Axis.horizontal,
                                  mainAxisSpacing: screenWidth * 0.07,
                                  crossAxisSpacing: screenWidth * 0.02,
                                  crossAxisCount: 3,
                                  children: [
                                    ...List.generate(
                                      view_model.all_feeling.length,
                                      (index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (view_model
                                                  .moodCheckin.feelings
                                                  .contains(view_model
                                                      .all_feeling[index]
                                                      .UUID)) {
                                                view_model.moodCheckin.feelings
                                                    .remove(view_model
                                                        .all_feeling[index]
                                                        .UUID);
                                              } else {
                                                view_model.moodCheckin.feelings
                                                    .add(view_model
                                                        .all_feeling[index]
                                                        .UUID);
                                              }
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: view_model
                                                        .moodCheckin.feelings
                                                        .contains(view_model
                                                            .all_feeling[index]
                                                            .UUID
                                                            .toString())
                                                    ? Colors.white
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        screenWidth * 0.03)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  width: screenWidth * 0.06,
                                                  icon_url(
                                                    view_model
                                                        .all_feeling[index]
                                                        .icon,
                                                  ),
                                                  colorFilter: ColorFilter.mode(
                                                      view_model.moodCheckin
                                                              .feelings
                                                              .contains(view_model
                                                                  .all_feeling[
                                                                      index]
                                                                  .UUID)
                                                          ? all_color[
                                                              theme_selected][0]
                                                          : Colors.white,
                                                      BlendMode.srcIn),
                                                ),
                                                SizedBox(
                                                  height: screenWidth * 0.01,
                                                ),
                                                Text(
                                                    view_model
                                                        .all_feeling[index]
                                                        .title,
                                                    style: TextStyle(
                                                      fontSize:
                                                          screenWidth * 0.025,
                                                      color: view_model
                                                              .moodCheckin
                                                              .feelings
                                                              .contains(view_model
                                                                  .all_feeling[
                                                                      index]
                                                                  .UUID)
                                                          ? all_color[
                                                              theme_selected][0]
                                                          : Colors.white,
                                                    ))
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ]),
                            ),
                          ),
                          Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: screenWidth * 0.05,
                          )
                        ],
                      ),
                    ),
                  ]),
              ],
            ));
      }),
    );
  }
}
