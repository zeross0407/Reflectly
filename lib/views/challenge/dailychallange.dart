import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myrefectly/help/effect.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/views/challenge/daily_challenge_viewmodel.dart';
import 'package:provider/provider.dart';

class Daily_Challange_Page extends StatefulWidget {
  Daily_Challange_Page();
  @override
  State<StatefulWidget> createState() => Daily_Challange_Page_State();
}

class Daily_Challange_Page_State extends State<Daily_Challange_Page>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  late Timer _timer;
  Duration _timeLeft = const Duration();
  @override
  void initState() {
    super.initState();
    _startTimer();

    _controller = TabController(length: 2, vsync: this)
      ..addListener(
        () {
          setState(() {});
        },
      );
  }

  void _startTimer() {
    DateTime now = DateTime.now();

    DateTime endTime = DateTime(now.year, now.month, now.day, 23, 59, 0);

    if (now.isAfter(endTime)) {
      endTime = endTime.add(const Duration(days: 1));
    }
    setState(() {
      _timeLeft = endTime.difference(now);
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds <= 0) {
        _timer.cancel();
      } else {
        try {
          setState(() {
            _timeLeft = _timeLeft - const Duration(seconds: 1);
          });
        } catch (e) {}
      }
    });
  }

  String formatTime(Duration duration) {
    String hours = duration.inHours.toString().padLeft(2, '0');
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return ChangeNotifierProvider<Daily_Challenge_Viewmodel>(
      create: (context) => Daily_Challenge_Viewmodel(),
      child: Consumer<Daily_Challenge_Viewmodel>(
          builder: (context, view_model, child) {
        return Scaffold(
          body: view_model.is_loading == false
              ? Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: all_color[theme_selected]),
                  ),
                  child: Stack(children: [
                    AnimatedAlign(
                      alignment: _controller.index == 0
                          ? Alignment.topCenter
                          : Alignment.bottomCenter,
                      duration: Duration(milliseconds: 700),
                      curve: Curves.decelerate,
                      child: Container(
                        //margin: EdgeInsets.only(top: screenWidth * 0.04),
                        height: screenWidth * 0.65,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(
                                screenWidth * 0.075), // Bo góc dưới bên trái
                          ),
                          child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Positioned(
                                  bottom: _controller.index == 0
                                      ? -screenWidth * 0.22
                                      : 0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(screenWidth *
                                          0.075), // Bo góc dưới bên trái
                                    ),
                                    child: Image.asset(
                                      "assets/challenge_images/challenge_uncompleted.png",
                                      height: screenWidth * 0.6,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(22)),
                                    color: _controller.index == 0
                                        ? Colors.black.withOpacity(0.1)
                                        : Colors.transparent,
                                  ),
                                )
                              ]),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 500),
                      top: screenWidth * 0.61,
                      left: _controller.index == 0 ? 0 : -screenWidth,
                      curve: Curves.decelerate,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.3333),
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02),
                        height: screenWidth * 0.08,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(1000)),
                        child: Center(
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/ico/time.svg"),
                              Text(
                                "  ENDS IN  ${formatTime(view_model.timeLeft)} ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Second",
                                    fontSize: screenWidth * 0.025),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _controller,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: screenHeight * 0.2,
                              ),
                              Expanded(
                                  child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.1),
                                child: Center(
                                    child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: 'Today I will ',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: "Google"),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: view_model.week_home!
                                              .todayChallenge!.description,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                )),
                              )),
                              GestureDetector(
                                onTap: () {
                                  _controller.animateTo(1,
                                      duration: Duration(milliseconds: 200));
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.15,
                                      vertical: screenWidth * 0.05),
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenWidth * 0.05),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(1000)),
                                  child: Center(
                                    child: Text(
                                      "ACCEPT CHALLENGE",
                                      style: TextStyle(
                                          fontFamily: "Second",
                                          color: all_color[theme_selected][0],
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * 0.03),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Good luck, MyFriend !",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.045,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.1,
                                          vertical: screenWidth * 0.03),
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          text: 'You\'ve got a little over ',
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.045,
                                              fontFamily: "Google"),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                    '${view_model.timeLeft.inHours} hours',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                              text:
                                                  ' to complete today\'s challenge.',
                                            ),
                                          ],
                                        ),
                                      )),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.1),
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          text: '... and remember',
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.045,
                                              fontFamily: "Google"),
                                          children: const <TextSpan>[
                                            TextSpan(
                                                text:
                                                    ', pics or it didn\'t happen!',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      )),
                                ],
                              )),
                              GestureDetector(
                                onTap: () async {
                                  await (view_model
                                          .week_home!.challenge_completed[
                                      DateTime.now().weekday - 1] = 1);
                                  Navigator.of(context).pop();

                                  // Hủy ViewModel ngay sau khi màn hình đã pop
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.15,
                                      vertical: screenWidth * 0.05),
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenWidth * 0.05),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(1000)),
                                  child: Center(
                                    child: Text(
                                      "I GOT THIS",
                                      style: TextStyle(
                                          fontFamily: "Second",
                                          color: all_color[theme_selected][0],
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * 0.03),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ]),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: screenWidth * 0.1),
                        child: Column(
                          children: [
                            Text(
                              "Daily Challenge",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${weekday[DateTime.now().weekday]!.toUpperCase()}, ${fullMonth[DateTime.now().month]!.toUpperCase()} ${DateTime.now().day}",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                  fontSize: screenWidth * 0.03,
                                  fontFamily: "Second",
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: screenWidth * 0.1, right: screenWidth * 0.05),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: screenWidth * 126 / 1028,
                            width: screenWidth * 126 / 1028,
                            padding: EdgeInsets.all(screenWidth * 0.03),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.025),
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.045)),
                            child: SvgPicture.asset(
                              "assets/ico/x.svg",
                              colorFilter: ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (view_model.uploading)
                      Container(
                        width: screenWidth,
                        height: screenHeight,
                        color: Colors.black.withOpacity(0.3),
                        child: Center(
                          child: Container(
                            height: screenWidth * 0.4,
                            width: screenWidth * 0.45,
                            padding: EdgeInsets.all(screenWidth * 0.05),
                            decoration: BoxDecoration(
                                color: is_darkmode ? card_dark : Colors.white,
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.05)),
                            child: Stack(
                              children: [
                                Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: screenWidth * 0.05,
                                      ),
                                      RotatingSvgIcon(),
                                      SizedBox(
                                        height: screenWidth * 0.05,
                                      ),
                                      Text(
                                        "UPLOADING ...",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Second",
                                            color: is_darkmode
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        view_model.uploading =
                                            !view_model.uploading;
                                      });
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: is_darkmode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                  ]),
                )
              : Container(),
        );
      }),
    );
  }
}
