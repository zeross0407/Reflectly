import 'dart:io';
import 'package:myrefectly/help/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myrefectly/help/effect.dart';
import 'package:myrefectly/help/enum.dart';
import 'package:myrefectly/help/image_viewer.dart';
import 'package:myrefectly/help/route.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/views/archive/archive.dart';
import 'package:myrefectly/share/button.dart';
import 'package:myrefectly/share/custominp.dart';
import 'package:myrefectly/theme/color.dart';
import 'package:myrefectly/views/navigation/navigation_viewmodel.dart';
import 'package:myrefectly/views/login/login.dart';
import 'package:myrefectly/views/other/notification.dart';
import 'package:myrefectly/views/share_component/custom_loading.dart';
import 'package:myrefectly/views/share_component/text.dart';
import 'package:myrefectly/views/user/checkin_reminder.dart';
import 'package:myrefectly/views/user/positivity_reminder.dart';
import 'package:myrefectly/views/user/theme_selector.dart';
import 'package:myrefectly/views/user/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<StatefulWidget> createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Chọn ảnh từ thư viện
  Future<void> _pickImageFromGallery(User_Viewmodel view_model) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        view_model.update_avatar(_image!);
      } else {
        print('No image selected.');
      }
    });
  }

  bool change_setting = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return Consumer<Navigation_viewmodel>(builder: (context, notifier, child) {
      return ChangeNotifierProvider<User_Viewmodel>(
          create: (context) => User_Viewmodel(),
          child:
              Consumer<User_Viewmodel>(builder: (context, view_model, child) {
            if (view_model.loading == false)
              return Scaffold(
                body: Stack(
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: screenWidth,
                      height: screenHeight,
                      decoration: BoxDecoration(
                          color:
                              is_darkmode ? background_dark : background_light),
                      child: Stack(alignment: Alignment.topRight, children: [
                        Positioned(
                            top: -screenWidth * 0.65,
                            right: -screenWidth * 0.65,
                            child: SvgPicture.asset(
                              "assets/ico/circle.svg",
                              width: screenWidth * 1.5,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.01),
                                  BlendMode.srcIn),
                            )),
                      ]),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Stack(children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                //crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: screenHeight * 0.04,
                                          horizontal: screenWidth * 58 / 949),
                                      child: GestureDetector(
                                        onTap: () {
                                          _pickImageFromGallery(view_model);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              boxShadow: my_shadow),
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Container(
                                                    height: screenWidth * 0.4,
                                                    width: screenWidth * 0.4,
                                                    decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                            colors: all_color[
                                                                theme_selected])),
                                                  )),
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: SizedBox(
                                                    height: screenWidth * 0.4,
                                                    width: screenWidth * 0.4,
                                                    child: (_image == null)
                                                        ? ImageFromApi(
                                                            need_loading_effect:
                                                                false,
                                                          )
                                                        : Image.file(
                                                            _image!,
                                                            fit: BoxFit.cover,
                                                          )),
                                              ),
                                              Positioned.fill(
                                                child: Align(
                                                    alignment: Alignment.center,
                                                    child: !view_model.updating
                                                        ? SvgPicture.asset(
                                                            "assets/ico/camera.svg",
                                                            height:
                                                                screenWidth *
                                                                    0.2,
                                                            colorFilter:
                                                                const ColorFilter
                                                                    .mode(
                                                                    Color.fromARGB(
                                                                        76,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                    BlendMode
                                                                        .srcIn),
                                                          )
                                                        : RotatingSvgIcon()),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                margin: EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: screenWidth * 58 / 949),
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.025,
                                    vertical: 20),
                                decoration: BoxDecoration(
                                    color:
                                        is_darkmode ? card_dark : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: my_shadow),
                                child: Column(children: [
                                  Custom_Input(
                                    onChanged: (p0) {
                                      view_model.username = p0;
                                      setState(() {
                                        change_setting = true;
                                      });
                                    },
                                    fontsize: screenWidth * 0.045,
                                    limit: 40,
                                    text: "${view_model.user.user_name}",
                                    text_color: is_darkmode
                                        ? Colors.white
                                        : Colors.black,
                                    viewing: false,
                                  ),
                                  Custom_Input(
                                    enable: false,
                                    //icon: 'assets/ico/refresh.svg',
                                    fontsize: screenWidth * 0.045,
                                    limit: 40,
                                    hint: view_model.user.email,
                                    hint_color: const Color.fromARGB(
                                        255, 188, 188, 188),
                                    viewing: false,
                                  )
                                ]),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 58 / 949),
                                child: Card_Option(
                                    '',
                                    'assets/ico/fingerprint.svg',
                                    'BIOMETRIC PASSCODE',
                                    view_model.user.passcode
                                        ? "Enabled"
                                        : 'Disabled',
                                    view_model.user.passcode, (newValue) async {
                                  bool accept =
                                      await view_model.register_fingerprint();
                                  print(accept);
                                  setState(() {
                                    view_model.user.passcode = accept;
                                  });
                                  if (accept) {
                                    show_notification(
                                        context,
                                        "Registered Passcode",
                                        Colors.green[300]!);
                                  }
                                }, screenWidth * 0.045),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 58 / 949),
                                child: Card_Option(
                                    '',
                                    'assets/ico/moon.svg',
                                    'DARK MODE',
                                    view_model.user.darkmode
                                        ? "Enabled"
                                        : 'Disabled',
                                    view_model.user.darkmode, (newValue) {
                                  view_model.user.darkmode = newValue;
                                  view_model.user.save();

                                  setState(() {
                                    is_darkmode = newValue;
                                  });
                                }, screenWidth * 0.045),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 58 / 949),
                                child: CardReminder(
                                    timeReminder: getIndexFromDateTime(
                                        view_model.user.time_checkin_reminder),
                                    onTimeReminderChange: (value) {
                                      setState(() {
                                        change_setting = true;
                                        view_model.user.time_checkin_reminder =
                                            getDateTimeFromDouble(value);
                                      });
                                    },
                                    iconToggle: '',
                                    iconBackground: 'assets/ico/ring.svg',
                                    title: 'CHECK-IN REMINDER',
                                    status: view_model.user.checkin_reminder
                                        ? "Enabled"
                                        : 'Disabled',
                                    val: view_model.user.checkin_reminder,
                                    onChanged: (newValue) {
                                      setState(() {
                                        view_model.user.checkin_reminder =
                                            newValue;
                                        view_model.user.save();
                                        view_model.setupDailyNotification();
                                      });
                                    },
                                    fontSize: screenWidth * 0.045),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 58 / 949),
                                child: CardPosiReminder(
                                  time_start:
                                      view_model.user.start_positivity_reminder,
                                  time_end:
                                      view_model.user.end_positivity_reminder,
                                  countReminder:
                                      view_model.user.count_positivity_reminder,
                                  countReminderChanged: (val) {
                                    view_model.user.count_positivity_reminder =
                                        val;
                                    setState(() {
                                      change_setting = true;
                                    });
                                  },
                                  timeReminder:
                                      view_model.user.time_checkin_reminder,
                                  iconToggle: '',
                                  iconBackground: 'assets/ico/ring.svg',
                                  title: 'POSITIVITY REMINDERS',
                                  status: view_model.user.possitive_reminder
                                      ? "Enabled"
                                      : 'Disabled',
                                  val: view_model.user.possitive_reminder,
                                  onChanged: (newValue) {
                                    setState(() {
                                      view_model.user.possitive_reminder =
                                          newValue;
                                      view_model.user.save();
                                      if (newValue) {
                                        view_model
                                            .scheduleMultipleNotificationsDaily();
                                      }
                                    });
                                  },
                                  fontSize: screenWidth * 0.045,
                                  on_time_change: (DateTime st, DateTime end) {
                                    setState(() {
                                      change_setting = true;
                                    });
                                    view_model.user.start_positivity_reminder =
                                        st;
                                    view_model.user.end_positivity_reminder =
                                        end;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await Navigator.of(context).push(
                                      Slide_up_Route(
                                          secondPage:
                                              Archive_Page<Activity>()));
                                  view_model.refresh_UI();
                                },
                                child: Stack(
                                  children: [
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 58 / 949,
                                          vertical: 10),
                                      decoration: BoxDecoration(
                                          color: is_darkmode
                                              ? Color.fromARGB(255, 41, 66, 97)
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: my_shadow),
                                      width: 100000,
                                      height: screenWidth * 0.3,
                                      child: Stack(children: [
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: screenWidth * 0.04,
                                                left: screenWidth * 0.04),
                                            child: Text(
                                              "YOUR ACTIVITIES",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: screenWidth * 0.03,
                                                  color:
                                                      all_color[theme_selected]
                                                          [0]),
                                            ),
                                          ),
                                        ),
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: SvgPicture.asset(
                                              "assets/ico/menu.svg",
                                              height: screenWidth * 0.25,
                                              colorFilter: ColorFilter.mode(
                                                  Colors.black
                                                      .withOpacity(0.02),
                                                  BlendMode.srcIn),
                                            ))
                                      ]),
                                    ),
                                    Container(
                                      width: 100000,
                                      height: 100,
                                      child: SingleChildScrollView(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.11),
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: List.generate(
                                            view_model.all_activity.length,
                                            (index) {
                                              return icon_card(
                                                  context,
                                                  view_model
                                                      .all_activity[index].icon,
                                                  view_model.all_activity[index]
                                                      .title);
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(Slide_up_Route(
                                      secondPage: Archive_Page<Feeling>()));
                                },
                                child: Stack(
                                  children: [
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 58 / 949,
                                          vertical: 10),
                                      decoration: BoxDecoration(
                                          color: is_darkmode
                                              ? Color.fromARGB(255, 41, 66, 97)
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: my_shadow),
                                      width: 100000,
                                      height: screenWidth * 0.3,
                                      child: Stack(children: [
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: screenWidth * 0.04,
                                                left: screenWidth * 0.04),
                                            child: Text(
                                              "YOUR FEELINGS",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: screenWidth * 0.03,
                                                  color:
                                                      all_color[theme_selected]
                                                          [0]),
                                            ),
                                          ),
                                        ),
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: SvgPicture.asset(
                                              "assets/ico/menu.svg",
                                              height: screenWidth * 0.25,
                                              colorFilter: ColorFilter.mode(
                                                  Colors.black
                                                      .withOpacity(0.02),
                                                  BlendMode.srcIn),
                                            ))
                                      ]),
                                    ),
                                    Container(
                                      width: 100000,
                                      height: 100,
                                      child: SingleChildScrollView(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.11),
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: List.generate(
                                            view_model.all_feeling.length,
                                            (index) {
                                              return icon_card(
                                                  context,
                                                  view_model
                                                      .all_feeling[index].icon,
                                                  view_model.all_feeling[index]
                                                      .title);
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: screenWidth * 58 / 949),
                                height: screenWidth * 0.55,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                child: ColorSelectorScreen_Setting(
                                  view_model: view_model,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: CustomElement(
                                  onTap: () async {
                                    await view_model.sign_out(context);
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    padding: EdgeInsets.symmetric(
                                        vertical: screenWidth * 0.05),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: all_color[theme_selected]),
                                        borderRadius:
                                            BorderRadius.circular(10000),
                                        boxShadow: my_shadow),
                                    child: Center(
                                      child: Text(
                                        "SIGN OUT",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Second",
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenWidth * 0.0325),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.04),
                                child: CustomElement(
                                  onTap: () async {
                                    int rs =
                                        await view_model.request_export_entry();
                                    if (rs == 1) {
                                      showNotification(
                                          context,
                                          "Your request was sent, Your journey will be ready soon",
                                          Colors.green[400]);
                                    }
                                  },
                                  child: Text(
                                    "EXPORT DATA",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Second",
                                        color:
                                            Color.fromARGB(255, 175, 175, 175),
                                        fontSize: screenWidth * 0.0325),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0),
                                child: CustomElement(
                                  onTap: () {
                                    _showAlert(context, view_model);
                                  },
                                  child: Text(
                                    "DELETE ACCOUNT",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Second",
                                        color:
                                            Color.fromARGB(255, 175, 175, 175),
                                        fontSize: screenWidth * 0.0325),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.04),
                                child: Text(
                                  "version B 0.0.1 ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Second",
                                      color: Color.fromARGB(255, 175, 175, 175),
                                      fontSize: screenWidth * 0.0325),
                                ),
                              ),
                              const SizedBox(height: 40)
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: screenHeight * 0.055,
                                right: screenWidth * 58 / 949),
                            child: CustomElement(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                height: screenWidth * 126 / 1028,
                                width: screenWidth * 126 / 1028,
                                padding: EdgeInsets.all(screenWidth * 0.03),
                                decoration: BoxDecoration(
                                    color: is_darkmode
                                        ? card_dark
                                        : const Color.fromARGB(
                                            255, 255, 255, 255),
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 0.045),
                                    boxShadow: my_shadow),
                                child: SvgPicture.asset(
                                  "assets/ico/x.svg",
                                  colorFilter: ColorFilter.mode(
                                      is_darkmode ? Colors.white : Colors.black,
                                      BlendMode.srcIn),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (view_model.actionStatus == ActionStatus.running ||
                            view_model.actionStatus == ActionStatus.success)
                          CustomLoadingDialog(
                            actionStatus: view_model.actionStatus,
                            onClose: () {
                              setState(() {
                                view_model.actionStatus = ActionStatus.failure;
                              });
                            },
                          )
                      ]),
                    ),
                    AnimatedPositioned(
                      bottom: change_setting ? 0 : -screenWidth,
                      duration: Duration(milliseconds: 1000),
                      child: GestureDetector(
                        onTap: () async {
                          await view_model.update_name();
                          await view_model.user.save();
                          view_model.setupDailyNotification();
                          view_model.scheduleMultipleNotificationsDaily();
                          setState(() {
                            change_setting = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: all_color[theme_selected])),
                          width: screenWidth,
                          height: screenWidth * 0.15,
                          child: Center(
                            child: Text(
                              "SAVE",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            else
              return Container();
          }));
    });
  }

  void _showAlert(BuildContext context, User_Viewmodel view_model) {
    showGeneralDialog(
      barrierLabel: '',
      context: context,
      barrierDismissible: true,
      pageBuilder: (context, animation1, animation2) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "ARE YOU SURE?",
            style: TextStyle(
                fontFamily: "Google",
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth_Global * 0.04),
            textAlign: TextAlign.center,
          ),
          content: Text(
            "Your account will be permanently deleted after 7 days. \n If you change your mind, you can log in again to cancel the request.",
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Google"),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            Icon(Icons.close),
            SizedBox(
              width: screenWidth_Global * 0.1,
            ),
            GestureDetector(
                onTap: () async {
                  view_model.request_delete_account();
                  Navigator.pop(context);
                },
                child: Icon(Icons.check)),
          ],
        );
      },
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, animation1, animation2, child) {
        final curvedValue = Curves.easeInOut.transform(animation1.value) - 1.2;
        return Transform.translate(
          offset: Offset(0, -curvedValue * 100),
          child: Opacity(
            opacity: animation1.value,
            child: child,
          ),
        );
      },
    );
  }

  Widget icon_card(BuildContext context, int icon, String title) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Container(
      width: screenWidth * 0.275,
      margin: EdgeInsets.only(
          right: screenWidth * 0.02, bottom: screenWidth * 0.06),
      //padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      decoration: BoxDecoration(
          color: Color.lerp(
              all_color[theme_selected][0],
              is_darkmode ? Color.fromARGB(255, 41, 66, 97) : Colors.white,
              0.95)!,
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
          boxShadow: my_shadow),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            width: screenWidth * 0.05,
            height: screenWidth * 0.05,
            icon_url(icon),
            colorFilter:
                ColorFilter.mode(all_color[theme_selected][0], BlendMode.srcIn),
          ),
          SizedBox(
            height: screenWidth * 0.015,
          ),
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.025,
                color: all_color[theme_selected][0]),
          )
        ],
      ),
    );
  }

  Widget Card_Option(String iconToggle, String iconBackground, String title,
      String status, bool val, ValueChanged<bool> onChanged, double fontSize) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: BoxDecoration(
          color: is_darkmode ? card_dark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: my_shadow),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fontSize, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text_intro(
                    text: status,
                    color: is_darkmode ? Colors.white : Colors.black,
                    fontsize: fontSize),
                SizedBox(
                  height: fontSize * 0.1,
                ),
                text_intro(
                  text: title,
                  color: const Color.fromARGB(255, 154, 154, 154),
                  fontsize: fontSize * 0.75,
                ),
              ],
            ),
          ),
          Expanded(child: Container()),
          Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                iconBackground,
                height: 100,
                colorFilter: const ColorFilter.mode(
                    Color.fromARGB(19, 193, 193, 193), BlendMode.srcIn),
              ),
              Center(
                child: Switch(
                    trackColor: WidgetStatePropertyAll<Color?>(
                        all_color[theme_selected][0]),
                    thumbColor:
                        const WidgetStatePropertyAll<Color?>(Colors.white),
                    value: val,
                    onChanged: onChanged),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String formatTime(DateTime dateTime) {
  int hour = dateTime.hour;
  int minute = dateTime.minute;

  String period = hour >= 12 ? "PM" : "AM";
  hour = hour % 12;
  hour = hour == 0 ? 12 : hour; // Chuyển giờ 0 thành 12 cho định dạng 12 giờ

  String minuteStr = minute.toString().padLeft(2, '0');
  return "$hour:$minuteStr $period";
}

DateTime getDateTimeFromDouble(double index) {
  // Giờ bắt đầu là 16:00
  DateTime baseTime = DateTime(0, 1, 1, 16, 0);

  // Mỗi `index` tăng 5 phút, vì vậy ta nhân với 5 để tính số phút cần cộng thêm
  int minutesToAdd = (index * 5).toInt();

  // Cộng số phút vào thời gian bắt đầu
  return baseTime.add(Duration(minutes: minutesToAdd));
}

double getIndexFromDateTime(DateTime dateTime) {
  // Giờ bắt đầu là 16:00 ngày 1 tháng 1 năm 0000
  DateTime baseTime = DateTime(0, 1, 1, 16, 0);

  // Tính khoảng cách thời gian từ `baseTime` đến `dateTime`
  int minutesDifference = dateTime.difference(baseTime).inMinutes;

  // Chia cho 5 để lấy `index`, vì mỗi đơn vị cách nhau 5 phút
  return minutesDifference / 5;
}
