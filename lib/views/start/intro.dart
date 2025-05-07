import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myrefectly/help/delay_animation.dart';
import 'package:myrefectly/help/route.dart';
import 'package:myrefectly/views/login/login.dart';
import 'package:myrefectly/views/login/register.dart';
import 'package:myrefectly/share/button.dart';
import 'package:myrefectly/share/custominp.dart';
import 'package:myrefectly/views/share_component/reflectly_face.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/views/share_component/text.dart';
import 'package:myrefectly/views/start/intro_viewmodel.dart';
import 'package:provider/provider.dart';

class Intro_Page extends StatefulWidget {
  const Intro_Page({super.key});

  @override
  _LookThroughScreenState createState() => _LookThroughScreenState();
}

class _LookThroughScreenState extends State<Intro_Page>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final PageController _controllerPage =
      PageController(viewportFraction: 0.3, initialPage: 0);
  int _currentPage = 0;
  double _curr = 0.0;
  int step = 0;

  late AnimationController _controller;
  late Animation<double> _animation;
  Offset _tapPosition = Offset.zero;

  List<Color> current_color = [];
  List<Color> next_color = [];
  bool flag = true;
  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);

    current_color = all_color[theme_selected];
    next_color = all_color[theme_selected];
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1000).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Add listener to controller to detect page scroll
    _controllerPage.addListener(() {
      setState(() {
        _curr = _controllerPage.page!;
      });
    });
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      flag = !flag;
      _tapPosition = details.globalPosition;
      _controller.reset();
      //_controller.forward();
      _controller.forward().then((value) {
        current_color = next_color;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return ChangeNotifierProvider<Intro_Viewmodel>(
        create: (context) => Intro_Viewmodel(),
        child: Consumer<Intro_Viewmodel>(builder: (context, view_model, child) {
          if (view_model.loading || view_model.user == null) return Container();
          return Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: next_color,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                ),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return ClipPath(
                      clipper: CircularClipper(
                          pos: _tapPosition, siz: _animation.value),
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: current_color,
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter)),
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    );
                  },
                ),
                TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.2,
                          ),
                          DelayAnimation(
                              delay: 1000,
                              shouldFaded: false,
                              child: text_intro(
                                  text: "Hi there,",
                                  color: Colors.white,
                                  fontsize: screenWidth * 0.06)),
                          DelayAnimation(
                              delay: 1500,
                              shouldFaded: false,
                              child: text_intro(
                                  text: "I'm Reflectly",
                                  color: Colors.white,
                                  fontsize: screenWidth * 0.06)),
                          const SizedBox(
                            height: 20,
                          ),
                          DelayAnimation(
                            delay: 2000,
                            shouldFaded: false,
                            sliding: false,
                            child: Column(
                              children: [
                                text_intro(
                                    text: "Your new personal",
                                    color: const Color.fromARGB(
                                        163, 255, 255, 255),
                                    fontsize: screenWidth * 0.04),
                                text_intro(
                                    text: "self-care companion",
                                    color: const Color.fromARGB(
                                        163, 255, 255, 255),
                                    fontsize: screenWidth * 0.04)
                              ],
                            ),
                          ),
                          Expanded(child: Container()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: DelayAnimation(
                              delay: 3000,
                              shouldFaded: false,
                              is_faded_animation: false,
                              sliding: false,
                              child: CustomButton(
                                onTap: () {
                                  _tabController.animateTo(1);
                                  setState(() {
                                    step = 1;
                                  });
                                },
                                text: 'HI, REFLECTLY!',
                                color: Colors.white,
                                color_text: all_color[theme_selected][0],
                                have_shadow: true,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 50),
                            child: DelayAnimation(
                              delay: 3500,
                              shouldFaded: false,
                              is_faded_animation: false,
                              sliding: false,
                              child: CustomButton(
                                text: "I ALREADY HAVE AN ACCOUNT",
                                color: Colors.transparent,
                                color_text: Colors.white,
                                have_shadow: false,
                                onTap: () {
                                  Navigator.push(context,
                                      Slide_up_Route(secondPage: Login_Page()));
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(children: [
                        //Expanded(child: SizedBox()),
                        Padding(
                          padding: EdgeInsets.only(
                              left: screenWidth * 0.1,
                              right: screenWidth * 0.1,
                              top: screenHeight * 0.2),
                          child: Text(
                            'So nice to meet you! What do your friends call you?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05),
                          child: Custom_Input(
                            limit: 40,
                            hint: "Your nickname ...",
                            fontsize: screenWidth * 0.04,
                            viewing: false,
                            onChanged: (value) {
                              setState(() {
                                view_model.user?.user_name = value;
                                view_model.user?.save();
                              });
                            },
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Padding(
                          padding: EdgeInsets.only(
                              left: screenWidth * 0.15,
                              right: screenWidth * 0.15,
                              bottom: screenHeight * 0.05),
                          child: CustomButton(
                            onTap: () {
                              step = 2;
                              _tabController.animateTo(step);
                            },
                            color: Colors.white,
                            color_text: all_color[theme_selected][0],
                            have_shadow: true,
                            text: "NEXT",
                          ),
                        ),
                      ]),
                      Column(children: [
                        SizedBox(
                          height: screenWidth * 0.4,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.1,
                              vertical: screenWidth * 0.02),
                          child: Text(
                            'Theme, ${view_model.user?.user_name}\nWhich one is most you?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          "CAN BE CHANGE LATER IN SETTING",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.25),
                              fontFamily: "Second",
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                            child: SizedBox(
                          height: screenWidth * 0.05,
                        )),
                        Container(
                          height: screenHeight * 0.4,
                          //margin: EdgeInsets.symmetric(horizontal: 30),
                          decoration: BoxDecoration(
                            //color: Color.fromARGB(110, 169, 169, 169),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          //height: 220,
                          child: PageView.builder(
                            controller: _controllerPage,
                            itemCount: all_color.length,
                            onPageChanged: (int index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return AnimatedBuilder(
                                animation: _controller,
                                builder: (context, child) {
                                  double pageOffset = 0.0;

                                  if (_controllerPage.hasClients &&
                                      _controllerPage.position.haveDimensions) {
                                    pageOffset = _controllerPage.page! - index;
                                  } else {
                                    // Tính toán giá trị khởi tạo dựa trên _currentPage
                                    pageOffset =
                                        _currentPage - index.toDouble();
                                  }

                                  // Tính toán tỷ lệ và dịch chuyển
                                  double scale = 1.0 - (pageOffset.abs() * 0.3);
                                  // double translationY = 40 *
                                  //     (1 - scale); // Điều chỉnh dịch chuyển dọc

                                  scale = scale.clamp(0.8, 1.0);

                                  return Transform.translate(
                                    offset: Offset(0,
                                        ((_curr - index) * 40).clamp(-40, 40)),
                                    child: Transform.scale(
                                      scale: scale - 0.2,
                                      child: GestureDetector(
                                        onTapDown: (detail) {
                                          next_color = all_color[index];
                                          _onTapDown(detail);
                                          _controllerPage.animateToPage(index,
                                              duration: const Duration(
                                                  milliseconds: 400),
                                              curve: Curves.decelerate);
                                          setState(() {
                                            view_model.user?.theme_color =
                                                index;
                                            view_model.user?.save();
                                            theme_selected = index;
                                          });
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                    0.2), // Màu của shadow với độ mờ
                                                spreadRadius:
                                                    3, // Bán kính lan tỏa của shadow
                                                blurRadius:
                                                    7, // Độ mờ của shadow
                                                offset: const Offset(0,
                                                    3), // Vị trí của shadow (x, y)
                                              ),
                                            ],
                                            gradient: LinearGradient(
                                                colors: all_color[index],
                                                begin: Alignment.bottomLeft,
                                                end: Alignment.topRight),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Padding(
                          padding: EdgeInsets.only(
                              left: screenWidth * 0.15,
                              right: screenWidth * 0.15,
                              bottom: screenHeight * 0.05),
                          child: CustomButton(
                            onTap: () {
                              _tabController.animateTo(3);
                            },
                            color: Colors.white,
                            color_text: all_color[theme_selected][0],
                            have_shadow: true,
                            text: "OKAY",
                          ),
                        ),
                      ]),
                      Column(children: [
                        //Expanded(child: SizedBox()),
                        Padding(
                          padding: EdgeInsets.only(
                              left: screenWidth * 0.1,
                              right: screenWidth * 0.1,
                              top: screenHeight * 0.2,
                              bottom: screenWidth * 0.025),
                          child: Text(
                            'Want me to keep you on track with small reminders?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          "LIFE IS GET BUSY. FOCUS IS KEY",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.25),
                              fontFamily: "Second",
                              fontWeight: FontWeight.bold),
                        ),
                        const Expanded(child: SizedBox()),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.15),
                            child: Image.asset("assets/ico/reminders.png")),
                        const Expanded(child: SizedBox()),
                        Padding(
                          padding: EdgeInsets.only(
                              left: screenWidth * 0.15,
                              right: screenWidth * 0.15,
                              bottom: screenHeight * 0.05),
                          child: CustomButton(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  Slide_up_Route(
                                      secondPage: Register_Page(
                                    username: view_model.user?.user_name ?? "",
                                  )));
                            },
                            color: Colors.white,
                            color_text: all_color[theme_selected][0],
                            have_shadow: true,
                            text: "LET'S GO",
                            //text: "YES, PLEASE",
                          ),
                        ),
                      ]),
                    ]),
                Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: screenWidth * 0.125),
                      child: reflectly_face(),
                    )),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  left: step == 0 ? -50 : 0,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: screenWidth * 0.225, left: screenWidth * 0.05),
                        child: GestureDetector(
                          onTap: () {
                            step--;
                            _tabController.animateTo(step);
                            if (step == 0) {
                              setState(() {
                                step = 0;
                              });
                            }
                          },
                          child: SvgPicture.asset(
                            "assets/ico/arrow_back.svg",
                            color: Colors.white.withOpacity(0.5),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          );
        }));
  }
}

class CircularClipper extends CustomClipper<Path> {
  final Offset pos;
  final double siz;

  CircularClipper({required this.pos, required this.siz});

  @override
  Path getClip(Size size) {
    final Path path = Path();

    // Tạo hình tròn với bán kính là giá trị siz từ vị trí pos
    path.addOval(Rect.fromCircle(center: pos, radius: siz));
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    path.fillType = PathFillType.evenOdd; // Tạo hiệu ứng loang

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}












































// class ColorSelectorScreen extends StatefulWidget {
//   final VoidCallback? onLongPress;

//   const ColorSelectorScreen({super.key, this.onLongPress});
//   @override
//   _ColorSelectorScreenState createState() => _ColorSelectorScreenState();
// }

// class _ColorSelectorScreenState extends State<ColorSelectorScreen> {
//   final PageController _controller =
//       PageController(viewportFraction: 0.3, initialPage: 0);
//   int _currentPage = 0;
//   double _curr = 0.0;

//   final List<Color> colors = [
//     Colors.red,
//     Colors.green,
//     Colors.blue,
//     Colors.yellow,
//     Colors.orange,
//     Colors.purple,
//   ];

//   @override
//   void initState() {
//     super.initState();
//     // Add listener to controller to detect page scroll
//     _controller.addListener(() {
//       //print(_controller.page!);
//       setState(() {
//         _curr = _controller.page!;
//         //_curr = _controller.page! - _controller.page!.floor() - 0.5;
//         //print(_curr);
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       //margin: EdgeInsets.symmetric(horizontal: 30),
//       decoration: BoxDecoration(
//         //color: const Color.fromARGB(255, 169, 169, 169),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       height: 220,
//       child: PageView.builder(
//         physics: ClampingScrollPhysics(),
//         controller: _controller,
//         itemCount: colors.length,
//         onPageChanged: (int index) {
//           setState(() {
//             _currentPage = index;
//           });
//         },
//         itemBuilder: (context, index) {
//           return AnimatedBuilder(
//             animation: _controller,
//             builder: (context, child) {
//               double pageOffset = 0.0;

//               if (_controller.hasClients &&
//                   _controller.position.haveDimensions) {
//                 pageOffset = _controller.page! - index;
//               } else {
//                 // Tính toán giá trị khởi tạo dựa trên _currentPage
//                 pageOffset = _currentPage - index.toDouble();
//               }

//               // Tính toán tỷ lệ và dịch chuyển
//               double scale = 1.0 - (pageOffset.abs() * 0.3);
//               double translationY =
//                   40 * (1 - scale); // Điều chỉnh dịch chuyển dọc

//               scale = scale.clamp(0.8, 1.0);

//               return Transform.translate(
//                 offset: Offset(0, ((_curr - index) * 40).clamp(-40, 40)),
//                 child: Transform.scale(
//                   scale: scale - 0.2,
//                   child: GestureDetector(
//                     onTap: () {
//                       widget.onLongPress;
//                     },
//                     child: Container(
//                       margin: EdgeInsets.symmetric(horizontal: 10),
//                       decoration: BoxDecoration(
//                         color: colors[index],
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: Colors.white,
//                           width: 5,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
