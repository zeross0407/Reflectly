import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/theme/color.dart';

class CardChallenge extends StatefulWidget {
  final Widget child;
  final String background;
  final double height;
  final Color? color;
  //final HomeViewmodel viewmodel;
  int step = 0;
  Challenge? challenge;

  CardChallenge(
      {super.key,
      required this.child,
      required this.background,
      required this.height,
      this.color,
      required this.step,
      this.challenge
      //required this.viewmodel
      });

  @override
  CardChallengeState createState() => CardChallengeState();
}

class CardChallengeState extends State<CardChallenge> {
  //bool challenge_completed = false;
  late Timer _timer;
  Duration _timeLeft = const Duration();

  @override
  void initState() {
    super.initState();
    _startTimer();
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
    return Container(
      decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: my_shadow),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(children: [
          Container(
            height: widget.height,
            decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(20),
                boxShadow: my_shadow),
            child: Stack(
              children: [
                Positioned(
                  bottom: -screenWidth * 0.15,
                  right: -screenWidth * 0.2,
                  child: Image.asset(
                    widget.step == 2
                        ? "assets/challenge_images/challenge_completed.png"
                        : "assets/challenge_images/challenge_uncompleted.png",
                    width: screenWidth * 0.8,
                    //height: 200,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(screenWidth * 0.015),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.05),
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.03)),
                            child: (widget.step != 2)
                                ? SvgPicture.asset(
                                    "assets/ico/mountain.svg",
                                    height: screenWidth * 0.065,
                                    colorFilter: const ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn),
                                  )
                                : Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.02,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.challenge != null && widget.step == 1)
                                Text("Current Challenge",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.03)),
                              if (widget.step < 2)
                                Text(
                                    "${widget.step == 1 ? "TIME LEFT -" : "ENDS IN -"}  ${formatTime(_timeLeft)}",
                                    style: TextStyle(
                                        color: Color.fromARGB(141, 0, 0, 0),
                                        fontWeight: FontWeight.bold,
                                        fontSize: widget.step == 1
                                            ? screenWidth * 0.03
                                            : screenWidth * 0.035))
                            ],
                          )
                        ],
                      ),
                      Expanded(
                          child: SizedBox(
                        width: screenWidth * 0.1,
                      )),
                      Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.3),
                        child: Text(
                          widget.step == 0
                              ? "Daily\nChallenge"
                              : widget.step == 1
                                  ? widget.challenge!.description ?? ""
                                  : widget.step == 2
                                      ? "Daily Challenge\nCompleted"
                                      : "",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.035),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            child: widget.child,
          )
        ]),
      ),
    );
  }
}
