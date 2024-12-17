import 'package:flutter/material.dart';
import 'package:myrefectly/help/effect.dart';
import 'package:myrefectly/help/enum.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/share/button.dart';
import 'package:myrefectly/views/challenge/edit_daily_challenge_viewmodel.dart';
import 'package:myrefectly/views/other/image_picker.dart';
import 'package:myrefectly/views/share_component/exit_button.dart';
import 'package:provider/provider.dart';

class Daily_Challange_Update_Page extends StatefulWidget {
  final String id;
  Daily_Challange_Update_Page({required this.id});
  @override
  State<StatefulWidget> createState() => Daily_Challange_Update_Page_State();
}

class Daily_Challange_Update_Page_State
    extends State<Daily_Challange_Update_Page>
    with SingleTickerProviderStateMixin {
  bool isCompleted = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return ChangeNotifierProvider<Edit_Daily_Challenge_Viewmodel>(
      create: (context) => Edit_Daily_Challenge_Viewmodel(ID: widget.id),
      child: Consumer<Edit_Daily_Challenge_Viewmodel>(
          builder: (context, view_model, child) {
        if (view_model.actionStatus == ActionStatus.success) {
          Future.delayed(
            Duration(milliseconds: 1000),
            () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
          );
        }

        return Scaffold(
          body: view_model.is_loading == false
              ? Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: all_color[theme_selected]),
                  ),
                  child: Stack(children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        "assets/challenge_images/challenge_completed.png",
                        height: screenWidth * 0.7,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: screenHeight * 0.15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05),
                            child: RichText(
                              text: TextSpan(
                                text: 'Today I will ',
                                style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    fontFamily: "Google"),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: view_model
                                          .dailyChallenge_Complete.description,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenWidth * 0.05,
                          ),
                          if (view_model.img_loaded)
                            PhotoPicker(
                              image_list: view_model.image_list,
                              dark: false,
                              onImageListChanged: (p0) {
                                setState(() {
                                  view_model.has_changed = true;
                                  view_model.image_list = p0;
                                });
                              },
                            ),
                          if (!view_model.has_changed &&
                              view_model.image_list.length == 0)
                            Container(
                              margin: EdgeInsets.only(top: screenWidth * 0.1),
                              alignment: Alignment.center,
                              child: LoadingCircles(
                                color: Colors.white,
                              ),
                            ),
                          Expanded(child: Container()),
                          if (view_model.has_changed)
                            CustomElement(
                              onTap: () async {
                                if (view_model.image_list.length > 0)
                                  view_model.savechange();
                                else
                                  view_model.AddImage();
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.15,
                                    vertical: screenWidth * 0.05),
                                padding: EdgeInsets.symmetric(
                                    vertical: screenWidth * 0.05),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(1000)),
                                child: Center(
                                  child: Text(
                                    view_model.image_list.length > 0
                                        ? "SAVE CHANGES"
                                        : "ADD PHOTO",
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
                    ),
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
                              top: screenWidth * 0.1,
                              right: screenWidth * 0.05),
                          child: exit_button(context, true)),
                    ),
                    if (view_model.actionStatus == ActionStatus.running ||
                        view_model.actionStatus == ActionStatus.success)
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
                                      loading_icon_cycle(
                                          view_model.actionStatus),
                                      SizedBox(
                                        height: screenWidth * 0.05,
                                      ),
                                      Text(
                                        loading_text_cycle(
                                            view_model.actionStatus),
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
                                        view_model.actionStatus =
                                            ActionStatus.waiting;
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

String loading_text_cycle(ActionStatus state) => (state == ActionStatus.running
    ? "UPLOADING ..."
    : state == ActionStatus.success
        ? " SUCCESS"
        : "FAILED");
Widget loading_icon_cycle(ActionStatus state) => (state == ActionStatus.running
    ? RotatingSvgIcon()
    : state == ActionStatus.failure
        ? Icon(
            Icons.error_outline,
            color: is_darkmode ? Colors.white : Colors.black,
          )
        : Icon(
            Icons.check,
            color: is_darkmode ? Colors.white : Colors.black,
          ));
