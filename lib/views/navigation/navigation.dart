import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myrefectly/help/delay_animation.dart';
import 'package:myrefectly/help/enum.dart';
import 'package:myrefectly/help/route.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/views/entries/entries_viewmodel.dart';
import 'package:myrefectly/views/quotes/quotes.dart';
import 'package:myrefectly/views/mood_checkin/checkin.dart';
import 'package:myrefectly/views/entries/entries.dart';
import 'package:myrefectly/views/home/home.dart';
import 'package:myrefectly/views/share_component/custom_loading.dart';
import 'package:myrefectly/views/statistical/statistical.dart';
import 'package:myrefectly/views/voice_note/voice.dart';
import 'package:myrefectly/share/button.dart';
import 'package:myrefectly/theme/color.dart';
import 'package:myrefectly/views/navigation/navigation_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:myrefectly/help/color.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<StatefulWidget> createState() => NavigationPageState();
}

int page_index_now = 0;

class NavigationPageState extends State<NavigationPage>
    with SingleTickerProviderStateMixin {
  final int _currentIndex = 0;
  bool hidden_navigation_bar = false;
  bool action_pressing = false;
  List<Widget> _pages = [
    // const HomePage(),
    // const AdvicePage(),
    // const StatisticalPage(),
    //  EntriesPage(onActionCompleted: () => refresh_ui,
    //  ),
  ];

  late Widget tab;
  bool add_tapping = false;
  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const QuotePage(),
      const StatisticalPage(),
      EntriesPage(
        onActionCompleted: () => refresh_ui,
      ),
    ];
    _controller.forward();
    tab = _pages[0];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<Navigation_viewmodel>(context, listen: false).hidden_nav(-1);
    });
  }

  void refresh_ui() {
    setState(() {
      theme_selected = theme_selected;
    });
  }

  final GlobalKey _key = GlobalKey();
  List<GlobalKey> list_key = List.generate(4, (index) => GlobalKey());
  Offset _position = Offset.zero;
  Size _size = Size.zero;

  void _getPositionAndSize(GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
          key.currentContext?.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;
      setState(() {
        _position = position;
        _size = size;
      });
      print('Position: $_position');
      print('Size: $_size');
    });
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  //..repeat(reverse: true);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0, 0.1),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  ));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    margin_height_Global = screenWidth * 0.05;
    return Consumer<Navigation_viewmodel>(
      builder: (context, view_model, child) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                AnimatedSwitcher(
                    reverseDuration: const Duration(milliseconds: 0),
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 0.05),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _pages[view_model.page]
                    //tab,
                    ),
                if (add_tapping)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        add_tapping = false;
                      });
                    },
                    child: Container(
                      width: screenWidth,
                      height: screenHeight,
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.2)),
                    ),
                  ),
                Consumer<Navigation_viewmodel>(
                    builder: (context, notifier, child) {
                  return AnimatedPositioned(
                    curve: Curves.decelerate,
                    duration: Duration(milliseconds: 250),
                    top: Provider.of<Navigation_viewmodel>(context,
                                    listen: false)
                                .is_hidden >
                            -1
                        ? screenHeight
                        : screenHeight * (688 - 51) / 688,
                    child: Container(
                      height: screenHeight * 51 / 688,
                      width: screenWidth,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(35)),
                          color: is_darkmode ? card_dark : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.1), // Màu của bóng
                              spreadRadius: 5, // Kích thước của bóng
                              blurRadius: 7, // Độ mờ của bóng
                              offset: const Offset(0, 4), // Vị trí của bóng
                            ),
                          ]),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                        child: Stack(children: [
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _getPositionAndSize(list_key[0]);
                                    setState(() {
                                      //tab = const HomePage();
                                      tab = _pages[0];
                                      notifier.page = 0;
                                      page_index_now = 0;
                                      _controller.forward();
                                    });
                                  },
                                  child: BottomItem(
                                      key: list_key[0],
                                      pageindex: 0,
                                      icon: "assets/img/sun.svg"),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _getPositionAndSize(list_key[1]);
                                    _controller.forward();
                                    setState(() {
                                      tab = _pages[1];
                                      //tab = const AdvicePage();
                                      notifier.page = 1;
                                      page_index_now = 1;
                                    });
                                  },
                                  child: BottomItem(
                                      key: list_key[1],
                                      pageindex: 1,
                                      icon: "assets/img/quote.svg"),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.1,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _getPositionAndSize(list_key[2]);
                                    setState(() {
                                      page_index_now = 2;
                                      notifier.page = 2;
                                      //tab = const StatisticalPage();
                                      tab = _pages[2];
                                    });
                                  },
                                  child: BottomItem(
                                      key: list_key[2],
                                      pageindex: 2,
                                      icon: "assets/img/activity.svg"),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      _getPositionAndSize(list_key[3]);
                                      setState(() {
                                        //tab = const UserPage();
                                        tab = tab = _pages[3];
                                        page_index_now = 3;
                                        notifier.page = 3;
                                      });

                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             const LineChartSample2()));
                                    },
                                    child: BottomItem(
                                        key: list_key[3],
                                        pageindex: 3,
                                        icon: "assets/img/copy.svg"))
                              ],
                            ),
                          ),
                          AnimatedPositioned(
                              curve: Curves.decelerate,
                              bottom: 1,
                              left: _position.dx - screenWidth * 0.1 + 9,
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                ".",
                                style: TextStyle(
                                    fontSize: 30,
                                    color: is_darkmode
                                        ? Colors.white
                                        : Colors.black),
                              )),
                        ]),
                      ),
                    ),
                  );
                }),
                Stack(children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedScale(
                      curve: Curves.elasticOut,
                      duration: Duration(milliseconds: 1000),
                      scale: Provider.of<Navigation_viewmodel>(context,
                                      listen: false)
                                  .is_hidden <
                              2
                          ? 1
                          : 0,
                      child: Container(
                        margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                        height: screenHeight * 51 / 688,
                        width: screenHeight * 51 / 688,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.06),
                            color: view_model.color_theme[0],
                            boxShadow: my_shadow),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.01),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ClipPath(
                          clipper: MyCustomClipper2(
                              screenHeight: screenHeight,
                              radius: screenWidth * 0.06,
                              bottomHeight: screenHeight * 51 / 688 -
                                  screenHeight * 0.01),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.fastOutSlowIn,
                            //margin: EdgeInsets.only(bottom: screenHeight * 0.2),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            width: add_tapping ? screenWidth * 0.5 : 0,
                            height: add_tapping ? 230 : 0,
                            decoration: BoxDecoration(
                              boxShadow: my_shadow,
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  all_color[theme_selected][1],
                                  all_color[theme_selected][0]
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),

                            child: Column(
                              children: [
                                DelayAnimation(
                                  delay: 50,
                                  shouldFaded: false,
                                  child: CustomElement(
                                    onTap: () async {
                                      await Navigator.push(
                                          context,
                                          Slide_up_Route(
                                              secondPage: Checkin()));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Mood check-in",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  screenWidth_Global * 0.035),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(
                                              screenWidth * 0.02),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      screenWidth * 0.02),
                                              color: const Color.fromARGB(
                                                  26, 0, 0, 0)),
                                          child: SvgPicture.asset(
                                            height: 20,
                                            mood[2]!,
                                            colorFilter: const ColorFilter.mode(
                                                Colors.white, BlendMode.srcIn),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                DelayAnimation(
                                  delay: 100,
                                  shouldFaded: false,
                                  child: CustomElement(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          Slide_up_Route(
                                              secondPage: VoicePage()));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Voice note",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  screenWidth_Global * 0.035),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(
                                              screenWidth * 0.02),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      screenWidth * 0.02),
                                              color: const Color.fromARGB(
                                                  26, 0, 0, 0)),
                                          child: SvgPicture.asset(
                                            height: 20,
                                            "assets/ico/wave-sine.svg",
                                            colorFilter: const ColorFilter.mode(
                                                Colors.white, BlendMode.srcIn),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                DelayAnimation(
                                  delay: 150,
                                  shouldFaded: false,
                                  child: CustomElement(
                                    onTap: () async {
                                      await view_model.uploadImage().then(
                                        (value) {
                                          setState(() {});
                                        },
                                      );
                                      try {
                                        Provider.of<Entries_Viewmodel>(context,
                                                listen: false)
                                            .loadData();
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Add photo",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  screenWidth_Global * 0.035),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(
                                              screenWidth * 0.02),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      screenWidth * 0.02),
                                              color: const Color.fromARGB(
                                                  26, 0, 0, 0)),
                                          child: SvgPicture.asset(
                                            height: 20,
                                            "assets/ico/photo.svg",
                                            colorFilter: const ColorFilter.mode(
                                                Colors.white, BlendMode.srcIn),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                  ),
                  AnimatedScale(
                    duration: Duration(milliseconds: 0),
                    scale: Provider.of<Navigation_viewmodel>(context,
                                    listen: false)
                                .is_hidden <
                            2
                        ? 1
                        : 0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            add_tapping =
                                !add_tapping; // Toggle the state on tap
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) => const Checkin()));
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                          height: screenHeight * 51 / 688,
                          width: screenHeight * 51 / 688,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            //color: const Color.fromARGB(255, 254, 183, 161)
                          ),
                          child: Center(
                            child: TweenAnimationBuilder(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                              tween: Tween<double>(
                                  begin: 0,
                                  end: add_tapping ? 135.0 * pi / 180.0 : 0),
                              builder: (context, angle, child) {
                                return Transform.rotate(
                                  angle: angle,
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),

                if (view_model.actionStatus != ActionStatus.waiting)
                  CustomLoadingDialog(
                    actionStatus: view_model.actionStatus,
                    onClose: () {
                      setState(() {
                        view_model.actionStatus = ActionStatus.waiting;
                      });
                    },
                  )
                // if (view_model.uploading)
                //   Container(
                //     width: screenWidth,
                //     height: screenHeight,
                //     color: Colors.black.withOpacity(0.3),
                //     child: Center(
                //       child: Container(
                //         height: screenWidth * 0.4,
                //         width: screenWidth * 0.45,
                //         padding: EdgeInsets.all(screenWidth * 0.05),
                //         decoration: BoxDecoration(
                //             color: is_darkmode ? card_dark : Colors.white,
                //             borderRadius:
                //                 BorderRadius.circular(screenWidth * 0.05)),
                //         child: Stack(
                //           children: [
                //             Center(
                //               child: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.center,
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   SizedBox(
                //                     height: screenWidth * 0.05,
                //                   ),
                //                   RotatingSvgIcon(),
                //                   SizedBox(
                //                     height: screenWidth * 0.05,
                //                   ),
                //                   Text(
                //                     "UPLOADING ...",
                //                     style: TextStyle(
                //                         fontWeight: FontWeight.bold,
                //                         fontFamily: "Second",
                //                         color: is_darkmode
                //                             ? Colors.white
                //                             : Colors.black),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //             Align(
                //               alignment: Alignment.topRight,
                //               child: GestureDetector(
                //                 onTap: () {
                //                   setState(() {
                //                     view_model.uploading = !view_model.uploading;
                //                   });
                //                 },
                //                 child: Icon(
                //                   Icons.close,
                //                   color:
                //                       is_darkmode ? Colors.white : Colors.black,
                //                 ),
                //               ),
                //             )
                //           ],
                //         ),
                //       ),
                //     ),
                //   )
              ],
            ));
      },
    );
  }
}

class BottomItem extends StatefulWidget {
  final int pageindex;
  final String icon;
  const BottomItem({super.key, required this.pageindex, required this.icon});

  @override
  State<StatefulWidget> createState() => BottomItemState();
}

class BottomItemState extends State<BottomItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      widget.icon,
      colorFilter: ColorFilter.mode(
          widget.pageindex ==
                  Provider.of<Navigation_viewmodel>(context, listen: false).page
              ? is_darkmode
                  ? Colors.white
                  : Colors.black
              : const Color.fromARGB(255, 171, 171, 171),
          BlendMode.srcIn),
    );
  }
}

class MyCustomClipper2 extends CustomClipper<Path> {
  final double screenHeight;
  double radius;
  double bottom_radius = 0;
  final double bottomHeight;
  int siz = 0;
  MyCustomClipper2(
      {required this.screenHeight,
      required this.radius,
      required this.bottomHeight}) {
    bottom_radius = radius;
    radius = radius * 0.75;
  }

  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.moveTo(0, 0);

    path.lineTo(0, size.height - bottomHeight - radius + siz);

    path.quadraticBezierTo(0, size.height - bottomHeight + siz, radius,
        size.height - bottomHeight + siz);

    path.lineTo((size.width - bottomHeight) / 2 - radius - screenHeight * 0.005,
        size.height - bottomHeight + siz);

    path.quadraticBezierTo(
        (size.width - bottomHeight) / 2 - screenHeight * 0.0025,
        size.height - bottomHeight + siz,
        (size.width - bottomHeight) / 2 - screenHeight * 0.005,
        size.height - bottomHeight + radius + screenHeight * 0.005);

    path.lineTo((size.width - bottomHeight) / 2 - screenHeight * 0.005,
        size.height - bottom_radius / 2 - screenHeight * 0.01);

    path.quadraticBezierTo(
        ((size.width - bottomHeight) / 2),
        size.height - bottom_radius / 2 + screenHeight * 0.01,
        (size.width - bottom_radius) / 2 + screenHeight * 0.005,
        size.height);

    path.lineTo((size.width + bottomHeight) / 2 - bottom_radius, size.height);
    // path.quadraticBezierTo(
    //     (size.width) / 2 + bottom_radius,
    //      size.height  ,
    //       (size.width) / 2 + bottom_radius,
    //        size.height - bottom_radius
    //        );

    path.quadraticBezierTo(
        (size.width + bottomHeight) / 2 + screenHeight * 0.0025,
        size.height - bottom_radius * 0.01,
        (size.width + bottomHeight) / 2 + screenHeight * 0.005,
        size.height - bottom_radius);

    path.lineTo((size.width + bottomHeight) / 2 + screenHeight * 0.005,
        size.height - bottomHeight + bottom_radius * 0.9);

    path.quadraticBezierTo(
        (size.width + bottomHeight) / 2 + screenHeight * 0.005,
        size.height - bottomHeight + siz,
        (size.width + bottomHeight) / 2 + radius + screenHeight * 0.005,
        size.height - bottomHeight + siz);

    path.lineTo(size.width - radius, size.height - bottomHeight + siz);

    path.quadraticBezierTo(size.width, size.height - bottomHeight + siz,
        size.width, size.height - bottomHeight - radius + siz);

    path.lineTo(size.width, radius);
    path.quadraticBezierTo(size.width, 0, size.width - radius, 0);

    path.lineTo(radius, 0);
    path.quadraticBezierTo(0, 0, 0, radius);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
