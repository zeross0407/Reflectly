import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myrefectly/help/route.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entry.dart';
import 'package:myrefectly/views/entries/entry_card.dart';
import 'package:myrefectly/views/entries/entry_header.dart';
import 'package:myrefectly/views/user/user.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:myrefectly/share/button.dart';
import 'package:myrefectly/views/entries/entries_viewmodel.dart';
import 'package:myrefectly/views/navigation/navigation_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:myrefectly/help/color.dart';

void add_moodcheckin(BuildContext context) {
  try {
    Entries_Viewmodel? viewModel =
        Provider.of<Entries_Viewmodel>(context, listen: false);
    // Nếu tìm thấy ViewModel, thực hiện loadData
    viewModel.loadData();
  } catch (e) {
    // Nếu không tìm thấy ViewModel
    print("Lỗi: Entries_Viewmodel không tồn tại trong context. $e");
  }
}

class EntriesPage extends StatefulWidget {
  final VoidCallback onActionCompleted;

  const EntriesPage({
    super.key,
    required this.onActionCompleted,
  });

  @override
  State<EntriesPage> createState() => _EntriesPageState();
}

class _EntriesPageState extends State<EntriesPage>
    with SingleTickerProviderStateMixin {
  SlidableController? tapping;
  bool is_tapping = false;
  late SlidableController contr;
  double padding_width = 0;
  late ScrollController _scrollController;
  late Repository<int, Entry> repository;
  List<Entry> items = [];
  // Map<DateTime, List<Entry>> time_point = {};
  // List<List<Entry>> entry_point = [];
  List<dynamic> entry_points = [];

  @override
  void initState() {
    super.initState();

    contr = SlidableController(this);
    _scrollController = ScrollController()
      ..addListener(
        () {
          if (_scrollController.position.userScrollDirection ==
              ScrollDirection.reverse) {
            // Cuộn xuống
            Provider.of<Navigation_viewmodel>(context, listen: false)
                .hidden_nav(1);
          } else if (_scrollController.position.userScrollDirection ==
              ScrollDirection.forward) {
            // Cuộn lên
            Provider.of<Navigation_viewmodel>(context, listen: false)
                .hidden_nav(-1);
          }
        },
      );
  }

  // Hàm so sánh chỉ phần ngày (bỏ qua giờ, phút, giây)
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  void dispose() {
    //tapping!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    padding_width = screenWidth * 0.06;
    return Consumer<Entries_Viewmodel>(
      builder: (BuildContext context, Entries_Viewmodel view_model,
          Widget? child) {
        return view_model.isLoading == false
            ? Scaffold(
                backgroundColor:
                    is_darkmode ? background_dark : background_light,
                body: ListView.builder(
                  cacheExtent: 2000,
                  padding:
                      EdgeInsets.symmetric(vertical: screenHeight * 0.08),
                  controller: _scrollController,
                  itemCount: view_model.entryPoints.length + 2,
                  itemBuilder: (context, index) {
                    return index == 0
                        ? Padding(
                            key: ValueKey('header-$index'),
                            padding: EdgeInsets.only(
                              left: padding_width,
                              right: padding_width,
                              top: screenWidth * 0.0,
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CustomElement(
                                        onTap: () async {
                                          await Navigator.push(
                                              context,
                                              Slide_up_Route(
                                                  secondPage: UserPage()));
                                          Provider.of<Navigation_viewmodel>(
                                                  context,
                                                  listen: false)
                                              .updateUI();
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: screenWidth * 126 / 1028,
                                          width: screenWidth * 126 / 1028,
                                          padding: EdgeInsets.all(
                                              screenWidth * 0.03),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            color: is_darkmode
                                                ? Colors.white
                                                    .withOpacity(0.05)
                                                : Colors.black
                                                    .withOpacity(0.02),
                                          ),
                                          child: SvgPicture.asset(
                                              "assets/img/user.svg",
                                              colorFilter: ColorFilter.mode(
                                                  is_darkmode
                                                      ? Colors.white
                                                          .withOpacity(0.5)
                                                      : Color.fromARGB(
                                                          255, 0, 0, 0),
                                                  BlendMode.srcIn)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Your Entries",
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            75, 184, 184, 184),
                                        fontFamily: "Second",
                                        fontSize: screenWidth * 0.1,
                                        fontWeight: FontWeight.bold),
                                  )
                                ]),
                          )
                        : index == 1
                            ? EntryHeader(
                                key: ValueKey('content_header-$index'),
                                data: [
                                  view_model.count_reflection,
                                  view_model.count_checkin,
                                  view_model.count_photo
                                ],
                                paddingWidth: padding_width,
                                isDarkMode: is_darkmode)
                            : (view_model.entryPoints[index - 2] is Entry)
                                ? Entry_content(
                                    key: ValueKey(
                                        'entry-${view_model.entryPoints[index - 2].UUID}'),
                                    onDelete: () {
                                      setState(() {
                                        //print(view_model.entryPoints);
                                      });
                                    },
                                    entries_viewmodel: view_model,
                                    repo: view_model.repo,
                                    margin: EdgeInsets.only(
                                        left: padding_width,
                                        right: padding_width,
                                        bottom: padding_width),
                                    padding: EdgeInsets.all(
                                      padding_width * 0.75,
                                    ),
                                    entry: view_model.entryPoints[index - 2],
                                  )
                                : Entry_Time(
                                    key: ValueKey('entryTime-${index}'),
                                    fontsize: screenWidth * 0.04,
                                    margin: EdgeInsets.only(
                                        left: padding_width,
                                        right: padding_width,
                                        top: padding_width * 0.75,
                                        bottom: padding_width * 1.25),
                                    time: view_model.entryPoints[index - 2],
                                  );
                  },
                ),
              )
            : Container();
      },
    );
  }
}

class Entry_Time extends StatelessWidget {
  final double fontsize;
  final EdgeInsetsGeometry margin;
  final DateTime time;
  const Entry_Time(
      {super.key,
      required this.fontsize,
      required this.margin,
      required this.time});

  int calculateDateDifference(DateTime date1, DateTime date2) {
    // Lấy phần ngày, tháng, năm để so sánh
    DateTime compareDate1 = DateTime(date1.year, date1.month, date1.day);
    DateTime compareDate2 = DateTime(date2.year, date2.month, date2.day);

    int rs = compareDate1.difference(compareDate2).inDays;

    // Tính số ngày chênh lệch và trả về
    return rs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: fontsize),
            padding: EdgeInsets.symmetric(
                horizontal: fontsize * 0.7, vertical: fontsize * 0.5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: is_darkmode
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.025)),
            child: Column(
              children: [
                Text(
                  time.day.toString(),
                  style: TextStyle(
                      fontFamily: "Second",
                      fontWeight: FontWeight.bold,
                      fontSize: fontsize,
                      color: is_darkmode ? Colors.white : Colors.black),
                ),
                Text(
                  month[time.month]!,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 155, 155, 155),
                      fontSize: fontsize * 0.7),
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                weekday[time.weekday]!,
                style: TextStyle(
                    fontSize: fontsize,
                    fontWeight: FontWeight.bold,
                    color: is_darkmode ? Colors.white : Colors.black),
              ),
              Text(
                calculateDateDifference(DateTime.now(), time) == 0
                    ? "TODAY"
                    : calculateDateDifference(DateTime.now(), time) == 1
                        ? "YESTERDAY"
                        : "${calculateDateDifference(DateTime.now(), time).abs()} DAY AGO",
                style: TextStyle(
                    color: const Color.fromARGB(255, 209, 209, 209),
                    fontSize: fontsize * 0.8,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}
