import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myrefectly/models/data.dart' as data;
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/share/button.dart';
import 'package:myrefectly/share/custominp.dart';
import 'package:myrefectly/page_transition_animate.dart';
import 'package:myrefectly/theme/color.dart';
import 'package:myrefectly/views/entries/entries_viewmodel.dart';
import 'package:myrefectly/views/mood_checkin/check_in_viewmodel.dart';
import 'package:myrefectly/views/mood_checkin/datetime_picker.dart';
import 'package:myrefectly/views/share_component/exit_button.dart';
import 'package:myrefectly/views/share_component/reflectly_face.dart';
import 'package:myrefectly/views/share_component/text.dart';
import 'package:provider/provider.dart';
import 'package:myrefectly/help/color.dart';

class Checkin extends StatefulWidget {
  const Checkin({super.key});

  @override
  State<StatefulWidget> createState() => CheckinState();
}

class CheckinState extends State<Checkin> {
  String icon = data.mood[2]!;
  String text = "COMPLETELY OKAY";
  String action_button_icon = "assets/all/(16).svg";
  late PageController _pageViewController;
  int step = 0;
  VoidCallback? dosomething;
  double padding_width = 0;
  ///////////////////////////////////////////////////////////////////////////////////

  late TextEditingController _text_title_controller;
  late TextEditingController _text_notes_controller;
  bool adding_actitvity_mode = false;
  bool adding_feeling_mode = false;
  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    dosomething = action_button_perform;
    _text_title_controller = TextEditingController();
    _text_notes_controller = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  void pick_time() {
    setState(() {
      date_picking = true;
    });
  }

  void action_button_perform() {
    setState(() {
      adding_actitvity_mode = false;
      adding_feeling_mode = false;
    });
    if (step == 0) {
      setState(() {
        date_picking = true;
      });
    } else {
      step--;
      if (step == 0)
        setState(() {
          action_button_icon = "assets/all/(16).svg";
        });
      else {
        action_button_icon = "assets/ico/arrow_back.svg";
      }
      _pageViewController.animateToPage(step,
          duration: const Duration(milliseconds: 500),
          curve: Curves.decelerate);
    }
  }

  void next_step() {
    step++;
    _pageViewController.animateToPage(step,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);

    setState(() {
      action_button_icon = "assets/ico/arrow_back.svg";
    });
  }

  bool date_picking = false;

  bool title_typing = false;
  bool note_typing = false;

  @override
  void dispose() {
    _text_title_controller.dispose();
    _text_notes_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    padding_width = screenWidth * 0.075;
    return PopScope(
        canPop: (title_typing || note_typing) ? false : true,
        onPopInvokedWithResult: (didPop, result) {
          setState(() {
            title_typing = false;
            note_typing = false;
          });
        },
        child: ChangeNotifierProvider<MoodCheck_in_Viewmodel>(
            create: (context) => MoodCheck_in_Viewmodel(),
            child: Consumer<MoodCheck_in_Viewmodel>(
                builder: (context, view_model, child) {
              return Scaffold(
                  body: Stack(children: [
                Container(
                  width: screenWidth,
                  height: screenHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        all_color[theme_selected][0],
                        all_color[theme_selected][1],
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 400),
                  curve: Curves.decelerate,
                  opacity: (title_typing || note_typing) ? 0 : 1,
                  child: AnimatedSlide(
                    duration: Duration(milliseconds: 500),
                    offset: (title_typing || note_typing)
                        ? Offset(0, 1)
                        : Offset(0, 0),
                    curve: Curves.decelerate,
                    child: Container(
                        width: screenWidth,
                        height: screenHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: is_darkmode
                                ? [
                                    Color.fromARGB(255, 39, 59, 94),
                                    Color.fromARGB(255, 39, 59, 94),
                                  ]
                                : [
                                    all_color[theme_selected][0],
                                    all_color[theme_selected][1],
                                  ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        child: Column(
                          children: [
                            Stack(children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: padding_width,
                                    top: screenWidth * 0.15,
                                    right: padding_width,
                                    bottom: screenWidth * 0.05),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: dosomething,
                                      child: SvgPicture.asset(
                                        action_button_icon,
                                        height: screenWidth * 0.055,
                                        colorFilter: ColorFilter.mode(
                                            Colors.white.withOpacity(0.5),
                                            BlendMode.srcIn),
                                      ),
                                    ),
                                    exit_button(context, true)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: screenWidth * 0.05,
                                    bottom: screenWidth * 0.05),
                                child: Align(
                                    alignment: Alignment.topCenter,
                                    child: reflectly_face()),
                              )
                            ]),
                            Expanded(
                              child: PageView(
                                controller: _pageViewController,
                                physics: const NeverScrollableScrollPhysics(),
                                children:
                                    // list_page(
                                    //   context: context,
                                    //   adding_actitvity_mode:
                                    //       adding_actitvity_mode,
                                    //   icon: icon,
                                    //   mood: mood,
                                    //   next_step: next_step,
                                    //   note_typing: note_typing,
                                    //   pageViewController: _pageViewController,
                                    //   set_mood: (value) {
                                    //     setState(() {
                                    //       mood = value;
                                    //       set_mood(value);
                                    //     });
                                    //     return () {};
                                    //   },
                                    //   text: text,
                                    //   title_typing: title_typing,
                                    //   view_model: viewModel,
                                    //   adding_activity: () {
                                    //     setState(() {
                                    //       adding_actitvity_mode = true;
                                    //     });
                                    //   },
                                    // )

                                    [
                                  FadeTransitionPage(
                                    controller: _pageViewController,
                                    index: 0,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.1),
                                          child: text_intro(
                                              text:
                                                  "Hey Duc . How are you this fine ${get_time_str(view_model.checkin_time)} ?",
                                              color: Colors.white,
                                              fontsize: 20),
                                        ),
                                        SizedBox(
                                          height: screenHeight * 0.2,
                                        ),
                                        SvgPicture.asset(
                                          icon,
                                          height: screenWidth * 0.22,
                                          colorFilter: const ColorFilter.mode(
                                              Colors.white, BlendMode.srcIn),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20),
                                            child: Text(
                                              text,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            )),
                                        Slider(
                                          activeColor: Colors.white,
                                          inactiveColor:
                                              const Color.fromARGB(32, 0, 0, 0),
                                          value: view_model.mood,
                                          max: 4,
                                          onChanged: (double value) {
                                            //print(value);
                                            setState(() {
                                              view_model.mood = value;
                                              set_mood(value);
                                            });
                                          },
                                        ),
                                        Expanded(child: Container()),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20, horizontal: 60),
                                            child: CustomElement(
                                              onTap: next_step,
                                              child: Container(
                                                width: screenWidth * 0.7,
                                                padding: EdgeInsets.symmetric(
                                                    //horizontal: screenWidth * 0.25,
                                                    vertical:
                                                        screenWidth * 0.05),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1000),
                                                    color: Colors.white),
                                                child: Text(
                                                  "CONTINUE",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: all_color[
                                                          theme_selected][0],
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                  FadeTransitionPage(
                                    controller: _pageViewController,
                                    index: 1,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.1),
                                          child: text_intro(
                                              text:
                                                  "${subtitle(view_model.mood.toInt())} What's making your ${get_time_str(DateTime.now())} ${text.toLowerCase()}?",
                                              color: Colors.white,
                                              fontsize: 20),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "Select up to 10 activities",
                                          style: TextStyle(
                                              fontFamily: 'Second',
                                              color: Colors.black
                                                  .withOpacity(0.15),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: screenHeight * 0.1,
                                          ),
                                        ),
                                        Container(
                                          height: screenWidth * 0.8,
                                          child: GridView.count(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      screenWidth * 0.1),
                                              scrollDirection: Axis.horizontal,
                                              mainAxisSpacing:
                                                  screenWidth * 0.04,
                                              crossAxisSpacing:
                                                  screenWidth * 0.02,
                                              crossAxisCount: 3,
                                              children: [
                                                ...List.generate(
                                                    view_model.all_activity
                                                        .length, (index) {
                                                  return Activity_Widget(
                                                    onPressed: () {
                                                      if (view_model
                                                          .selected_activity
                                                          .contains(view_model
                                                                  .all_activity[
                                                              index])) {
                                                        view_model
                                                            .selected_activity
                                                            .remove(view_model
                                                                    .all_activity[
                                                                index]);
                                                      } else {
                                                        view_model
                                                            .selected_activity
                                                            .add(view_model
                                                                    .all_activity[
                                                                index]);
                                                      }
                                                      setState(() {});
                                                    },
                                                    istapping: view_model
                                                        .selected_activity
                                                        .contains(view_model
                                                                .all_activity[
                                                            index]),
                                                    activity: view_model
                                                        .all_activity[index],
                                                  );
                                                }),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      adding_actitvity_mode =
                                                          true;
                                                      next_step();
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                    size: screenWidth * 0.075,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                        SizedBox(
                                          height: screenHeight * 0.05,
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20, horizontal: 60),
                                            child: CustomElement(
                                              onTap: next_step,
                                              child: Container(
                                                width: screenWidth * 0.7,
                                                padding: EdgeInsets.symmetric(
                                                    //horizontal: screenWidth * 0.25,
                                                    vertical:
                                                        screenWidth * 0.05),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1000),
                                                    color: Colors.white),
                                                child: Text(
                                                  "CONTINUE",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: all_color[
                                                          theme_selected][0],
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                                  if (adding_actitvity_mode)
                                    FadeTransitionPage(
                                        controller: _pageViewController,
                                        index: 2,
                                        child: Stack(children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: screenWidth * 0.5,
                                              ),
                                              Container(
                                                child: Scrollable(
                                                  viewportBuilder:
                                                      (context, position) {
                                                    return Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      screenWidth *
                                                                          0.05),
                                                          child: Custom_Input(
                                                            fontsize:
                                                                screenWidth *
                                                                    0.04,
                                                            onChanged: (p0) {
                                                              view_model
                                                                  .new_activity_title = p0;
                                                            },
                                                            limit: 15,
                                                            viewing: false,
                                                            need_focus: true,
                                                            hint:
                                                                "Type here...",
                                                          ),
                                                        ),
                                                        Text(
                                                          "One word , no special characters",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.75),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  screenWidth *
                                                                      0.038),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              screenWidth * 0.3,
                                                        )
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                              Expanded(child: SizedBox()),
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 20,
                                                      horizontal: 60),
                                                  child: CustomElement(
                                                    onTap: next_step,
                                                    child: Container(
                                                      width: screenWidth * 0.7,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              //horizontal: screenWidth * 0.25,
                                                              vertical:
                                                                  screenWidth *
                                                                      0.05),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      1000),
                                                          color: Colors.white),
                                                      child: Text(
                                                        "NEXT",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: all_color[
                                                                    theme_selected]
                                                                [0],
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ))
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(
                                                screenWidth * 0.05),
                                            child: Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: AnimatedScale(
                                                  curve: Curves.elasticOut,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  scale: MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom >
                                                          0
                                                      ? 1
                                                      : 0,
                                                  child: CustomElement(
                                                      child: Container(
                                                    padding: EdgeInsets.all(
                                                        screenWidth * 0.025),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child:
                                                        const Icon(Icons.check),
                                                  )),
                                                )),
                                          ),
                                        ])),

                                  if (adding_actitvity_mode)
                                    FadeTransitionPage(
                                        controller: _pageViewController,
                                        index: 3,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      screenWidth * 0.1),
                                              child: Text(
                                                "Now, select an icon that best represents ",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        screenWidth * 0.042),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: screenWidth * 0.4),
                                              height: screenWidth *
                                                  0.7, // Đặt chiều cao phù hợp cho GridView
                                              child: GridView.builder(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        screenWidth * 0.1),
                                                scrollDirection: Axis
                                                    .horizontal, // Cuộn ngang
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 4, // Số hàng
                                                  mainAxisSpacing:
                                                      8.0, // Khoảng cách giữa các ô
                                                  crossAxisSpacing:
                                                      8.0, // Khoảng cách giữa các hàng
                                                  childAspectRatio:
                                                      1, // Tỉ lệ của các ô (rộng:cao = 1:1)
                                                ),
                                                itemCount: 79, // Số lượng item
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    //color: Colors.blueAccent,
                                                    child: Center(
                                                        child: Icon_Widget(
                                                      id: 1,
                                                      icon:
                                                          "assets/all/(${index + 1}).svg",
                                                      istapping: view_model
                                                              .icon_selected ==
                                                          index + 1,
                                                      onPressed: () {
                                                        view_model.set_icon(
                                                            index + 1);
                                                      },
                                                    )),
                                                  );
                                                },
                                              ),
                                            ),
                                            Expanded(child: Container()),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 20,
                                                        horizontal: 60),
                                                child: CustomElement(
                                                  onTap: () async {
                                                    await view_model
                                                        .create_new_activity();
                                                    setState(() {
                                                      adding_actitvity_mode =
                                                          false;
                                                      step = 1;
                                                    });
                                                    _pageViewController
                                                        .animateToPage(1,
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        500),
                                                            curve: Curves
                                                                .decelerate);
                                                  },
                                                  child: Container(
                                                    width: screenWidth * 0.7,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            //horizontal: screenWidth * 0.25,
                                                            vertical:
                                                                screenWidth *
                                                                    0.05),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(1000),
                                                        color: Colors.white),
                                                    child: Text(
                                                      "CREATE ACTIVITY",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: all_color[
                                                                  theme_selected]
                                                              [0],
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ))
                                          ],
                                        )),

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                                  FadeTransitionPage(
                                    controller: _pageViewController,
                                    index: 2,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.1),
                                          child: text_intro(
                                              text:
                                                  ".. and how are you felling about this ?",
                                              color: Colors.white,
                                              fontsize: 20),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "Select up to 10 fellings",
                                          style: TextStyle(
                                              fontFamily: 'Second',
                                              color: Colors.black
                                                  .withOpacity(0.15),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: screenHeight * 0.15,
                                          ),
                                        ),
                                        Container(
                                          height: screenWidth * 0.8,
                                          child: GridView.count(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      screenWidth * 0.1),
                                              scrollDirection: Axis.horizontal,
                                              mainAxisSpacing:
                                                  screenWidth * 0.04,
                                              crossAxisSpacing:
                                                  screenWidth * 0.02,
                                              crossAxisCount: 3,
                                              children: [
                                                ...List.generate(
                                                  view_model.all_feeling.length,
                                                  (index) {
                                                    return Feeling_Widget(
                                                        onPressed: () {
                                                          if (view_model
                                                              .selected_feeling
                                                              .contains(view_model
                                                                      .all_feeling[
                                                                  index])) {
                                                            view_model
                                                                .selected_feeling
                                                                .remove(view_model
                                                                        .all_feeling[
                                                                    index]);
                                                          } else {
                                                            view_model
                                                                .selected_feeling
                                                                .add(view_model
                                                                        .all_feeling[
                                                                    index]);
                                                          }
                                                          print(view_model
                                                              .selected_feeling);
                                                          setState(() {});
                                                        },
                                                        feeling: view_model
                                                            .all_feeling[index],
                                                        istapping: view_model
                                                            .selected_feeling
                                                            .contains(view_model
                                                                    .all_feeling[
                                                                index]));
                                                  },
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      adding_feeling_mode =
                                                          true;
                                                      next_step();
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                    size: screenWidth * 0.075,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                        SizedBox(
                                          height: screenHeight * 0.05,
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20, horizontal: 60),
                                            child: CustomElement(
                                              onTap: next_step,
                                              child: Container(
                                                width: screenWidth * 0.7,
                                                padding: EdgeInsets.symmetric(
                                                    //horizontal: screenWidth * 0.25,
                                                    vertical:
                                                        screenWidth * 0.05),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            250),
                                                    color: Colors.white),
                                                child: Text(
                                                  "CONTINUE",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: all_color[
                                                          theme_selected][0],
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                                  if (adding_feeling_mode)
                                    FadeTransitionPage(
                                        controller: _pageViewController,
                                        index: 3,
                                        child: Stack(children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: screenWidth * 0.5,
                                              ),
                                              Container(
                                                child: Scrollable(
                                                  viewportBuilder:
                                                      (context, position) {
                                                    return Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      screenWidth *
                                                                          0.05),
                                                          child: Custom_Input(
                                                            onChanged: (p0) {
                                                              view_model
                                                                  .new_activity_title = p0;
                                                            },
                                                            fontsize:
                                                                screenWidth *
                                                                    0.04,
                                                            limit: 15,
                                                            viewing: false,
                                                            need_focus: true,
                                                            hint:
                                                                "Type here...",
                                                          ),
                                                        ),
                                                        Text(
                                                          "One word , no special characters",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.75),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  screenWidth *
                                                                      0.038),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              screenWidth * 0.3,
                                                        )
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                              Expanded(child: SizedBox()),
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 20,
                                                      horizontal: 60),
                                                  child: CustomElement(
                                                    onTap: next_step,
                                                    child: Container(
                                                      width: screenWidth * 0.7,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              //horizontal: screenWidth * 0.25,
                                                              vertical:
                                                                  screenWidth *
                                                                      0.05),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      1000),
                                                          color: Colors.white),
                                                      child: Text(
                                                        "NEXT",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: all_color[
                                                                    theme_selected]
                                                                [0],
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ))
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(
                                                screenWidth * 0.05),
                                            child: Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: AnimatedScale(
                                                  curve: Curves.elasticOut,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  scale: MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom >
                                                          0
                                                      ? 1
                                                      : 0,
                                                  child: CustomElement(
                                                      child: Container(
                                                    padding: EdgeInsets.all(
                                                        screenWidth * 0.025),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child:
                                                        const Icon(Icons.check),
                                                  )),
                                                )),
                                          ),
                                        ])),

                                  if (adding_feeling_mode)
                                    FadeTransitionPage(
                                        controller: _pageViewController,
                                        index: 4,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      screenWidth * 0.1),
                                              child: Text(
                                                "Now, select an icon that best represents ",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        screenWidth * 0.042),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: screenWidth * 0.4),
                                              height: screenWidth *
                                                  0.7, // Đặt chiều cao phù hợp cho GridView
                                              child: GridView.builder(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        screenWidth * 0.1),
                                                scrollDirection: Axis
                                                    .horizontal, // Cuộn ngang
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 4, // Số hàng
                                                  mainAxisSpacing:
                                                      8.0, // Khoảng cách giữa các ô
                                                  crossAxisSpacing:
                                                      8.0, // Khoảng cách giữa các hàng
                                                  childAspectRatio:
                                                      1, // Tỉ lệ của các ô (rộng:cao = 1:1)
                                                ),
                                                itemCount: 79, // Số lượng item
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    //color: Colors.blueAccent,
                                                    child: Center(
                                                        child: Icon_Widget(
                                                      id: 1,
                                                      icon:
                                                          "assets/all/(${index + 1}).svg",
                                                      istapping: view_model
                                                              .icon_selected ==
                                                          index + 1,
                                                      onPressed: () {
                                                        view_model.set_icon(
                                                            index + 1);
                                                      },
                                                    )),
                                                  );
                                                },
                                              ),
                                            ),
                                            Expanded(child: Container()),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 20,
                                                        horizontal: 60),
                                                child: CustomElement(
                                                  onTap: () async {
                                                    await view_model
                                                        .create_new_feeling();
                                                    setState(() {
                                                      adding_feeling_mode =
                                                          false;
                                                      step = 1;
                                                    });
                                                    _pageViewController
                                                        .animateToPage(2,
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        500),
                                                            curve: Curves
                                                                .decelerate);
                                                  },
                                                  child: Container(
                                                    width: screenWidth * 0.7,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            //horizontal: screenWidth * 0.25,
                                                            vertical:
                                                                screenWidth *
                                                                    0.05),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(1000),
                                                        color: Colors.white),
                                                    child: Text(
                                                      "CREATE FEELING",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: all_color[
                                                                  theme_selected]
                                                              [0],
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ))
                                          ],
                                        )),

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                                  FadeTransitionPage(
                                    controller: _pageViewController,
                                    index: 3,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0),
                                          child: Center(
                                            child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/all/(16).svg",
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                            Colors.black
                                                                .withOpacity(
                                                                    0.03),
                                                            BlendMode.srcIn),
                                                    width: 50,
                                                  ),
                                                  text_intro(
                                                      text:
                                                          "${fullMonth[DateTime.now().month]!.toUpperCase()} ${DateTime.now().day},  ${DateTime.now().hour}:${DateTime.now().minute}",
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                      fontsize:
                                                          screenWidth * 0.04),
                                                ]),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: padding_width),
                                                child: Text(
                                                  "Activities",
                                                  style: TextStyle(
                                                      fontFamily: "Second",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          screenWidth * 0.12,
                                                      color:
                                                          const Color.fromARGB(
                                                              26, 0, 0, 0)),
                                                ),
                                              ),
                                              SingleChildScrollView(
                                                padding: EdgeInsets.only(
                                                    top: screenHeight * 0.06,
                                                    left: padding_width,
                                                    right: padding_width),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: List.generate(
                                                    view_model.selected_activity
                                                        .length,
                                                    (index) => Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  screenWidth *
                                                                      0.02),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  screenWidth *
                                                                      0.025,
                                                              vertical:
                                                                  screenWidth *
                                                                      0.02),
                                                      decoration: BoxDecoration(
                                                          boxShadow: my_shadow,
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            height:
                                                                screenWidth *
                                                                    0.05,
                                                            data.icon_url(view_model
                                                                .selected_activity[
                                                                    index]
                                                                .icon),
                                                            colorFilter:
                                                                ColorFilter.mode(
                                                                    all_color[
                                                                            theme_selected]
                                                                        [0],
                                                                    BlendMode
                                                                        .srcIn),
                                                          ),
                                                          SizedBox(
                                                            width: screenWidth *
                                                                0.02,
                                                          ),
                                                          Text(
                                                            view_model
                                                                .selected_activity[
                                                                    index]
                                                                .title,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    screenWidth *
                                                                        0.025,
                                                                color: all_color[
                                                                        theme_selected]
                                                                    [0]),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: padding_width),
                                                child: Text(
                                                  "Feelings",
                                                  style: TextStyle(
                                                      fontFamily: "Second",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          screenWidth * 0.12,
                                                      color:
                                                          const Color.fromARGB(
                                                              26, 0, 0, 0)),
                                                ),
                                              ),
                                              SingleChildScrollView(
                                                padding: EdgeInsets.only(
                                                    top: screenHeight * 0.06,
                                                    left: padding_width,
                                                    right: padding_width),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: List.generate(
                                                    view_model.selected_feeling
                                                        .length,
                                                    (index) => Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  screenWidth *
                                                                      0.02),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  screenWidth *
                                                                      0.025,
                                                              vertical:
                                                                  screenWidth *
                                                                      0.02),
                                                      decoration: BoxDecoration(
                                                          boxShadow: my_shadow,
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            height:
                                                                screenWidth *
                                                                    0.05,
                                                            data.icon_url(view_model
                                                                .selected_feeling[
                                                                    index]
                                                                .icon),
                                                            colorFilter:
                                                                ColorFilter.mode(
                                                                    all_color[
                                                                            theme_selected]
                                                                        [0],
                                                                    BlendMode
                                                                        .srcIn),
                                                          ),
                                                          SizedBox(
                                                            width: screenWidth *
                                                                0.02,
                                                          ),
                                                          Text(
                                                            view_model
                                                                .selected_feeling[
                                                                    index]
                                                                .title,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    screenWidth *
                                                                        0.025,
                                                                color: all_color[
                                                                        theme_selected]
                                                                    [0]),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              title_typing = true;
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: padding_width,
                                                vertical: padding_width),
                                            width: 10000000,
                                            padding: EdgeInsets.all(
                                                screenWidth * 0.05),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.black
                                                    .withOpacity(0.05)),
                                            child: Text(
                                              view_model.title.length == 0
                                                  ? "Title ..."
                                                  : view_model.title,
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      153, 255, 255, 255),
                                                  fontSize: screenWidth * 0.045,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              note_typing = true;
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: padding_width,
                                                vertical: 0),
                                            width: 10000000,
                                            height: screenHeight * 0.15,
                                            padding: EdgeInsets.all(
                                                screenWidth * 0.05),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.black
                                                    .withOpacity(0.05)),
                                            child: Text(
                                              view_model.notes.length == 0
                                                  ? "Add some notes ..."
                                                  : view_model.notes,
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    153, 255, 255, 255),
                                                //fontSize: screenWidth * 0.045,
                                                //fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(child: Container()),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20, horizontal: 60),
                                            child: CustomElement(
                                              onTap: () async {
                                                await view_model
                                                    .submit_checkin();
                                                Navigator.pop(context);
                                                try {
                                                  Provider.of<Entries_Viewmodel>(
                                                          context,
                                                          listen: false)
                                                      .loadData();
                                                } catch (e) {
                                                  print(e);
                                                }
                                              },
                                              child: Container(
                                                width: screenWidth * 0.7,
                                                padding: EdgeInsets.symmetric(
                                                    //horizontal: screenWidth * 0.25,
                                                    vertical:
                                                        screenWidth * 0.05),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1000),
                                                    color: Colors.white),
                                                child: Text(
                                                  "COMPLETE CHECK-IN",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: all_color[
                                                          theme_selected][0],
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                ),
                if (date_picking)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        date_picking = false;
                      });
                    },
                    child: Container(
                      width: screenWidth,
                      height: screenHeight,
                      color: const Color.fromARGB(129, 0, 39, 67),
                    ),
                  ),
                if (date_picking)
                  // DateTimeSetter(
                  //   padding_width: padding_width,
                  //   time_picked: view_model.checkin_time,
                  // ),
                  DateTimeSetter(
                    padding_width: 16.0,
                    time_picked: view_model.checkin_time,
                    onTimeChanged: (newTime) {
                      setState(() {
                        // Cập nhật giá trị DateTime ở widget cha
                        view_model.checkin_time = newTime;
                      });
                    },
                  ),
                if (title_typing)
                  Container(
                    child: Stack(children: [
                      Center(
                          child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.05),
                        child: Custom_Input(
                          fontsize: screenWidth * 0.04,
                          text: view_model.title,
                          onChanged: (value) {
                            view_model.title = value;
                          },
                          limit: 40,
                          need_focus: true,
                          viewing: false,
                          //enable: true,
                        ),
                      )),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(top: screenWidth * 0.15),
                            child: Text(
                              "Mood Check-In Title",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.05),
                            ),
                          )),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CustomElement(
                            onTap: () {
                              setState(() {
                                title_typing = false;
                              });
                            },
                            child: Container(
                                padding: EdgeInsets.all(screenWidth * 0.025),
                                margin: EdgeInsets.all(screenWidth * 0.05),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 0.025)),
                                child: Icon(Icons.check))),
                      )
                    ]),
                  ),
                if (note_typing)
                  Container(
                    child: Stack(children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05,
                              vertical: screenWidth * 0.3),
                          child: TextField(
                            autofocus: true,
                            controller: _text_notes_controller,
                            onChanged: (value) {
                              view_model.notes = value;
                            },
                            maxLines: 15, // Giới hạn chiều cao tối đa (5 dòng)
                            minLines: 15, // Đặt chiều cao tối thiểu
                            expands:
                                false, // Không mở rộng để lấp đầy không gian có sẵn
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.04,
                            ),
                            decoration: InputDecoration(
                              border: const UnderlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding:
                                  EdgeInsets.all(screenWidth * 0.05),
                              hintText: 'Type here ...',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.04,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              fillColor: const Color.fromARGB(14, 0, 0, 0),
                              filled: true,
                            ),
                            // Đặt cuộn khi số dòng vượt quá chiều cao của TextField
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            scrollPhysics:
                                BouncingScrollPhysics(), // Cho phép cuộn mượt mà
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(top: screenWidth * 0.15),
                            child: Text(
                              "Notes",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.05),
                            ),
                          )),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CustomElement(
                            onTap: () {
                              setState(() {
                                note_typing = false;
                              });
                            },
                            child: Container(
                                padding: EdgeInsets.all(screenWidth * 0.025),
                                margin: EdgeInsets.all(screenWidth * 0.05),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 0.025)),
                                child: Icon(Icons.check))),
                      )
                    ]),
                  ),
              ]));
            })));
  }

  void set_mood(double mood) {
    switch (mood.toInt()) {
      case (0):
        {
          icon = data.mood[0]!;
          text = "REALLY TERRIBLE";
          return;
        }
      case (1):
        {
          icon = data.mood[1]!;
          text = "SOMEWHAT BAD";
          return;
        }
      case (2):
        {
          icon = data.mood[2]!;
          text = "COMPLETELY OKAY";
          return;
        }
      case (3):
        {
          icon = data.mood[3]!;
          text = "PRETTY GOOD";
          return;
        }
      case (4):
        {
          icon = data.mood[4]!;
          text = "SUPER AWSOME";
          return;
        }
    }
  }
}

String subtitle(int index) {
  return index == 0
      ? "Sorry about that.."
      : index == 1
          ? "Hmm..."
          : index == 2
              ? "Cool!"
              : index == 3
                  ? "Great!"
                  : "Amazing!";
}

class Icon_Widget extends StatefulWidget {
  final int id;
  final String icon;
  bool istapping = false;
  final VoidCallback onPressed;
  Icon_Widget(
      {super.key,
      required this.icon,
      required this.istapping,
      required this.id,
      required this.onPressed});
  @override
  State<StatefulWidget> createState() => Icon_WidgetState();
}

class Icon_WidgetState extends State<Icon_Widget> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: () {
        widget.onPressed();
        // setState(() {
        //   widget.istapping = !widget.istapping;
        // });
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: widget.istapping ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(15)),
        child: SvgPicture.asset(
          widget.icon,
          width: screenWidth * 0.06,
          height: screenWidth * 0.06,
          colorFilter: ColorFilter.mode(
              !widget.istapping ? Colors.white : all_color[theme_selected][0],
              BlendMode.srcIn),
        ),
      ),
    );
  }
}

class Activity_Widget extends StatefulWidget {
  final Activity activity;
  bool istapping;
  final VoidCallback onPressed;
  Activity_Widget(
      {super.key,
      required this.istapping,
      required this.onPressed,
      required this.activity});
  @override
  State<StatefulWidget> createState() => ActivityState();
}

class ActivityState extends State<Activity_Widget> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    return GestureDetector(
      onTap: () {
        widget.onPressed();
      },
      child: Container(
        decoration: BoxDecoration(
            color: widget.istapping ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon_url(widget.activity.icon),
              width: screenWidth * 0.055,
              colorFilter: ColorFilter.mode(
                  !widget.istapping
                      ? Colors.white
                      : all_color[theme_selected][0],
                  BlendMode.srcIn),
            ),
            SizedBox(
              height: screenWidth * 0.01,
            ),
            text_intro(
                text: widget.activity.title,
                color: !widget.istapping
                    ? Colors.white
                    : all_color[theme_selected][0],
                fontsize: screenWidth * 0.03)
          ],
        ),
      ),
    );
  }
}

class Feeling_Widget extends StatefulWidget {
  final Feeling feeling;
  bool istapping;
  final VoidCallback onPressed;
  Feeling_Widget(
      {super.key,
      required this.istapping,
      required this.onPressed,
      required this.feeling});
  @override
  State<StatefulWidget> createState() => Feeling_Widget_State();
}

class Feeling_Widget_State extends State<Feeling_Widget> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: () {
        widget.onPressed();
      },
      child: Container(
        decoration: BoxDecoration(
            color: widget.istapping ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon_url(widget.feeling.icon),
              width: screenWidth * 0.055,
              colorFilter: ColorFilter.mode(
                  !widget.istapping
                      ? Colors.white
                      : all_color[theme_selected][0],
                  BlendMode.srcIn),
            ),
            SizedBox(
              height: screenWidth * 0.01,
            ),
            text_intro(
                text: widget.feeling.title,
                color: !widget.istapping
                    ? Colors.white
                    : all_color[theme_selected][0],
                fontsize: screenWidth * 0.03)
          ],
        ),
      ),
    );
  }
}
