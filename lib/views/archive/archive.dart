import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/views/archive/archive_viewmodel.dart';
import 'package:myrefectly/views/share_component/exit_button.dart';
import 'package:provider/provider.dart';

class Archive_Page<T> extends StatefulWidget {
  const Archive_Page({super.key});

  @override
  State<StatefulWidget> createState() => Archive_Page_State<T>();
}

class Archive_Page_State<T> extends State<Archive_Page>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  Timer? _timer;
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _startImageSwitcher();
    _controller = TabController(length: 2, vsync: this)
      ..addListener(
        () {
          setState(() {});
        },
      );
  }

  void _startImageSwitcher() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % 13;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose(); // Dispose TabController
    super.dispose();
  }

  // Hàm mở AlertDialog với hiệu ứng
  void _showAlert(
      BuildContext context, Archive_Viewmodel view_model, String id) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    showGeneralDialog(
      context: context,
      barrierDismissible: true, // Đóng khi chạm ra ngoài hộp thoại
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Archive ?",
            style: TextStyle(
                fontFamily: "Google",
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.04),
            textAlign: TextAlign.center,
          ),
          content: Text(
            "An archived activity becomes hidden when doing a new mood check-in. However, it is still visible on previous check-ins as well as your statistics.\n\nYou can restore it again at any time.",
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Google"),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            Icon(Icons.close),
            SizedBox(
              width: screenWidth * 0.1,
            ),
            GestureDetector(
                onTap: () async {
                  await view_model.toggle_archive_item(id);
                  Navigator.pop(context);
                },
                child: Icon(Icons.check)),
          ],
        );
      },
      transitionDuration: Duration(milliseconds: 300), // Thời gian hiệu ứng
      transitionBuilder: (context, animation1, animation2, child) {
        final curvedValue = Curves.easeInOut.transform(animation1.value) - 1.2;
        return Transform.translate(
          offset: Offset(0, -curvedValue * 100), // Trượt lên một chút
          child: Opacity(
            opacity: animation1.value, // Hiệu ứng hiện rõ dần
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return ChangeNotifierProvider<Archive_Viewmodel>(
        create: (context) => Archive_Viewmodel<T>(),
        child:
            Consumer<Archive_Viewmodel>(builder: (context, view_model, child) {
          return Scaffold(
            body: Stack(
              children: [
                Container(
                    height: screenHeight,
                    width: screenWidth,
                    color: is_darkmode ? background_dark : background_light),
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                            padding: EdgeInsets.only(
                                top: screenWidth * 0.15,
                                right: screenWidth * 0.07),
                            child: exit_button(context, is_darkmode)),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Center(
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Text(
                              _controller.index == 1 ? "Archived" : "Active",
                              style: TextStyle(
                                fontSize: screenWidth * 0.1,
                                fontFamily: "Second",
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.05),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: screenWidth * 0.1,
                                  horizontal: screenWidth * 0.25),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: is_darkmode
                                      ? card_dark
                                      : const Color.fromARGB(
                                          255, 226, 226, 226),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1000)),
                                ),
                                child: TabBar(
                                  controller: _controller,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  dividerColor: Colors.transparent,
                                  indicator: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: all_color[theme_selected]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(1000)),
                                  ),
                                  labelColor: Colors.white,
                                  unselectedLabelColor: is_darkmode
                                      ? Colors.white.withOpacity(0.5)
                                      : Colors.black54,
                                  tabs: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: screenWidth * 0.025),
                                      child: Text(
                                        "active",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * 0.03,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: screenWidth * 0.025),
                                      child: Text(
                                        "archived",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * 0.03,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: _controller.index == 0
                            ? 1000
                            : screenHeight *
                                1.25, // Adjust the height as needed
                        child: TabBarView(
                          controller: _controller,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenWidth * 0.02,
                                      horizontal: screenWidth * 0.1),
                                  child: Text(
                                    T == Activity ? "Activities" : "Feelings",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.1,
                                        fontFamily: "Second",
                                        color: Colors.black.withOpacity(0.05)),
                                  ),
                                ),
                                Expanded(
                                    child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.075),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 1,
                                  ),
                                  itemCount: view_model.icon_active.length,
                                  itemBuilder: (context, index) {
                                    return SizedBox.expand(
                                      child: Stack(
                                        children: [
                                          // Container chính với màu nền và bo góc
                                          Positioned.fill(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                right: screenWidth * 0.015,
                                                left: screenWidth * 0.015,
                                                bottom: screenWidth * 0.03,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Color.lerp(
                                                  all_color[theme_selected][0],
                                                  is_darkmode
                                                      ? Color.fromARGB(
                                                          255, 41, 66, 97)
                                                      : Colors.white,
                                                  0.925,
                                                )!,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        screenWidth * 0.05),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.05),
                                                    spreadRadius: 0.1,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 10),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    height: screenWidth * 0.05,
                                                    width: screenWidth * 0.05,
                                                    icon_url(view_model
                                                        .icon_active[index]
                                                        .icon),
                                                    colorFilter: ColorFilter.mode(
                                                        all_color[
                                                            theme_selected][0],
                                                        BlendMode.srcIn),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          screenWidth * 0.02),
                                                  Text(
                                                    view_model
                                                        .icon_active[index]
                                                        .title,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          screenWidth * 0.0225,
                                                      color: all_color[
                                                          theme_selected][0],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Icon ở góc phải trên

                                          Align(
                                            alignment: Alignment.topRight,
                                            child: GestureDetector(
                                              onTap: () {
                                                _showAlert(
                                                    context,
                                                    view_model,
                                                    view_model
                                                        .icon_active[index]
                                                        .UUID);
                                              },
                                              child: ClipOval(
                                                child: Container(
                                                  padding: EdgeInsets.all(
                                                      screenWidth * 0.01),
                                                  decoration: BoxDecoration(
                                                    color: is_darkmode
                                                        ? card_dark
                                                        : Colors.white,
                                                  ),
                                                  child: SvgPicture.asset(
                                                    "assets/ico/folder-symlink.svg",
                                                    width: screenWidth * 0.05,
                                                    colorFilter: ColorFilter.mode(
                                                        all_color[
                                                            theme_selected][0],
                                                        BlendMode.srcIn),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenWidth * 0.02,
                                      horizontal: screenWidth * 0.1),
                                  child: Text(
                                    T == Activity ? "Activities" : "Feelings",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.1,
                                        fontFamily: "Second",
                                        color: Colors.black.withOpacity(0.05)),
                                  ),
                                ),
                                Expanded(
                                    child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.125),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 1,
                                  ),
                                  itemCount: view_model.icon_archive.length,
                                  itemBuilder: (context, index) {
                                    return SizedBox.expand(
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                right: screenWidth * 0.015,
                                                left: screenWidth * 0.015,
                                                bottom: screenWidth * 0.03,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      screenWidth * 0.05),
                                              decoration: BoxDecoration(
                                                color: Color.lerp(
                                                  all_color[theme_selected][0],
                                                  is_darkmode
                                                      ? Color.fromARGB(
                                                          255, 41, 66, 97)
                                                      : Colors.white,
                                                  0.925,
                                                )!,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        screenWidth * 0.05),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.05),
                                                    spreadRadius: 0.1,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 10),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    icon_url(view_model
                                                        .icon_archive[index]
                                                        .icon),
                                                    colorFilter: ColorFilter.mode(
                                                        all_color[
                                                            theme_selected][0],
                                                        BlendMode.srcIn),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          screenWidth * 0.02),
                                                  Text(
                                                    view_model
                                                        .icon_archive[index]
                                                        .title,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          screenWidth * 0.025,
                                                      color: all_color[
                                                          theme_selected][0],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: GestureDetector(
                                              onTap: () {
                                                _showAlert(
                                                    context,
                                                    view_model,
                                                    view_model
                                                        .icon_archive[index]
                                                        .UUID);
                                              },
                                              child: ClipOval(
                                                child: Container(
                                                  padding: EdgeInsets.all(
                                                      screenWidth * 0.01),
                                                  decoration: BoxDecoration(
                                                    color: is_darkmode
                                                        ? card_dark
                                                        : Colors.white,
                                                  ),
                                                  child: SvgPicture.asset(
                                                    "assets/ico/folder-symlink.svg",
                                                    width: screenWidth * 0.05,
                                                    colorFilter: ColorFilter.mode(
                                                        all_color[
                                                            theme_selected][0],
                                                        BlendMode.srcIn),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }));
  }
}
