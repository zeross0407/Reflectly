import 'package:flutter/material.dart';
import 'package:flutter_multi_slider/flutter_multi_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/theme/color.dart';
import 'package:myrefectly/views/share_component/text.dart';

class CardPosiReminder extends StatefulWidget {
  final int countReminder;
  final Function(int val) countReminderChanged;
  final DateTime timeReminder;
  final String iconToggle;
  final String iconBackground;
  final String title;
  final String status;
  final bool val;
  final ValueChanged<bool> onChanged;
  final double fontSize;
  DateTime time_start;
  DateTime time_end;
  final Function(DateTime st, DateTime end) on_time_change;
  CardPosiReminder({
    required this.time_end,
    required this.time_start,
    required this.countReminder,
    required this.countReminderChanged,
    required this.timeReminder,
    required this.iconToggle,
    required this.iconBackground,
    required this.title,
    required this.status,
    required this.val,
    required this.onChanged,
    required this.fontSize,
    required this.on_time_change,
  });

  @override
  _CardPosiReminderState createState() => _CardPosiReminderState();
}

class _CardPosiReminderState extends State<CardPosiReminder> {
  late int countReminder;
  late bool isExpanded;
  double start_at = 0;
  double end_at = 0;

  @override
  void initState() {
    super.initState();
    start_at = getIndexFromDateTime(widget.time_start);
    end_at = getIndexFromDateTime(widget.time_end);
    countReminder = widget.countReminder;
    isExpanded = widget.val;
  }

  void _incrementReminder() {
    if (countReminder >= 20) return;
    setState(() {
      countReminder++;
    });
    widget.countReminderChanged(countReminder);
  }

  void _decrementReminder() {
    setState(() {
      if (countReminder > 0) countReminder--;
    });
    widget.countReminderChanged(countReminder);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return AnimatedContainer(
      height: isExpanded ? 270 : 100,
      duration: Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: is_darkmode ? card_dark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: my_shadow,
      ),
      child: ClipRRect(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widget.fontSize),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text_intro(
                        text: widget.status,
                        color: is_darkmode ? Colors.white : Colors.black,
                        fontsize: widget.fontSize,
                      ),
                      SizedBox(height: widget.fontSize * 0.1),
                      text_intro(
                        text: widget.title,
                        color: Color.fromARGB(255, 154, 154, 154),
                        fontsize: widget.fontSize * 0.75,
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container()),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      widget.iconBackground,
                      height: 100,
                      colorFilter: ColorFilter.mode(
                          Color.fromARGB(19, 193, 193, 193), BlendMode.srcIn),
                    ),
                    Center(
                      child: Switch(
                        trackColor: WidgetStatePropertyAll<Color?>(
                            all_color[theme_selected][0]),
                        thumbColor:
                            WidgetStatePropertyAll<Color?>(Colors.white),
                        value: isExpanded,
                        onChanged: (val) {
                          setState(() {
                            isExpanded = val;
                          });
                          widget.onChanged(val);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (isExpanded)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: widget.fontSize),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatTime(getDateTimeFromDouble(start_at)),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: widget.fontSize,
                              color: is_darkmode
                                  ? Colors.white
                                  : Colors.black.withOpacity(0.5)),
                        ),
                        Text(
                          "START AT",
                          style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            fontWeight: FontWeight.bold,
                            color: is_darkmode
                                ? Colors.white.withOpacity(0.5)
                                : Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: Container()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: widget.fontSize),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatTime(getDateTimeFromDouble(end_at)),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: widget.fontSize,
                              color: is_darkmode
                                  ? Colors.white
                                  : Colors.black.withOpacity(0.5)),
                        ),
                        Text(
                          "END AT",
                          style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            fontWeight: FontWeight.bold,
                            color: is_darkmode
                                ? Colors.white.withOpacity(0.5)
                                : Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            if (isExpanded)
              MultiSlider(
                selectedIndicator: (value) => IndicatorOptions(draw: false),
                min: 0,
                max: 228,
                color: all_color[theme_selected][0],
                values: [start_at, end_at],
                onChanged: (values) => setState(() {
                  start_at = values[0];
                  end_at = values[1];
                  widget.time_start = getDateTimeFromDouble(values[0]);
                  widget.time_end = getDateTimeFromDouble(values[1]);
                  widget.on_time_change(widget.time_start, widget.time_end);
                }),
              ),
            if (isExpanded)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: widget.fontSize),
                    child: GestureDetector(
                      onTap: _decrementReminder,
                      child: Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.remove,
                            color: is_darkmode
                                ? Colors.white
                                : Colors.black.withOpacity(0.5)),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "$countReminder x",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: widget.fontSize,
                            color: is_darkmode
                                ? Colors.white
                                : Colors.black.withOpacity(0.5)),
                      ),
                      Text(
                        "REMINDERS",
                        style: TextStyle(
                            color: is_darkmode
                                ? Colors.white
                                : Colors.black.withOpacity(0.5)),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: widget.fontSize),
                    child: GestureDetector(
                      onTap: _incrementReminder,
                      child: Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.add,
                            color: is_darkmode
                                ? Colors.white
                                : Colors.black.withOpacity(0.5)),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
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
    DateTime baseTime = DateTime(0, 1, 1, 5, 0);

    // Mỗi `index` tăng 5 phút, vì vậy ta nhân với 5 để tính số phút cần cộng thêm
    int minutesToAdd = (index * 5).toInt();

    // Cộng số phút vào thời gian bắt đầu
    return baseTime.add(Duration(minutes: minutesToAdd));
  }

  double getIndexFromDateTime(DateTime dateTime) {
    // Giờ bắt đầu là 16:00 ngày 1 tháng 1 năm 0000
    DateTime baseTime = DateTime(0, 1, 1, 5, 0);

    // Tính khoảng cách thời gian từ `baseTime` đến `dateTime`
    int minutesDifference = dateTime.difference(baseTime).inMinutes;

    // Chia cho 5 để lấy `index`, vì mỗi đơn vị cách nhau 5 phút
    return minutesDifference / 5;
  }
}
