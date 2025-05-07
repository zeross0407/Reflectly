import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myrefectly/share/button.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/share/custominp.dart';
import 'package:myrefectly/views/entries/entries_viewmodel.dart';
import 'package:myrefectly/views/share_component/exit_button.dart';
import 'package:myrefectly/views/share_component/reflectly_face.dart';
import 'package:myrefectly/views/share_component/text.dart';
import 'package:myrefectly/views/voice_note/voice_note_viewmodel.dart';
import 'package:provider/provider.dart';

class VoicePage extends StatefulWidget {
  const VoicePage({super.key});

  @override
  State<StatefulWidget> createState() => VoicePageState();
}

class VoicePageState extends State<VoicePage> {
  //bool is_speeching = false;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    double paddingWidth = screenWidth * 0.07;

    return ChangeNotifierProvider<VoiceNote_Viewmodel>(
        create: (context) => VoiceNote_Viewmodel(),
        child: Consumer<VoiceNote_Viewmodel>(
            builder: (context, view_model, child) {
          return PopScope(
            onPopInvokedWithResult: (didPop, result) {
              controller.animateToPage(0,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.decelerate);
            },
            canPop: false,
            child: Scaffold(
                body: Stack(children: [
              Container(
                  width: screenWidth,
                  height: screenHeight,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: all_color[theme_selected],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                  child: PageView(
                    controller: controller,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Stack(children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(top: screenWidth * 0.1),
                            child: reflectly_face(),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ClipPath(
                            clipper: TopCurveClipper(),
                            child: Container(
                                width: screenWidth,
                                height:
                                    screenWidth * 0.125 + screenHeight * 0.145,
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(31, 255, 255, 255))),
                          ),
                        ),
                        if (!view_model.speechToText.isListening)
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: screenHeight * 0.23),
                              child: Text(
                                'Voice Note',
                                style: TextStyle(
                                    fontFamily: 'Second',
                                    color: const Color.fromARGB(16, 0, 0, 0),
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.11),
                              ),
                            ),
                          ),
                        Column(
                          children: [
                            ...[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: paddingWidth,
                                    vertical: screenWidth * 0.2),
                                child: Stack(children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [exit_button(context, true)],
                                  ),
                                ]),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.1),
                                child: text_intro(
                                    text: "What's on your mind?",
                                    color: Colors.white,
                                    fontsize: screenWidth * 0.06),
                              ),
                              const Text(
                                "I'LL JOT IT DOWN FOR YOU",
                                style: TextStyle(
                                    fontFamily: "Second",
                                    color: Color.fromARGB(67, 0, 0, 0),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                            Expanded(child: Container()),
                            Column(
                              children: [
                                Stack(children: [
                                  Center(
                                    child: Container(
                                      width: screenWidth * 0.25,
                                      height: screenWidth * 0.25,
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              53, 255, 255, 255),
                                          borderRadius:
                                              BorderRadius.circular(10000)),
                                    ),
                                  ),
                                  Center(
                                    child: CustomElement(
                                      onTap: () {
                                        setState(() {
                                          if (!view_model.is_listening) {
                                            view_model.startListening();
                                          } else {
                                            view_model.stopListening();
                                            controller.animateToPage(1,
                                                duration:
                                                    Duration(milliseconds: 300),
                                                curve: Curves.decelerate);
                                          }
                                        });
                                      },
                                      child: Container(
                                        width: screenWidth * 0.25,
                                        height: screenWidth * 0.25,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10000),
                                        ),
                                        child: Center(
                                          child: AnimatedSwitcher(
                                            duration:
                                                Duration(milliseconds: 300),
                                            transitionBuilder: (Widget child,
                                                Animation<double> animation) {
                                              return RotationTransition(
                                                turns:
                                                    Tween(begin: 0.5, end: 1.0)
                                                        .animate(animation),
                                                child: FadeTransition(
                                                  opacity: animation,
                                                  child: child,
                                                ),
                                              );
                                            },
                                            child: SvgPicture.asset(
                                              !view_model.is_listening
                                                  ? "assets/img/activity.svg"
                                                  : "assets/ico/pause.svg",
                                              key: ValueKey<bool>(!view_model
                                                  .speechToText
                                                  .isListening), // Key để AnimatedSwitcher nhận diện sự thay đổi
                                              colorFilter: ColorFilter.mode(
                                                all_color[theme_selected][0],
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.05),
                                  child: CustomElement(
                                    onTap: () {
                                      if (!view_model.is_listening) {
                                        view_model.startListening();
                                      } else {
                                        controller.animateToPage(1,
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.decelerate);
                                      }

                                      if (view_model.lastWords.length > 0) {
                                        //view_model.stopListening();
                                        //view_model.speechToText.stop();
                                        // controller.animateToPage(1,
                                        //     duration:
                                        //         Duration(milliseconds: 300),
                                        //     curve: Curves.decelerate);
                                      } else {}
                                    },
                                    child: Text(
                                      view_model.is_listening
                                          ? "STOP"
                                          : "TAP TO START",
                                      style: TextStyle(
                                          fontFamily: "Second",
                                          color: Color.fromARGB(67, 0, 0, 0),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        if (view_model.speechEnabled)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.05),
                              child: Text(
                                view_model.lastWords,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.042,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                      ]),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04),
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenWidth * 0.5,
                            ),
                            Custom_Input(
                              fontsize: screenWidth * 0.04,
                              limit: 40,
                              viewing: false,
                              onChanged: (p0) {
                                view_model.title = p0;
                              },
                            ),
                            Custom_Input(
                              onChanged: (p0) {
                                setState(() {
                                  
                                });
                                view_model.lastWords = p0;
                              },
                              need_helper: false,
                              hint: "Add some notes\n\n\n\n\n",
                              text: view_model.lastWords,
                              limit: 500,
                              viewing: false,
                              fontsize: screenWidth * 0.03,
                            ),
                            Expanded(child: Container()),
                            CustomElement(
                              onTap: () async {
                                int rs = await view_model.save_voice_note();
                                if (rs == 1) {
                                  Navigator.pop(context);
                                  try {
                                    Provider.of<Entries_Viewmodel>(context,
                                            listen: false)
                                        .loadData();
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              },
                              child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: screenWidth * 0.05),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.2,
                                      vertical: screenWidth * 0.04),
                                  decoration: BoxDecoration(
                                      color: view_model.lastWords.length > 0
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.5),
                                      borderRadius:
                                          BorderRadius.circular(1000)),
                                  child: Text(
                                    "SAVE CHANGES",
                                    style: TextStyle(
                                        color: all_color[theme_selected][0],
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Second"),
                                  )),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ])),
          );
        }));
  }
}

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 40);

    path.quadraticBezierTo(size.width / 2, 0, size.width, 40);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
