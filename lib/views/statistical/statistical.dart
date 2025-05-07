import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myrefectly/help/delay_animation.dart';
import 'package:myrefectly/help/effect.dart';
import 'package:myrefectly/views/statistical/linechart.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/views/home/home.dart';
import 'package:myrefectly/theme/color.dart';
import 'package:myrefectly/views/statistical/circular_chart.dart';
import 'package:myrefectly/views/statistical/statistical_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:myrefectly/help/color.dart';

class StatisticalPage extends StatefulWidget {
  const StatisticalPage({super.key});

  @override
  State<StatefulWidget> createState() => StatisticalPageState();
}

class StatisticalPageState extends State<StatisticalPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  double _heightFactor = 0.45; // Chiều cao ban đầu
  bool build_complete = false;
  bool is_weekly = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateHeight();
      build_complete = true;
    });
  }

  void _animateHeight() {
    setState(() {
      _heightFactor = 0.65;
    });
  }

  String getWeekRange(DateTime date) {
    // Danh sách tên tháng
    List<String> monthNames = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];

    // Tính toán ngày bắt đầu của tuần (Thứ 2 là ngày đầu tuần)
    int weekday = date.weekday;
    DateTime startOfWeek =
        date.subtract(Duration(days: weekday - 1)); // Thứ 2 là ngày đầu tuần

    // Tính toán ngày cuối tuần (Chủ Nhật là ngày cuối tuần)
    DateTime endOfWeek =
        startOfWeek.add(Duration(days: 6)); // Chủ Nhật là ngày cuối tuần

    // Định dạng ngày tháng với tên tháng
    String startDateFormatted =
        "${startOfWeek.day} ${monthNames[startOfWeek.month - 1]}"; // 25 NOV
    String endDateFormatted =
        "${endOfWeek.day} ${monthNames[endOfWeek.month - 1]}"; // 1 DEC

    return "$startDateFormatted - $endDateFormatted";
  }

  String getWeekStatus(DateTime date) {
    // Lấy ngày hiện tại
    DateTime now = DateTime.now();

    // Tính toán ngày đầu tuần của hiện tại và ngày đầu tuần của date
    DateTime startOfWeekNow = now.subtract(Duration(days: now.weekday - 1));
    DateTime startOfWeekDate = date.subtract(Duration(days: date.weekday - 1));

    // Nếu cùng tuần
    if (startOfWeekNow.year == startOfWeekDate.year &&
        startOfWeekNow.month == startOfWeekDate.month &&
        startOfWeekNow.day == startOfWeekDate.day) {
      return "THIS WEEK";
    }

    // Tính toán số tuần chênh lệch
    int weekDifference = ((now.difference(date).inDays) / 7).abs().round();

    // Trả về số tuần trước nếu weekDifference > 0
    return weekDifference > 0 ? "$weekDifference WEEK AGO" : "THIS WEEK";
  }

  String getMood(double mood) {
    if (mood >= 0 && mood < 1) {
      return "Really Terrible";
    } else if (mood >= 1 && mood < 2) {
      return "Somewhat Bad";
    } else if (mood >= 2 && mood < 3) {
      return "Completely Okay";
    } else if (mood >= 3 && mood <= 4) {
      return "Super Awesome";
    }
    return "Nothing to show";
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    double paddingWidth = screenWidth * 0.05;
    return ChangeNotifierProvider<Statistical_Viewmodel>(
        create: (context) => Statistical_Viewmodel(screenWidth),
        child: Consumer<Statistical_Viewmodel>(
            builder: (context, view_model, child) {
          return Scaffold(
            backgroundColor: is_darkmode ? background_dark : background_light,
            body: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedBuilder(
                    animation: _scrollController,
                    builder: (context, child) {
                      double offset = 0;
                      if (_scrollController.hasClients) {
                        offset = _scrollController.offset;
                      }
                      return Transform.translate(
                        offset: Offset(0, -offset * 0.5),
                        child: AnimatedContainer(
                          duration: const Duration(
                              seconds: 2), // Thời gian chuyển đổi
                          curve: Curves.easeInOut, // Hiệu ứng chuyển đổi
                          height: screenHeight * _heightFactor,
                          child: ClipPath(
                            clipper: BottomCurveClipper(),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: all_color[theme_selected],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (false)
                          DelayAnimation(
                            delay: 0,
                            offset_animation: 0.1,
                            shouldFaded: false,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: screenWidth * 0.15,
                                  horizontal: screenWidth * 0.25),
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.05),
                                      borderRadius:
                                          BorderRadius.circular(10000)),
                                  child: TabBar(
                                    controller: _tabController,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    dividerColor: Colors.transparent,
                                    indicator: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(1000)),
                                    ),
                                    labelColor: all_color[theme_selected][0],
                                    unselectedLabelColor: Colors.white,
                                    tabs: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: screenWidth * 0.025),
                                        child: Text(
                                          "weekly",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenWidth * 0.03,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: screenWidth * 0.025),
                                        child: Text(
                                          "monthly",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenWidth * 0.03,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                        SizedBox(
                          height: screenWidth * 0.3,
                        ),
                        DelayAnimation(
                          delay: 200,
                          shouldFaded: false,
                          child: Padding(
                            padding: EdgeInsets.only(left: paddingWidth),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getMood(view_model.average_mood),
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.06,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "AVERAGE MOOD : ",
                                        style: TextStyle(
                                            fontSize: screenWidth * 0.03,
                                            color: Colors.white,
                                            //fontWeight: FontWeight.bold,
                                            fontFamily: "Second"),
                                      ),
                                      Text(
                                        view_model.average_mood.isNaN
                                            ? ""
                                            : "${(view_model.average_mood / 4 * 100).toStringAsFixed(1)}%", // Giới hạn 1 chữ số sau dấu phẩy
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.03,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Second",
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),

                        Container(
                          height: screenWidth * 0.6,
                          child: (view_model.current_data.length > 0)
                              ? Stack(children: [
                                  if (view_model.previous_data.length > 0)
                                    SmoothLineChart(
                                      time: view_model.current_data_time,
                                      lineColor: Colors.black.withOpacity(0.1),
                                      needTooltip: false,
                                      points: [
                                        Offset(0, 100),
                                        ...view_model.previous_data,
                                        Offset(screenWidth, 100),
                                      ],
                                    ),
                                  if (view_model.current_data.length > 0)
                                    SmoothLineChart(
                                      time: view_model.current_data_time,
                                      lineColor: Colors.white,
                                      needTooltip: true,
                                      points: [
                                        Offset(0, 100),
                                        ...view_model.current_data,
                                      ],
                                    ),
                                ])
                              : Center(child: empty_data()),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth / 8 - 5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                7,
                                (index) => Text(
                                  day[index][0],
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.03,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Second"),
                                ),
                              )),
                        ),
                        SizedBox(
                          height: screenWidth * 0.05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Current Week",
                              style: TextStyle(
                                  fontSize: screenWidth * 0.025,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Second"),
                            ),
                            SizedBox(
                              width: screenWidth * 0.1,
                            ),
                            Text(
                              "Previous Week",
                              style: TextStyle(
                                  fontSize: screenWidth * 0.025,
                                  color: Colors.black.withOpacity(0.1),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Second"),
                            ),
                          ],
                        ),
                        DelayAnimation(
                          delay: 400,
                          shouldFaded: false,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 25),
                            margin: EdgeInsets.all(screenWidth * 0.05),
                            decoration: BoxDecoration(
                                color: is_darkmode ? card_dark : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: my_shadow),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      getWeekStatus(view_model.time_statis),
                                      style: TextStyle(
                                          fontFamily: "Second",
                                          fontWeight: FontWeight.bold,
                                          color: is_darkmode
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(getWeekRange(view_model.time_statis),
                                        style: TextStyle(
                                            fontSize: screenWidth * 0.025,
                                            fontFamily: 'Second',
                                            fontWeight: FontWeight.bold,
                                            color: is_darkmode
                                                ? Colors.white
                                                : Colors.black
                                                    .withOpacity(0.5))),
                                  ],
                                ),
                                Expanded(child: Container()),
                                GestureDetector(
                                  onTap: () async {
                                    view_model.time_statis = view_model
                                        .time_statis
                                        .subtract(Duration(days: 7));
                                    await view_model
                                        .statis(view_model.time_statis);
                                    setState(() {});
                                  },
                                  child: Icon(Icons.arrow_back_ios_new_rounded,
                                      color: is_darkmode
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.04,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (isSameWeek(view_model.time_statis))
                                      return;
                                    view_model.time_statis = view_model
                                        .time_statis
                                        .add(Duration(days: 7));
                                    await view_model
                                        .statis(view_model.time_statis);
                                    setState(() {});
                                  },
                                  child: RotatedBox(
                                      quarterTurns: 2,
                                      child: Icon(
                                          Icons.arrow_back_ios_new_rounded,
                                          color: is_darkmode
                                              ? Colors.white
                                              : Colors.black.withOpacity(
                                                  isSameWeek(view_model
                                                          .time_statis)
                                                      ? 0.2
                                                      : 1))),
                                )
                              ],
                            ),
                          ),
                        ),

                        DelayAnimation(
                          delay: 600,
                          shouldFaded: false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Card_Statistical(
                                    Center(
                                      heightFactor: 1.4,
                                      child: Column(
                                        children: [
                                          AnimatedCounter(
                                            targetNumber:
                                                view_model.negative_day,
                                            textStyle: TextStyle(
                                                fontFamily: "Second",
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                color: is_darkmode
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                          Text(
                                            "NEGATIVE DAYS",
                                            style: TextStyle(
                                                fontSize: screenWidth * 0.03,
                                                fontWeight: FontWeight.bold,
                                                color: is_darkmode
                                                    ? Colors.white
                                                    : Colors.black),
                                          )
                                        ],
                                      ),
                                    ),
                                    mood[0]!,
                                    120),
                                const SizedBox(
                                  width: 15,
                                ),
                                Card_Statistical(
                                    Center(
                                      heightFactor: 1.4,
                                      child: Column(
                                        children: [
                                          Text(
                                            view_model.positive_day.toString(),
                                            style: TextStyle(
                                                fontFamily: "Second",
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                color: is_darkmode
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                          Text(
                                            "POSITIVE DAYS",
                                            style: TextStyle(
                                                fontSize: screenWidth * 0.03,
                                                fontWeight: FontWeight.bold,
                                                color: is_darkmode
                                                    ? Colors.white
                                                    : Colors.black),
                                          )
                                        ],
                                      ),
                                    ),
                                    mood[4]!,
                                    120),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenWidth * 0.05,
                        ),

                        DelayAnimation(
                          delay: 900,
                          shouldFaded: false,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 30),
                            margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05,
                            ),
                            decoration: BoxDecoration(
                                color: is_darkmode ? card_dark : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: my_shadow),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "What make you shine\n",
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.bold,
                                      color: is_darkmode
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                Wrap(
                                  runSpacing: screenWidth * 0.025,
                                  spacing: screenWidth * 0.03,
                                  children: [
                                    ...List.generate(
                                      view_model.shine.length,
                                      (index) => Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.03,
                                            vertical: screenWidth * 0.015),
                                        decoration: BoxDecoration(
                                            color: Color.lerp(
                                              all_color[theme_selected][0],
                                              is_darkmode
                                                  ? Color.fromARGB(
                                                      255, 41, 66, 97)
                                                  : Colors.white,
                                              0.925,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset(
                                              height: screenWidth * 0.05,
                                              icon_url(
                                                  view_model.shine[index].icon),
                                              colorFilter: ColorFilter.mode(
                                                  all_color[theme_selected][0],
                                                  BlendMode.srcIn),
                                            ),
                                            SizedBox(
                                              width: screenWidth * 0.015,
                                            ),
                                            Text(
                                              view_model.shine[index].title,
                                              style: TextStyle(
                                                  color:
                                                      all_color[theme_selected]
                                                          [0],
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (view_model.shine.length == 0)
                                      Center(
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: screenWidth * 0.1),
                                            child: empty_data()),
                                      )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        DelayAnimation(
                          delay: 800,
                          shouldFaded: false,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 30),
                            margin: EdgeInsets.all(screenWidth * 0.05),
                            decoration: BoxDecoration(
                                color: is_darkmode ? card_dark : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: my_shadow),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "What get you down\n",
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.bold,
                                      color: is_darkmode
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                if (view_model.down.length == 0)
                                  Center(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: screenWidth * 0.1),
                                        child: empty_data()),
                                  ),
                                Wrap(
                                  runSpacing: screenWidth * 0.025,
                                  spacing: screenWidth * 0.03,
                                  children: [
                                    ...List.generate(
                                      view_model.down.length,
                                      (index) => Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.03,
                                            vertical: screenWidth * 0.015),
                                        decoration: BoxDecoration(
                                            color: Color.lerp(
                                              all_color[theme_selected][0],
                                              is_darkmode
                                                  ? Color.fromARGB(
                                                      255, 41, 66, 97)
                                                  : Colors.white,
                                              0.925,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset(
                                              height: screenWidth * 0.05,
                                              icon_url(
                                                  view_model.down[index].icon),
                                              colorFilter: ColorFilter.mode(
                                                  all_color[theme_selected][0],
                                                  BlendMode.srcIn),
                                            ),
                                            SizedBox(
                                              width: screenWidth * 0.015,
                                            ),
                                            Text(
                                              view_model.down[index].title,
                                              style: TextStyle(
                                                  color:
                                                      all_color[theme_selected]
                                                          [0],
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),

                        Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: is_darkmode ? card_dark : Colors.white,
                                boxShadow: my_shadow),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Mood break down",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: is_darkmode
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                        children: List.generate(
                                      5,
                                      (index) => MoodBreakdown(
                                          mood[index]!,
                                          view_model.mood_break_down[index],
                                          screenWidth * 0.375),
                                    )),
                                  )
                                ])),

                        Container(
                          margin: EdgeInsets.all(screenWidth * 0.05),
                          padding: EdgeInsets.all(screenWidth * 0.07),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: is_darkmode ? card_dark : Colors.white,
                              boxShadow: my_shadow),
                          child: Stack(alignment: Alignment.center, children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Most Activity",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: is_darkmode
                                              ? Colors.white
                                              : Colors.black)),
                                  SizedBox(
                                    height: screenWidth * 0.05,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 20),
                                        child: MultiArcWidget(
                                          width: screenWidth * 0.3,
                                          gradient: LinearGradient(
                                            colors: all_color[theme_selected],
                                          ),
                                          strokeWidth: 7,
                                          startAngle: -1.57,
                                          spacing: screenWidth * 0.033,
                                          percent: view_model
                                              .most_activity.values
                                              .toList(),
                                        ),
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.1,
                                      ),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(
                                            view_model.most_activity.length,
                                            (index) => Row(
                                              children: [
                                                Container(
                                                  height: 10,
                                                  width: 10,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              1000),
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            all_color[
                                                                theme_selected][0],
                                                            all_color[
                                                                theme_selected][1],
                                                          ])),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      view_model
                                                          .most_activity.keys
                                                          .toList()[index]
                                                          .title,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: is_darkmode
                                                              ? Colors.white
                                                              : Colors.black),
                                                    ),
                                                    Text(
                                                      "${(view_model.most_activity.values.toList()[index] * 100).toInt()}%",
                                                      style: TextStyle(
                                                        color: all_color[
                                                            theme_selected][0],
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ]),
                            if (view_model.most_activity.values
                                    .toList()
                                    .length ==
                                0)
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: screenWidth * 0.05),
                                  child: empty_data())
                          ]),
                        ),
////////////////////////////////////////
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05),
                          padding: EdgeInsets.all(screenWidth * 0.07),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: is_darkmode ? card_dark : Colors.white,
                              boxShadow: my_shadow),
                          child: Stack(alignment: Alignment.center, children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Frequent Feelings",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: is_darkmode
                                              ? Colors.white
                                              : Colors.black)),
                                  SizedBox(
                                    height: screenWidth * 0.05,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 20),
                                        child: MultiArcWidget(
                                          width: screenWidth * 0.3,
                                          gradient: LinearGradient(
                                            colors: all_color[theme_selected],
                                          ),
                                          strokeWidth: 7,
                                          startAngle: -1.57,
                                          spacing: screenWidth * 0.033,
                                          percent: view_model
                                              .frequent_feeling.values
                                              .toList(),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 40, right: 40),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: List.generate(
                                              view_model
                                                  .frequent_feeling.length,
                                              (index) => Row(
                                                children: [
                                                  Container(
                                                    height: 10,
                                                    width: 10,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(1000),
                                                        gradient:
                                                            LinearGradient(
                                                                colors: [
                                                              all_color[
                                                                  theme_selected][0],
                                                              all_color[
                                                                  theme_selected][1],
                                                            ])),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        view_model
                                                            .frequent_feeling
                                                            .keys
                                                            .toList()[index]
                                                            .title,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: is_darkmode
                                                                ? Colors.white
                                                                : Colors.black),
                                                      ),
                                                      Text(
                                                        "${(view_model.frequent_feeling.values.toList()[index] * 100).toInt()}%",
                                                        style: TextStyle(
                                                          color: all_color[
                                                              theme_selected][0],
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ]),
                            if (view_model.frequent_feeling.values
                                    .toList()
                                    .length ==
                                0)
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: screenWidth * 0.05),
                                  child: empty_data())
                          ]),
                        ),

                        SizedBox(
                          height: 100,
                        ),
                      ],
                    )),
              ],
            ),
          );
        }));
  }

  Widget empty_data() {
    return Text(
      "Nothing to show",
      style: TextStyle(
          fontFamily: "Second",
          color: Colors.black.withOpacity(0.075),
          fontWeight: FontWeight.w900),
    );
  }

  Widget Card_Statistical(Widget child, String background, double height) {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), boxShadow: my_shadow),
        child: Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 1000,
              height: height, // Đặt kích thước cho Container
              decoration: BoxDecoration(
                  color: is_darkmode ? card_dark : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: my_shadow),
              child: Stack(
                children: [
                  // Positioned SVG in the bottom right corner
                  Positioned(
                    bottom: -20, // Tràn ra ngoài một chút nếu cần
                    right: -20, // Tràn ra ngoài một chút nếu cần
                    child: SvgPicture.asset(
                      background,
                      width: 100,
                      height: 100,
                      colorFilter: const ColorFilter.mode(
                          Color.fromARGB(12, 0, 0, 0), BlendMode.srcIn),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: child,
          )
        ]),
      ),
    );
  }

  bool isSameWeek(DateTime date) {
    final now = DateTime.now();

    // Tính ngày đầu tuần hiện tại (thứ 2)
    final startOfWeek = now.subtract(Duration(days: now.weekday)).toUtc();

    // Tính ngày cuối tuần hiện tại (chủ nhật)
    final endOfWeek =
        startOfWeek.add(Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

    // Đưa `date` về UTC để so sánh
    final dateUtc = date.toUtc();

    return dateUtc.isAfter(startOfWeek.subtract(Duration(seconds: 1))) &&
        dateUtc.isBefore(endOfWeek.add(Duration(seconds: 1)));
  }

  Widget MoodBreakdown(String icon, double percent, double height) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 20),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1000),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: height,
                    width: 1000,
                    decoration: BoxDecoration(
                      color: is_darkmode
                          ? Colors.black.withOpacity(0.1)
                          : Colors.black.withOpacity(0.07),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: Container(
                      height: height * percent,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: all_color[theme_selected],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SvgPicture.asset(
            icon,
            width: height * 0.22,
            colorFilter: ColorFilter.mode(
                is_darkmode
                    ? Colors.white.withOpacity(0.75)
                    : Colors.black.withOpacity(0.75),
                BlendMode.srcIn),
          )
        ]),
      ),
    );
  }
}
