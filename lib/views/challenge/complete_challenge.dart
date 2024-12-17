import 'package:flutter/material.dart';
import 'package:myrefectly/help/effect.dart';
import 'package:myrefectly/help/enum.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/share/button.dart';
import 'package:myrefectly/views/other/image_picker.dart';
import 'package:myrefectly/views/challenge/daily_challenge_viewmodel.dart';
import 'package:myrefectly/views/share_component/exit_button.dart';
import 'package:provider/provider.dart';

class Daily_Challange_Complete_Page extends StatefulWidget {
  Daily_Challange_Complete_Page();
  @override
  State<StatefulWidget> createState() => Daily_Challange_Complete_Page_State();
}

class Daily_Challange_Complete_Page_State
    extends State<Daily_Challange_Complete_Page>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Alignment> _alignmentAnimation;
  bool isCompleted = false;
  bool hasChangedImage = false; // Để đảm bảo ảnh chỉ chuyển một lần
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    // Sequence animation cho scale để có 3 giai đoạn:
    // Phóng to, thu nhỏ, và bung ra
    _scaleAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.8)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.8, end: 1.3)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 1.81)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 25,
      ),
    ]).animate(_controller);

    // Di chuyển từ dưới lên giữa trong nửa đầu hiệu ứng
    _alignmentAnimation = AlignmentTween(
      begin: Alignment.bottomCenter,
      end: Alignment.center,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation.addListener(() {
      if (_scaleAnimation.value > 1.8 && !hasChangedImage) {
        // Chuyển ảnh ngay khi kết thúc giai đoạn thu nhỏ
        setState(() {
          isCompleted = true;
          hasChangedImage = true; // Đảm bảo chỉ chuyển ảnh một lần
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return ChangeNotifierProvider<Daily_Challenge_Viewmodel>(
      create: (context) => Daily_Challenge_Viewmodel(),
      child: Consumer<Daily_Challenge_Viewmodel>(
          builder: (context, view_model, child) {
        if (view_model.actionStatus == ActionStatus.success) {
          // Bắt đầu hoạt ảnh
          _controller.forward().then(
            (value) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
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
                    if (view_model.week_home!
                            .challenge_completed[DateTime.now().weekday - 1] >=
                        1)
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Align(
                            alignment: _alignmentAnimation.value,
                            child: Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Image.asset(
                                isCompleted
                                    ? "assets/challenge_images/challenge_completed.png"
                                    : "assets/challenge_images/challenge_uncompleted.png",
                                height: screenWidth * 0.7,
                              ),
                            ),
                          );
                        },
                      ),
                    view_model.week_home!.challenge_completed[
                                    DateTime.now().weekday - 1] ==
                                1 &&
                            view_model.actionStatus != ActionStatus.success
                        ? Container(
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
                                                    .week_home!
                                                    .todayChallenge
                                                    ?.description ??
                                                "",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenWidth * 0.05,
                                ),
                                PhotoPicker(
                                  image_list: view_model.image_list,
                                  onImageListChanged: (p0) {},
                                  dark: false,
                                ),
                                Expanded(child: Container()),
                                CustomElement(
                                  onTap: () async {
                                    view_model.CompleteChallenge();
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
                                        "COMPLETE CHALLENGE",
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
                          )
                        : Container(),
                    if (view_model.actionStatus != ActionStatus.success)
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: screenWidth * 0.125),
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
                    if (view_model.actionStatus != ActionStatus.success)
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                            padding: EdgeInsets.only(
                                top: screenWidth * 0.135,
                                right: screenWidth * 0.05),
                            child: exit_button(context, true)),
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
