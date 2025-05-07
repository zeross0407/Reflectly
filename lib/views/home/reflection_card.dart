import 'package:flutter/material.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/help/route.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/share/button.dart';
import 'package:myrefectly/theme/color.dart';
import 'package:myrefectly/views/home/home_viewmodel.dart';
import 'package:myrefectly/views/mood_checkin/checkin.dart';
import 'package:myrefectly/views/share_reflection/share_reflection.dart';

class Reflection_Card extends StatefulWidget {
  HomeViewmodel view_model;
  int index;
  List<DateTime> weekDays;
  Reflection_Card(
      {required this.view_model, required this.index, required this.weekDays});
  @override
  Reflection_Card_State createState() => Reflection_Card_State();
}

class Reflection_Card_State extends State<Reflection_Card> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return CustomElement(
        onTap: () {
          if (DateTime.now().weekday <= widget.index) return;
          if (widget.view_model.HomeData!.reflectionShared[widget.index]) {
            Navigator.push(context, Slide_up_Route(secondPage: Checkin()));
          } else {
            Navigator.push(
                context,
                Slide_up_Route(
                    secondPage: Reflection_Share_Page(
                        reflection: widget.view_model.HomeData!
                            .weeklyReflection[widget.index])));
          }
        },
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: screenWidth * 0.05),
              //height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: is_darkmode
                      ? card_dark
                      : const Color.fromARGB(255, 255, 255, 255),
                  boxShadow: my_shadow),
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  Text(
                    reflection[widget.index + 1] ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.04,
                        color: is_darkmode ? Colors.white : Colors.black),
                  ),
                  SizedBox(
                    height: screenHeight * 0.005,
                  ),
                  Text(
                    reflection_content[widget.index + 1] ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: screenWidth_Global * 0.03,
                        color: is_darkmode ? Colors.white : Colors.black),
                  ),
                  Container(
                    width: 10000,
                    margin: const EdgeInsets.all(15),
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenWidth * 0.05),
                    //height: 95,
                    //width: screenWidth * 0.8,
                    decoration: BoxDecoration(
                        color: is_darkmode
                            ? icon_dark
                            : const Color.fromARGB(77, 224, 224, 224),
                        borderRadius: BorderRadius.circular(15)),
                    child: DateTime.now().isAfter(widget.weekDays[widget.index])
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                if (widget.view_model.HomeData != null) ...[
                                  Text(
                                    widget.view_model.HomeData!
                                                    .reflectionShared[
                                                widget.index] ==
                                            false
                                        ? get_reflection_desc(widget
                                            .view_model
                                            .HomeData!
                                            .weeklyReflection[widget.index]
                                            .description)
                                        : "Have more to share ?",
                                    style: TextStyle(
                                        fontSize: screenWidth_Global * 0.035,
                                        color: is_darkmode
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w200),
                                  ),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                          widget.view_model.HomeData!
                                                          .reflectionShared[
                                                      widget.index] ==
                                                  false
                                              ? Icons.arrow_right_alt
                                              : Icons.add,
                                          color: all_color[theme_selected][0]))
                                ]
                              ])
                        : Center(
                            child: Text(
                              "This reflection unlocks in ${timeDifference(DateTime.now(), widget.view_model.weekDays[widget.index])}",
                              style: TextStyle(
                                  fontSize: screenWidth_Global * 0.035,
                                  color: is_darkmode
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                  )
                ],
              ),
            ),
            Container(
              height: screenWidth_Global * 0.13,
              width: screenWidth_Global * 0.13,
              padding: EdgeInsets.all(screenWidth * 0.01),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10000),
                  color: is_darkmode
                      ? Color.fromARGB(255, 60, 77, 104)
                      : Colors.white,
                  boxShadow: my_shadow),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1000),
                child: Stack(children: [
                  Image.asset(
                      "assets/completion_topic_avatars/(${widget.index + 1}).png"),
                  if (widget.view_model.HomeData != null &&
                      widget
                          .view_model.HomeData!.reflectionShared[widget.index])
                    Container(
                      color: all_color[theme_selected][0].withOpacity(0.5),
                      child: Center(
                          child: Icon(
                        Icons.check,
                        color: Colors.white,
                      )),
                    )
                ]),
              ),
            ),
          ],
        ));
  }
}
