import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/help/enum.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/share/button.dart';
import 'package:myrefectly/views/other/image_picker.dart';
import 'package:myrefectly/views/share_component/custom_loading.dart';
import 'package:myrefectly/views/share_reflection/reflectionshare_viewmodel.dart';
import 'package:myrefectly/views/share_component/exit_button.dart';
import 'package:myrefectly/views/share_reflection/input.dart';
import 'package:provider/provider.dart';

class Reflection_Share_Page extends StatefulWidget {
  final Reflection reflection;
  Reflection_Share_Page({required this.reflection});
  @override
  State<StatefulWidget> createState() => Reflection_Share_Page_State();
}

class Reflection_Share_Page_State extends State<Reflection_Share_Page>
    with SingleTickerProviderStateMixin {
  bool flag = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return ChangeNotifierProvider<ReflectionShare_Viewmodel>(
        create: (context) =>
            ReflectionShare_Viewmodel(reflection: widget.reflection),
        child: Consumer<ReflectionShare_Viewmodel>(
            builder: (context, view_model, child) {
          if (view_model.actionStatus == ActionStatus.success) {
            Future.delayed(
              Duration(milliseconds: 500),
              () {
                if (Navigator.canPop(context)) Navigator.pop(context);
              },
            );
          }
          _controller.text = view_model.reflection.description;
          // controller.text = view_model.content.substring(0, view_model.index) +
          //     "            " +
          //     view_model.content
          //         .substring(view_model.index, view_model.content.length);
          if (view_model.loading) return Container();
          return Scaffold(
            backgroundColor: is_darkmode ? background_dark : background_light,
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
                          initialText: view_model.reflection.description,
                          reflection: "",
                          fontsize: screenWidth * 0.04,
                          onReflectionChanged: (newReflection) {
                            view_model.ref = newReflection;
                          },
                        ),
                      ),
                      SizedBox(
                        height: screenWidth * 0.05,
                      ),
                      PhotoPicker(
                        image_list: view_model.image_list,
                        dark: !is_darkmode,
                        onImageListChanged: (p0) {},
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.06),

                          // child: Stack(children: [
                          //   RichText(
                          //     text: TextSpan(
                          //       text: _prefix,
                          //       style: TextStyle(
                          //           color: Colors.black,
                          //           fontFamily: "Google",
                          //           fontSize: screenWidth * 0.04),
                          //       children: <TextSpan>[
                          //         TextSpan(
                          //             text: _reflection,
                          //             style: TextStyle(
                          //                 fontWeight: FontWeight.bold)),
                          //         TextSpan(text: _suffix),
                          //       ],
                          //     ),
                          //   ),
                          //   TextField(
                          //     controller: _controller,
                          //     onChanged: (value) {
                          //       setState(() {
                          //         _reflection = value.substring(_prefix.length,
                          //             value.length - _suffix.length);
                          //       });
                          //     },
                          //     decoration: InputDecoration(
                          //       isDense: true,
                          //       border:
                          //           InputBorder.none, // Bỏ đường line phía dưới
                          //     ),
                          //     style: TextStyle(color: Colors.transparent),
                          //   )
                          // ]),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: CustomElement(
                          onTap: () {
                            view_model.Complete_share();
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
                                "SAVE REFLECTION",
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
                          reflection[DateTime.now().weekday]!,
                          style: TextStyle(
                              color: is_darkmode ? Colors.white : Colors.black,
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${weekday[DateTime.now().weekday]!.toUpperCase()}, ${fullMonth[DateTime.now().month]!.toUpperCase()} ${DateTime.now().day}",
                          style: TextStyle(
                              color: is_darkmode
                                  ? Colors.white.withOpacity(0.4)
                                  : Colors.black.withOpacity(0.4),
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
          );
        }));
  }
}
