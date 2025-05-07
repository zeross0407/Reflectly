import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/share/button.dart';
import 'package:myrefectly/share/custominp.dart';
import 'package:myrefectly/views/login/login.dart';
import 'package:myrefectly/views/mood_checkin/datetime_picker.dart';
import 'package:myrefectly/views/share_component/exit_button.dart';
import 'package:myrefectly/views/voice_note/edit_voice_note_viewmodel.dart';
import 'package:provider/provider.dart';

class Edit_VoiceNote extends StatefulWidget {
  late String model_id;
  Edit_VoiceNote(String model_id) {
    this.model_id = model_id;
  }
  @override
  State<StatefulWidget> createState() => Edit_Mood_Checkin_State();
}

class Edit_Mood_Checkin_State extends State<Edit_VoiceNote> {
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

    return ChangeNotifierProvider<Edit_VoiceNote_Viewmodel>(
      create: (context) => Edit_VoiceNote_Viewmodel(widget.model_id),
      child: Consumer<Edit_VoiceNote_Viewmodel>(
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
                                                "${get_full_time_string(view_model.voicenote_temp.submitTime)}",
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
                                    ? screenHeight * 0.2
                                    : screenHeight * 0.125,
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
                                        text: view_model.voicenote_temp.title,
                                        onChanged: (value) {
                                          view_model.voicenote_temp.title =
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
                                            .voicenote_temp.description,
                                        onChanged: (value) {
                                          view_model.voicenote_temp
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
                      time_picked: view_model.voicenote_temp.submitTime,
                      onTimeChanged: (newTime) {
                        setState(() {
                          view_model.voicenote_temp.submitTime = newTime;
                        });
                      },
                    ),
                  ]),
              ],
            ));
      }),
    );
  }
}
