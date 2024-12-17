import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myrefectly/help/image_viewer.dart';
import 'package:myrefectly/help/route.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/views/other/notification.dart';
import 'package:myrefectly/views/quotes/category.dart';
import 'package:myrefectly/share/button.dart';
import 'package:myrefectly/theme/color.dart';
import 'package:myrefectly/views/navigation/navigation_viewmodel.dart';
import 'package:myrefectly/views/quotes/quotes_viewmodel.dart';
import 'package:myrefectly/views/share_component/text.dart';
import 'package:provider/provider.dart';
import 'package:myrefectly/help/color.dart';

class QuotePage extends StatefulWidget {
  const QuotePage({super.key});

  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage>
    with SingleTickerProviderStateMixin {
  int index = 0;

  bool _is_sharing = false;

  // Key cho RepaintBoundary
  final GlobalKey _globalKey = GlobalKey();
  late PageController _pageController;
  @override
  void initState() {
    _pageController = PageController()
      ..addListener(
        () {},
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return ChangeNotifierProvider<Quote_viewmodel>(
        create: (context) => Quote_viewmodel(),
        child: Consumer<Quote_viewmodel>(builder: (context, view_model, child) {
          if (view_model.loading) return Container();
          return Scaffold(
              body: Stack(alignment: Alignment.center, children: [
            Container(
              width: screenWidth,
              height: screenHeight,
              color: Colors.white,
              child: Column(children: [
                Expanded(
                  child: Container(),
                ),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 900),
                  opacity: _is_sharing ? 1 : 0,
                  child: Row(
                    children: [
                      SizedBox(
                        width: screenWidth * 0.06,
                      ),
                      Text(
                        "Share to",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.05),
                            fontFamily: "Second",
                            fontSize: screenWidth * 0.1,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: Container())
                    ],
                  ),
                ),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 900),
                  opacity: _is_sharing ? 1 : 0,
                  child: Row(
                    children: [
                      CustomElement(
                        onTap: () async {
                          //view_model.get_image(index);
                          int rs = await view_model.SaveQuote(_globalKey);
                          if (rs == 1) {
                            show_notification(
                                context,
                                "Quote save successfully",
                                Colors.green[300] as Color);
                          } else {
                            show_notification(
                                context,
                                "Quote save failed",
                                Colors.red[300] as Color);
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: screenWidth * 0.06),
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.1,
                              vertical: screenWidth * 0.05),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: all_color[theme_selected]),
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.05),
                              boxShadow: my_shadow),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/ico/save.svg",
                                colorFilter: ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                              ),
                              Text(
                                "SAVE",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.025,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 900),
                  opacity: _is_sharing ? 1 : 0,
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    child: GestureDetector(
                        onTap: () {
                          Provider.of<Navigation_viewmodel>(context,
                                  listen: false)
                              .hidden_nav(-1);
                          setState(() {
                            _is_sharing = false;
                          });
                        },
                        child: Text("CANCEL",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.3)))),
                  ),
                )
              ]),
            ),
            Column(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 350),
                  height: _is_sharing ? screenWidth * 0.3 : 0,
                ),
                RepaintBoundary(
                  key: _globalKey,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 400),
                    width: _is_sharing ? screenWidth * 0.85 : screenWidth,
                    height: _is_sharing ? screenHeight * 0.55 : screenHeight,
                    curve: Curves.decelerate,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(33, 0, 0, 0),
                        spreadRadius: 0.1,
                        blurRadius: 10,
                        offset: Offset(0, 10),
                      ),
                    ]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(_is_sharing
                          ? screenWidth * 0.05
                          : 0), // Bo góc thay đổi
                      child: Stack(
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child: Container(
                              color: const Color.fromARGB(
                                  255, 24, 40, 73), // Thay đổi màu nền ở đây
                              child: SizedBox.expand(
                                key: ValueKey<int>(index),
                                child: view_model.user.quotesTheme == 0
                                    ?
                                    // ImageSwitcher(
                                    //     imageData: view_model.image_cache[
                                    //         view_model.all_quotes[index].id],
                                    //   )
                                    ImageFromApi(
                                        need_loading_effect: false,
                                        url: "/api/Quotes/wallpaper?mediaId=" +
                                            view_model.all_quotes[index].id,
                                      )
                                    : Image.asset(
                                        "assets/quote_backgrounds/${view_model.user.quotesTheme}.webp",
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                          PageView.builder(
                            controller: _pageController,
                            physics: _is_sharing
                                ? NeverScrollableScrollPhysics()
                                : AlwaysScrollableScrollPhysics(),
                            onPageChanged: (value) async {
                              //view_model.load_image(value);

                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                //view_model.load_image(value);
                                setState(() {
                                  index = value;
                                });
                              });
                            },
                            scrollDirection: Axis.vertical,
                            itemCount: view_model.all_quotes.length,
                            itemBuilder: (context, index) {
                              return SizedBox.expand(
                                child: Container(
                                  //color: Color.fromARGB(23, 0, 0, 0),
                                  color: const Color.fromARGB(32, 0, 72, 255),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: _is_sharing
                                            ? screenWidth * 0.05
                                            : screenWidth * 0.15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        text_intro(
                                            text: view_model
                                                .all_quotes[index].content,
                                            color: Colors.white,
                                            fontsize: _is_sharing
                                                ? screenWidth * 0.035
                                                : screenWidth * 0.04),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "-  ${view_model.all_quotes[index].author}  -",
                                              style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: screenWidth * 0.03,
                                                  fontWeight:
                                                      ui.FontWeight.bold),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 250),
                            opacity: _is_sharing ? 0 : 1,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(bottom: screenHeight * 0.1),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  height: screenHeight * 0.1,
                                  child: Row(children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.05),
                                      child: CustomElement(
                                        onTap: () async {
                                          int old_cate =
                                              view_model.user.quote_category;
                                          final result = await Navigator.push(
                                              context,
                                              Slide_up_Route(
                                                  secondPage: CategoryPage()));
                                          view_model.init_data().then(
                                                (value) {},
                                              );

                                          if (old_cate !=
                                              view_model.user.quote_category) {
                                            setState(() {
                                              _pageController.jumpToPage(0);
                                              index = 0;
                                            });
                                          }
                                          setState(() {
                                            if (view_model.all_quotes.length >
                                                index) {}
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color.fromARGB(
                                                46, 255, 255, 255),
                                          ),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                "assets/img/layout-grid.svg",
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                        Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        BlendMode.srcIn),
                                              ),
                                              SizedBox(
                                                width: screenWidth * 0.015,
                                              ),
                                              text_intro(
                                                  text: all_category()[
                                                      view_model
                                                          .user.quote_category],
                                                  color: Colors.white,
                                                  fontsize: 12),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.0),
                                      child: CustomElement(
                                        onTap: () {
                                          view_model.like(
                                              view_model.all_quotes[index].id);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color.fromARGB(
                                                46, 255, 255, 255),
                                          ),
                                          child: Row(
                                            children: [
                                              AnimatedSwitcher(
                                                duration: const Duration(
                                                    milliseconds:
                                                        300), // Thời gian chuyển đổi
                                                transitionBuilder:
                                                    (Widget child,
                                                        Animation<double>
                                                            animation) {
                                                  return ScaleTransition(
                                                      scale: animation,
                                                      child:
                                                          child); // Hiệu ứng scale
                                                },
                                                child: SvgPicture.asset(
                                                  view_model.user.quote_hearted
                                                          .contains(view_model
                                                              .all_quotes[index]
                                                              .id)
                                                      ? "assets/ico/heart.svg"
                                                      : "assets/img/heart.svg",
                                                  key: ValueKey<bool>(view_model
                                                      .user.quote_hearted
                                                      .contains(view_model
                                                          .all_quotes[index]
                                                          .id)), // Cung cấp key duy nhất cho mỗi trạng thái
                                                  colorFilter:
                                                      const ColorFilter.mode(
                                                    Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.05),
                                      child: CustomElement(
                                        onTap: () {
                                          Provider.of<Navigation_viewmodel>(
                                                  context,
                                                  listen: false)
                                              .hidden_nav(2);
                                          setState(() {
                                            _is_sharing = !_is_sharing;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color.fromARGB(
                                                46, 255, 255, 255),
                                          ),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                "assets/img/share.svg",
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                        Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        BlendMode.srcIn),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.all(screenWidth * 0.05),
                              child: Text(
                                "reflectly",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: ui.FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]));
        }));
  }
}
