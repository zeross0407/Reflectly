import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/theme/color.dart';
import 'package:myrefectly/views/share_component/text.dart';

class CardReminder extends StatefulWidget {
  final double timeReminder;
  final ValueChanged<double> onTimeReminderChange;
  final String iconToggle;
  final String iconBackground;
  final String title;
  final String status;
  final bool val;
  final ValueChanged<bool> onChanged;
  final double fontSize;

  const CardReminder({
    Key? key,
    required this.timeReminder,
    required this.onTimeReminderChange,
    required this.iconToggle,
    required this.iconBackground,
    required this.title,
    required this.status,
    required this.val,
    required this.onChanged,
    required this.fontSize,
  }) : super(key: key);

  @override
  _CardReminderState createState() => _CardReminderState();
}

class _CardReminderState extends State<CardReminder> {
  late double _timeReminder;
  late bool _isEnabled;

  @override
  void initState() {
    super.initState();
    _timeReminder = widget.timeReminder;
    _isEnabled = widget.val;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return AnimatedContainer(
      height: _isEnabled ? 170 : 100,
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
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.fontSize,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text_intro(
                        text: widget.status,
                        color: is_darkmode ? Colors.white : Colors.black,
                        fontsize: widget.fontSize,
                      ),
                      SizedBox(
                        height: widget.fontSize * 0.1,
                      ),
                      text_intro(
                        text: widget.title,
                        color: const Color.fromARGB(255, 154, 154, 154),
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
                      colorFilter: const ColorFilter.mode(
                        Color.fromARGB(19, 193, 193, 193),
                        BlendMode.srcIn,
                      ),
                    ),
                    Center(
                      child: Switch(
                        trackColor: WidgetStatePropertyAll<Color?>(
                            all_color[theme_selected][0]),
                        thumbColor:
                            const WidgetStatePropertyAll<Color?>(Colors.white),
                        value: _isEnabled,
                        onChanged: (value) {
                          setState(() {
                            _isEnabled = value;
                          });
                          widget.onChanged(value);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (_isEnabled)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widget.fontSize),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: screenWidth * 0.25,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatTime(getDateTimeFromDouble(_timeReminder)),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: widget.fontSize*0.9,
                              color: is_darkmode
                                  ? Colors.white
                                  : Colors.black.withOpacity(0.5),
                            ),
                          ),
                          Text(
                            "EVENING",
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
                    Slider(
                      activeColor: all_color[theme_selected][0],
                      inactiveColor:
                          all_color[theme_selected][0].withOpacity(0.25),
                      min: 0,
                      max: 96,
                      value: _timeReminder,
                      onChanged: (value) {
                        setState(() {
                          _timeReminder = value;
                        });
                        widget.onTimeReminderChange(value);
                      },
                    ),
                  ],
                ),
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
    DateTime baseTime = DateTime(0, 1, 1, 16, 0);

    // Mỗi `index` tăng 5 phút, vì vậy ta nhân với 5 để tính số phút cần cộng thêm
    int minutesToAdd = (index * 5).toInt();

    // Cộng số phút vào thời gian bắt đầu
    return baseTime.add(Duration(minutes: minutesToAdd));
  }

  double getIndexFromDateTime(DateTime dateTime) {
    // Giờ bắt đầu là 16:00 ngày 1 tháng 1 năm 0000
    DateTime baseTime = DateTime(0, 1, 1, 16, 0);

    // Tính khoảng cách thời gian từ `baseTime` đến `dateTime`
    int minutesDifference = dateTime.difference(baseTime).inMinutes;

    // Chia cho 5 để lấy `index`, vì mỗi đơn vị cách nhau 5 phút
    return minutesDifference / 5;
  }
}
