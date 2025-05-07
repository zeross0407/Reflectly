import 'package:myrefectly/help/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myrefectly/help/delay_animation.dart';
import 'package:myrefectly/help/route.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/views/home/challenge_card.dart';
import 'package:myrefectly/views/home/daily_checkin_card.dart';
import 'package:myrefectly/views/home/quote_card.dart';
import 'package:myrefectly/views/home/reflection_card.dart';
import 'package:myrefectly/views/mood_checkin/checkin.dart';
import 'package:myrefectly/views/challenge/complete_challenge.dart';
import 'package:myrefectly/views/challenge/dailychallange.dart';
import 'package:myrefectly/views/share_component/reflectly_face.dart';
import 'package:myrefectly/views/share_component/text.dart';
import 'package:myrefectly/views/user/user.dart';
import 'package:myrefectly/share/button.dart';
import 'package:myrefectly/share/elementshare.dart';
import 'package:myrefectly/page_transition_animate.dart';
import 'package:myrefectly/theme/color.dart';
import 'package:myrefectly/views/home/home_viewmodel.dart';
import 'package:myrefectly/views/navigation/navigation_viewmodel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin,
        WidgetsBindingObserver {
  int _currentPage = 0;
  double _heightFactor = 0.45; // Chiều cao ban đầu
  bool build_complete = false;
  late TabController _tabController;
  late PageController _pageController;
  final ScrollController _scrollController = ScrollController();
  List<DateTime> weekDays = [];
  bool loading = true;
  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getCurrentWeekDays();
    // Thêm observer để lắng nghe sự thay đổi của vòng đời ứng dụng
    WidgetsBinding.instance.addObserver(this);
    ///////////////////
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();
    // ..addListener(() {
    //   int nextPage = _pageController.page!.round();
    //   if (_currentPage != nextPage) {
    //     setState(() {
    //       _currentPage = nextPage.toInt();
    //     });
    //   }
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _animateHeight();
      build_complete = true;
      _pageController.jumpToPage(
        DateTime.now().weekday - 1,
      );
    });
  }

  List<DateTime> getCurrentWeekDays() {
    DateTime today = DateTime.now();

    // Tính số ngày cần trừ đi để ra ngày Thứ Hai
    int mondayOffset = today.weekday - DateTime.monday;

    // Ngày Thứ Hai trong tuần hiện tại
    DateTime monday = today.subtract(Duration(days: mondayOffset));

    // Tạo danh sách các ngày trong tuần từ Thứ Hai đến Chủ Nhật
    weekDays = List.generate(7, (index) => monday.add(Duration(days: index)));

    return weekDays;
  }

  bool running = true;

  void _animateHeight() {
    setState(() {
      _heightFactor = 0.5; // Chiều cao cuối cùng
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    screenHeight_Global = MediaQuery.sizeOf(context).height;
    screenWidth_Global = MediaQuery.sizeOf(context).width;
    double paddingWidth = screenWidth * 0.08;

    return ChangeNotifierProvider<HomeViewmodel>(
        create: (context) => HomeViewmodel(),
        child: Consumer<HomeViewmodel>(builder: (context, view_model, child) {
          return Scaffold(
              backgroundColor: is_darkmode ? background_dark : background_light,
              body: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedBuilder(
                      animation: _scrollController,
                      builder: (context, child) {
                        double offset = 0;
                        if (_scrollController.hasClients) {
                          offset = _scrollController.offset;
                        }
                        return Transform.translate(
                          offset: Offset(0, -offset * 0.5),
                          child: AnimatedContainer(
                            duration: const Duration(
                                seconds: 2), // Thời gian chuyển đổi
                            curve: Curves.easeInOut, // Hiệu ứng chuyển đổi
                            height: screenHeight * _heightFactor,
                            child: ClipPath(
                              clipper: BottomCurveClipper(),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      all_color[theme_selected][0],
                                      all_color[theme_selected][1]
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: screenWidth * 126 / 1028 / 2,
                              right: screenWidth * 126 / 1028 / 2,
                              top: screenWidth * 0.05,
                              bottom: 20),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Center(child: reflectly_face()),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  DelayAnimation(
                                    delay: 100,
                                    shouldFaded: false,
                                    sliding: false,
                                    is_faded_animation: false,
                                    child: CustomElement(
                                      onTap: () async {
                                        await Navigator.of(context).push(
                                            Slide_up_Route(
                                                secondPage: const UserPage()));
                                        setState(() {});
                                        Provider.of<Navigation_viewmodel>(
                                                context,
                                                listen: false)
                                            .updateUI();
                                      },
                                      child: Container(
                                        height: screenWidth * 126 / 1028,
                                        width: screenWidth * 126 / 1028,
                                        padding:
                                            EdgeInsets.all(screenWidth * 0.03),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: const Color.fromARGB(
                                              26, 255, 255, 255),
                                        ),
                                        child: SvgPicture.asset(
                                            "assets/img/user.svg",
                                            colorFilter: const ColorFilter.mode(
                                                Colors.white, BlendMode.srcIn)),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: paddingWidth),
                          child: Row(
                            children: [
                              DelayAnimation(
                                delay: 500,
                                shouldFaded: false,
                                sliding: true,
                                is_faded_animation: true,
                                child: text_intro(
                                    text: view_model
                                                .weekDays[_currentPage].day ==
                                            view_model.currentDay.day
                                        ? "Today"
                                        : view_model.weekDays[_currentPage]
                                                    .day ==
                                                view_model.currentDay.day - 1
                                            ? "Yesterday"
                                            : view_model.weekDays[
                                                        _currentPage] ==
                                                    _currentPage + 1
                                                ? "Tomorrow"
                                                : weekday[view_model
                                                    .weekDays[_currentPage]
                                                    .weekday]!,
                                    color: Colors.white,
                                    fontsize: screenWidth_Global * 0.045),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: paddingWidth),
                          child: Row(
                            children: [
                              DelayAnimation(
                                delay: 600,
                                shouldFaded: false,
                                sliding: true,
                                is_faded_animation: true,
                                child: text_intro(
                                    text:
                                        "${weekday[view_model.weekDays[_currentPage].weekday]!.toUpperCase()}, ${fullMonth[view_model.weekDays[_currentPage].month]!.toUpperCase()} ${view_model.weekDays[_currentPage].day}",
                                    //"${weekday[_currentPage + 1]!.toUpperCase()}, ${fullMonth[weekDays[_currentPage].month]!.toUpperCase() + " " + weekDays[_currentPage].day.toString()}",
                                    color:
                                        const Color.fromARGB(198, 90, 90, 90),
                                    fontsize: screenWidth_Global * 0.03,
                                    family: "Second"),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 20),
                          child: DelayAnimation(
                            delay: 100,
                            shouldFaded: false,
                            sliding: true,
                            is_faded_animation: true,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  7,
                                  (index) => CustomElement(
                                    onTap: () {
                                      _pageController.animateToPage(index,
                                          duration:
                                              const Duration(milliseconds: 250),
                                          curve: Curves.decelerate);
                                    },
                                    child: Calendar_element(
                                        fontsize: screenWidth_Global * 0.025,
                                        dOfW: day[index],
                                        dOfM: weekDays[index],
                                        isPressing: _currentPage == index),
                                  ),
                                )),
                          ),
                        ),
                        DelayAnimation(
                          delay: 800,
                          shouldFaded: true,
                          max_siz: 0.025,
                          child: SizedBox(
                            height: 1000,
                            child: PageView.builder(
                                onPageChanged: (value) {
                                  setState(() {
                                    _currentPage = value;
                                  });
                                },
                                controller: _pageController,
                                itemCount: 7,
                                itemBuilder: (context, index) {
                                  return FadeTransitionPage(
                                    controller: _pageController,
                                    index: index,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Column(
                                        children: [
                                          Reflection_Card(
                                              view_model: view_model,
                                              index: index,
                                              weekDays: weekDays),
                                          if (DateTime.now().day ==
                                              weekDays[index].day)
                                            CustomElement(
                                              onTap: () async {
                                                if(view_model.dailyChallengeCompleted)return;
                                                if (view_model.HomeData!
                                                            .challenge_completed[
                                                        DateTime.now().weekday -
                                                            1] ==
                                                    2) return;
                                                if (view_model.HomeData!
                                                            .challenge_completed[
                                                        DateTime.now().weekday -
                                                            1] ==
                                                    1) {
                                                  await Navigator.of(context)
                                                      .push(Slide_up_Route(
                                                          secondPage:
                                                              Daily_Challange_Complete_Page()));
                                                } else {
                                                  await Navigator.of(context)
                                                      .push(Slide_up_Route(
                                                          secondPage:
                                                              Daily_Challange_Page()));
                                                }

                                                view_model.reset();
                                              },
                                              child: CardChallenge(
                                                  challenge: view_model
                                                      .HomeData?.todayChallenge,
                                                  background:
                                                      "assets/challenge_images/challenge_uncompleted.png",
                                                  height: screenHeight * 0.2,
                                                  color:
                                                      all_color[theme_selected]
                                                          [0],
                                                  child: const Text(""),
                                                  step: view_model
                                                          .dailyChallengeCompleted
                                                      ? 2
                                                      : view_model.HomeData
                                                                  ?.challenge_completed[
                                                              index] ??
                                                          0),
                                            ),
                                          if (DateTime.now().day ==
                                              weekDays[index].day)
                                            SizedBox(
                                              height: screenWidth * 0.05,
                                            ),
                                          if (view_model.HomeData != null &&
                                              !view_model
                                                  .dailyCheckInComplete &&
                                              index ==
                                                  DateTime.now().weekday - 1)
                                            DailyCheckInCard(
                                              isDarkMode: is_darkmode,
                                              screenWidth: screenWidth,
                                              allColor: all_color,
                                              themeSelected: theme_selected,
                                              myShadow: my_shadow,
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  Slide_up_Route(
                                                      secondPage: Checkin()),
                                                );
                                              },
                                            ),
                                          if ((DateTime.now()
                                              .isAfter(weekDays[index])))
                                            Quote_Card(
                                              index: index,
                                              text: view_model
                                                  .weekly_quotes[_currentPage],
                                            )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ));
        }));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);

    path.quadraticBezierTo(
        size.width / 2, size.height + 20, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
