import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/help/effect.dart';
import 'package:myrefectly/help/enum.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/share/button.dart';
import 'package:myrefectly/views/challenge/edit_daily_challenge.dart';
import 'package:myrefectly/views/other/image_picker.dart';
import 'package:myrefectly/views/share_reflection/edit_reflection_viewmodel.dart';
import 'package:myrefectly/views/share_component/exit_button.dart';
import 'package:myrefectly/views/share_reflection/input.dart';
import 'package:provider/provider.dart';
import 'package:rtf_textfield/rtf_textfield.dart';

class Edit_Reflection_Page extends StatefulWidget {
  String UUID;
  Edit_Reflection_Page({required this.UUID});
  @override
  State<StatefulWidget> createState() => Edit_Reflection_Page_State();
}

class Edit_Reflection_Page_State extends State<Edit_Reflection_Page>
    with SingleTickerProviderStateMixin {
  bool flag = false;
  final TextEditingController _controller = TextEditingController();
  String _prefix = "This is the ";
  String _suffix = " now im remember this";
  String _reflection = "";
  RTFTextFieldController controller = RTFTextFieldController();
  @override
  void initState() {
    super.initState();
    _controller.text = _prefix + " " + _reflection + " " + _suffix;
    //controller.toggleBold();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      controller.toggleBold();
      controller.changeFontSize(25);
    });
  }

  void _onTextChanged(String value) {
    int index = _controller.selection.baseOffset;
    if (index < _prefix.length || index > _prefix.length + _reflection.length) {
      _controller.text = _prefix + " " + _reflection + " " + _suffix;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: index - 1),
      );
    }
  }

  String share = "";

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return ChangeNotifierProvider<Edit_Reflection_ViewModel>(
        create: (context) => Edit_Reflection_ViewModel(UUID: widget.UUID),
        child: Consumer<Edit_Reflection_ViewModel>(
            builder: (context, view_model, child) {
          if (view_model.actionStatus == ActionStatus.success) {
            Future.delayed(
              Duration(milliseconds: 500),
              () {
                if (Navigator.canPop(context)) Navigator.pop(context);
              },
            );
          }
          if (view_model.loading) return Container();

          _controller.text = view_model.user_reflection.reflection;
          // controller.text = view_model.content.substring(0, view_model.index) +
          //     "            " +
          //     view_model.content
          //         .substring(view_model.index, view_model.content.length);
          return Scaffold(
            backgroundColor: background_light,
            body: Container(
              width: screenWidth,
              height: screenHeight,
              child: Stack(children: [
                Padding(
                  padding: EdgeInsets.only(top: screenWidth * 0.35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.06),
                        child: CustomTextEditor(
                          initialText: view_model.user_reflection.reflection,
                          reflection: RegExp(r'#([^#]+)#')
                              .firstMatch(
                                  view_model.user_reflection.reflection)!
                              .group(1)!,
                          fontsize: screenWidth * 0.04,
                          onReflectionChanged: (newReflection) {
                            view_model.ref = newReflection;
                          },
                        ),
                      ),
                      SizedBox(
                        height: screenWidth * 0.05,
                      ),
                      if (view_model.img_loaded)
                        PhotoPicker(
                          image_list: view_model.image_list,
                          dark: true,
                          onImageListChanged: (p0) {
                            setState(() {
                              view_model.image_list = p0;
                            });
                          },
                        ),
                      if (!view_model.img_loaded)
                        Container(
                          margin: EdgeInsets.only(top: screenWidth * 0.1),
                          alignment: Alignment.center,
                          child: LoadingCircles(
                            color: all_color[theme_selected][0],
                          ),
                        ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.06),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: CustomElement(
                          onTap: () {
                            view_model.Save_Changes();
                          },
                          child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: screenWidth * 0.05),
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.15,
                                  vertical: screenWidth * 0.04),
                              decoration: BoxDecoration(
                                  color: all_color[theme_selected][0],
                                  borderRadius: BorderRadius.circular(1000)),
                              child: Text(
                                "SAVE CHANGES",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Second"),
                              )),
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: screenWidth * 0.125),
                    child: Column(
                      children: [
                        Text(
                          reflection[
                              view_model.user_reflection.submitTime.weekday]!,
                          style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${weekday[view_model.user_reflection.submitTime.weekday]!.toUpperCase()}, ${fullMonth[view_model.user_reflection.submitTime.month]!.toUpperCase()} ${view_model.user_reflection.submitTime.day}",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.4),
                              fontSize: screenWidth * 0.03,
                              fontFamily: "Second",
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                      padding: EdgeInsets.only(
                          top: screenWidth * 0.125, right: screenWidth * 0.05),
                      child: exit_button(context, is_darkmode)),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: screenWidth * 0.05,
                                  ),
                                  loading_icon_cycle(view_model.actionStatus),
                                  SizedBox(
                                    height: screenWidth * 0.05,
                                  ),
                                  Text(
                                    loading_text_cycle(view_model.actionStatus),
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
                                        ActionStatus.failure;
                                  });
                                },
                                child: Icon(
                                  Icons.close,
                                  color:
                                      is_darkmode ? Colors.white : Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
              ]),
            ),
          );
        }));
  }
}
