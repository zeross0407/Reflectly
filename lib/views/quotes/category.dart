import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/share/button.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/viewmodels/categories_viewmodel.dart';
import 'package:myrefectly/views/quotes/category_card.dart';
import 'package:myrefectly/views/quotes/scaleable_icon.dart';
import 'package:myrefectly/views/share_component/exit_button.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<StatefulWidget> createState() => CategoryPageState();
}

class CategoryPageState extends State<CategoryPage>
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return ChangeNotifierProvider<Categories_Viewmodel>(
        create: (context) => Categories_Viewmodel(),
        child: Consumer<Categories_Viewmodel>(
            builder: (context, view_model, child) {
          return Scaffold(
            body: Stack(
              children: [
                Container(
                  height: screenHeight,
                  width: screenWidth,
                  color: is_darkmode ? background_dark : background_light,
                ),
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                            padding: EdgeInsets.only(
                                top: screenWidth * 0.15,
                                right: screenWidth * 0.075),
                            child: exit_button(context, is_darkmode)),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Center(
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Text(
                              _controller.index == 1 ? "Themes" : "Categories",
                              style: TextStyle(
                                fontSize: screenWidth * 0.1,
                                fontFamily: "Second",
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                                    .withOpacity(is_darkmode ? 0.1 : 0.05),
                              ),
                            ),
                            IntrinsicWidth(
                              child: Container(
                                margin: EdgeInsets.only(top: screenWidth * 0.1),
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
                                      ? Colors.white.withOpacity(0.25)
                                      : Colors.black54,
                                  tabs: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: screenWidth * 0.025),
                                      child: Text(
                                        "categories",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * 0.03,
                                          //color: is_darkmode ? Colors.white.withOpacity(0.5) : Colors.black
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: screenWidth * 0.025),
                                      child: Text(
                                        "themes",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * 0.03,
                                          //color: is_darkmode ? Colors.white.withOpacity(0.5) : Colors.black
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
                    if (!view_model.loading)
                      SliverToBoxAdapter(
                        child: Container(
                          margin: EdgeInsets.only(top: screenWidth * 0.1),
                          height: _controller.index == 0
                              ? screenHeight * 1.25
                              : screenHeight *
                                  1.25, // Adjust the height as needed
                          child: TabBarView(
                            controller: _controller,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: screenWidth * 0.44,
                                    child: GridView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.075,
                                        vertical: screenWidth * 0.075,
                                      ),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                        crossAxisSpacing: screenWidth * 0.03,
                                        mainAxisSpacing: screenWidth * 0.03,
                                        childAspectRatio: 0.7,
                                      ),
                                      itemCount: 2,
                                      itemBuilder: (context, index) {
                                        return CustomElement(
                                            onTap: () {
                                              setState(() {
                                                view_model.user.quote_category =
                                                    index;
                                                view_model.user.save();
                                              });
                                            },
                                            child: CategoryCard(
                                                index: index,
                                                view_model: view_model,
                                                name: all_category()[index],
                                                image:
                                                    "assets/quote_categories/thumbnails/(${index + 1}).png"));
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.075),
                                    child: Text(
                                      "Mental Health",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * 0.045,
                                          color: is_darkmode
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                  Container(
                                    height: screenWidth * 0.75,
                                    child: GridView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.075,
                                        vertical: screenWidth * 0.075,
                                      ),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: screenWidth * 0.03,
                                        mainAxisSpacing: screenWidth * 0.03,
                                        childAspectRatio: 0.7,
                                      ),
                                      itemCount: 4,
                                      itemBuilder: (context, index) {
                                        return CustomElement(
                                            onTap: () {
                                              setState(() {
                                                view_model.user.quote_category =
                                                    index + 2;
                                                view_model.user.save();
                                              });
                                            },
                                            child: CategoryCard(
                                                index: index + 2,
                                                view_model: view_model,
                                                name: all_category()[index + 2],
                                                image:
                                                    "assets/quote_categories/thumbnails/(${index + 2 + 1}).png"));
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.075),
                                    child: Text(
                                      "Hard Times",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * 0.045,
                                          color: is_darkmode
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                  Container(
                                    height: screenWidth * 0.75,
                                    child: GridView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.075,
                                        vertical: screenWidth * 0.075,
                                      ),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: screenWidth * 0.03,
                                        mainAxisSpacing: screenWidth * 0.03,
                                        childAspectRatio: 0.7,
                                      ),
                                      itemCount: 3,
                                      itemBuilder: (context, index) {
                                        return CustomElement(
                                            onTap: () {
                                              setState(() {
                                                view_model.user.quote_category =
                                                    index + 6;
                                                view_model.user.save();
                                              });
                                            },
                                            child: CategoryCard(
                                                index: index + 6,
                                                view_model: view_model,
                                                name: all_category()[index + 6],
                                                image:
                                                    "assets/quote_categories/thumbnails/(${index + 7 + 1}).png"));
                                      },
                                    ),
                                  ),

                                  // Padding(
                                  //   padding: EdgeInsets.only(
                                  //       left: screenWidth * 0.075),
                                  //   child: Text(
                                  //     "Work Productivity",
                                  //     style: TextStyle(
                                  //         fontWeight: FontWeight.bold,
                                  //         fontSize: screenWidth * 0.045,
                                  //         color: is_darkmode
                                  //             ? Colors.white
                                  //             : Colors.black),
                                  //   ),
                                  // ),
                                  // Container(
                                  //   height: screenWidth * 0.75,
                                  //   child: GridView.builder(
                                  //     scrollDirection: Axis.horizontal,
                                  //     padding: EdgeInsets.symmetric(
                                  //       horizontal: screenWidth * 0.075,
                                  //       vertical: screenWidth * 0.075,
                                  //     ),
                                  //     gridDelegate:
                                  //         SliverGridDelegateWithFixedCrossAxisCount(
                                  //       crossAxisCount: 2,
                                  //       crossAxisSpacing: screenWidth * 0.03,
                                  //       mainAxisSpacing: screenWidth * 0.03,
                                  //       childAspectRatio: 0.7,
                                  //     ),
                                  //     itemCount: 6,
                                  //     itemBuilder: (context, index) {
                                  //       return CustomElement(
                                  //           onTap: () {
                                  //             setState(() {
                                  //               view_model.user.quote_category =
                                  //                   index + 9;
                                  //               view_model.user.save();
                                  //             });
                                  //           },
                                  //           child: CategoryCard(
                                  //               index: index + 9,
                                  //               view_model: view_model,
                                  //               name: all_category()[index + 9],
                                  //               image:
                                  //                   "assets/quote_categories/thumbnails/(${index + 11 + 1}).png"));
                                  //     },
                                  //   ),
                                  // ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      view_model.change_wallpaper(0);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.075),
                                      height: 120,
                                      width: double.infinity,
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: AnimatedSwitcher(
                                              duration: const Duration(
                                                  milliseconds: 250),
                                              child: SizedBox.expand(
                                                key:
                                                    ValueKey<int>(currentIndex),
                                                child: Image.asset(
                                                  "assets/quote_backgrounds/${currentIndex + 1}.webp",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Container(
                                              margin: EdgeInsets.all(
                                                  screenWidth * 0.04),
                                              child: const Text(
                                                "Random Images",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          if (view_model.user.quotesTheme == 0)
                                            Align(
                                                alignment: Alignment.topRight,
                                                child: ScalableIconWidget(
                                                  screenWidth: screenWidth,
                                                  iconColor:
                                                      all_color[theme_selected]
                                                          [0],
                                                )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: screenWidth * 0.02,
                                        horizontal: screenWidth * 0.075),
                                    child: Text(
                                      "Still images",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * 0.1,
                                          fontFamily: "Second",
                                          color:
                                              Colors.black.withOpacity(0.05)),
                                    ),
                                  ),
                                  Expanded(
                                    child: GridView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.075,
                                        //vertical: screenWidth * 0.075,
                                      ),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: screenWidth * 0.025,
                                        mainAxisSpacing: screenWidth * 0.025,
                                        childAspectRatio: 0.75,
                                      ),
                                      itemCount: 13,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            view_model
                                                .change_wallpaper(index + 1);
                                          },
                                          child: Container(
                                            child: Stack(children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        screenWidth * 0.025),
                                                child: Image.asset(
                                                  "assets/quote_backgrounds/thumbnails/${index + 1}.png",
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                decoration: BoxDecoration(
                                                    color: all_color[
                                                            theme_selected][0]
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      screenWidth * 0.02,
                                                    )),
                                              ),
                                              if (view_model.user.quotesTheme ==
                                                  index + 1)
                                                Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child:

                                                        // Container(
                                                        //   margin: EdgeInsets.all(
                                                        //       screenWidth * 0.02),
                                                        //   width: screenWidth * 0.075,
                                                        //   height: screenWidth * 0.075,
                                                        //   decoration: BoxDecoration(
                                                        //       color: Colors.white,
                                                        //       borderRadius:
                                                        //           BorderRadius
                                                        //               .circular(
                                                        //         screenWidth * 0.02,
                                                        //       )),
                                                        //   child: Icon(
                                                        //     Icons.check,
                                                        //     color: all_color[
                                                        //         theme_selected][0],
                                                        //   ),
                                                        // ),

                                                        ScalableIconWidget(
                                                      screenWidth: screenWidth,
                                                      iconColor: all_color[
                                                          theme_selected][0],
                                                    )),
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Container(
                                                  margin: EdgeInsets.all(
                                                      screenWidth * 0.02),
                                                  child: Text(
                                                    "#${index + 1}",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ),
                                        );
                                      },
                                    ),
                                  )
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
