import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/help/route.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/models/entry.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:myrefectly/repository/sync.dart';
import 'package:myrefectly/share/button.dart';
import 'package:myrefectly/theme/color.dart';
import 'package:myrefectly/views/entries/entries_viewmodel.dart';
import 'package:myrefectly/views/navigation/navigation_viewmodel.dart';
import 'package:myrefectly/views/challenge/edit_daily_challenge.dart';
import 'package:myrefectly/views/entries/list_photo_viewer.dart';
import 'package:myrefectly/views/mood_checkin/edit_mood_checkin.dart';
import 'package:myrefectly/views/share_reflection/edit_reflection.dart';
import 'package:myrefectly/views/voice_note/edit_voice_note.dart';
import 'package:provider/provider.dart';

class Entry_content extends StatefulWidget {
  final Repository<String, Entry> repo;
  final Entries_Viewmodel entries_viewmodel;
  final VoidCallback? onLongPress;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  dynamic entry;
  final VoidCallback onDelete;
  Entry_content({
    super.key,
    this.onLongPress,
    this.onPressed,
    this.padding,
    this.margin,
    required this.entry,
    required this.repo,
    required this.entries_viewmodel,
    required this.onDelete,
  });
  @override
  State<StatefulWidget> createState() => Entry_content_State();
}

class Entry_content_State extends State<Entry_content>
    with TickerProviderStateMixin {
  late Animation _animation;
  late AnimationController _animationcontroller;
  late SlidableController contr;
  late Entry entry;
  int img = 1;

  @override
  void initState() {
    super.initState();
    contr = SlidableController(this);
    _animationcontroller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _animation = Tween(begin: 1.0, end: 0.9).animate(_animationcontroller);
    entry = widget.entry;
    if (entry is User_reflection) {
      get_img_header();
    }
  }

  Future<void> get_img_header() async {
    Repository<String, Reflection> _reflection_repo;
    _reflection_repo =
        await Repository<String, Reflection>(name: 'reflection_box');
    await _reflection_repo.init();
    img = (await _reflection_repo
            .getById((entry as User_reflection).reflection_id))
        .category;
    setState(() {});
  }

  @override
  void dispose() {
    _animationcontroller.dispose();
    super.dispose();
  }

  // Hàm mở AlertDialog với hiệu ứng
  void _showAlert(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true, // Đóng khi chạm ra ngoài hộp thoại
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "ARE YOU SURE?",
            style: TextStyle(
                fontFamily: "Google",
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth_Global * 0.04),
            textAlign: TextAlign.center,
          ),
          content: Text(
            "If you delete this\nits cannot bring back",
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Google"),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.close)),
            SizedBox(
              width: screenWidth_Global * 0.1,
            ),
            GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  contr.close();
                  Future.delayed(
                    Duration(milliseconds: 300),
                    () async {
                      Provider.of<Navigation_viewmodel>(context, listen: false)
                          .hidden_nav(-1);
                      await widget.entries_viewmodel.delete_entry(
                          entry.UUID,
                          entry is MoodCheckin
                              ? CollectionEnum.MoodCheckin
                              : entry is User_reflection
                                  ? CollectionEnum.ShareReflection
                                  : entry is User_Challenge
                                      ? CollectionEnum.DailyChallenge
                                      : entry is Photo
                                          ? CollectionEnum.Photo
                                          : CollectionEnum.VoiceNote);
                      widget.onDelete();
                    },
                  );
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

  bool is_tapping = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onLongPress: () {
        _animationcontroller.forward();
        //widget.onLongPress!();
        Future.delayed(
          const Duration(milliseconds: 200),
          () {
            contr.openEndActionPane();
          },
        );
      },
      onLongPressEnd: (details) => {_animationcontroller.reverse()},
      child: Slidable(
        controller: contr,
        endActionPane: ActionPane(
          openThreshold: 0.1,
          closeThreshold: 0.1,
          extentRatio: 0.4,
          motion: const ScrollMotion(),
          children: [
            CustomElement(
                onTap: () async {
                  if (entry is User_Challenge) {
                    await Navigator.push(
                        context,
                        Slide_up_Route(
                            secondPage:
                                Daily_Challange_Update_Page(id: entry.UUID)));
                  } else if (entry is MoodCheckin) {
                    await Navigator.push(
                        context,
                        Slide_up_Route(
                            secondPage: Edit_Mood_Checkin(entry.UUID)));
                  } else if (entry is User_reflection) {
                    await Navigator.push(
                        context,
                        Slide_up_Route(
                            secondPage: Edit_Reflection_Page(
                          UUID: entry.UUID,
                        )));
                  } else if (entry is VoiceNote) {
                    await Navigator.push(
                        context,
                        Slide_up_Route(
                            secondPage: Edit_VoiceNote(
                          entry.UUID,
                        )));
                  }
                  entry = await widget.entries_viewmodel.entry_repo
                      .getById(entry.UUID);
                  setState(() {});
                  contr.close();
                  Provider.of<Navigation_viewmodel>(context, listen: false)
                      .hidden_nav(-1);
                },
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                      color: Colors.white),
                  child: SvgPicture.asset(
                    "assets/ico/edit.svg",
                    width: screenWidth * 0.065,
                  ),
                )),
            SizedBox(
              width: screenWidth * 0.025,
            ),
            CustomElement(
                onTap: () {
                  _showAlert(context);
                },
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                      color: const Color.fromARGB(255, 207, 91, 83)),
                  child: SvgPicture.asset(
                    "assets/ico/trash.svg",
                    width: screenWidth * 0.065,
                    colorFilter:
                        ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ))
          ],
        ),
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) => Transform.scale(
              scale: _animation.value,
              child: Container(
                margin: widget.margin,
                padding: widget.padding,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(screenWidth_Global * 0.05),
                    color: is_darkmode ? card_dark : Colors.white,
                    boxShadow: my_shadow),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
/////////////////////////////////////////////////////////////////////////////////////////////
                    header(context),
/////////////////////////////////////////////////////////////////////////////////////////////
                    if (entry is VoiceNote)
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: screenWidth * 0.03),
                          child: Text(
                            (entry as VoiceNote).description,
                            style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                fontFamily: "Google",
                                fontWeight: FontWeight.w200,
                                color:
                                    is_darkmode ? Colors.white : Colors.black),
                          )),
                    if (entry is User_Challenge)
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: screenWidth * 0.03),
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            text: 'Today I will ',
                            style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontFamily: "Google",
                                color:
                                    is_darkmode ? Colors.white : Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: (entry as User_Challenge).description,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    if (entry is MoodCheckin &&
                        ((entry as MoodCheckin).description ?? "").length > 0)
                      Padding(
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        child: Text(
                          (entry as MoodCheckin).description ?? "",
                          style: TextStyle(
                              color: is_darkmode ? Colors.white : Colors.black,
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w200),
                        ),
                      ),
                    if (entry is User_reflection)
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: screenWidth * 0.03),
                          child: reflection_text(
                              (entry as User_reflection).reflection,
                              screenWidth * 0.04)),
                    if (entry is MoodCheckin)
                      Wrap(
                        spacing:
                            8.0, // Khoảng cách giữa các phần tử theo chiều ngang
                        runSpacing:
                            0, // Khoảng cách giữa các hàng khi xuống dòng
                        children: List.generate(
                          ((entry as MoodCheckin).activities.length +
                              (entry as MoodCheckin).feelings.length),
                          (index) {
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: screenWidth * 0.01),
                              padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: screenWidth * 0.025,
                                  vertical: screenWidth * 0.015),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    screenWidth_Global * 0.02),
                                color: Colors.black.withOpacity(0.025),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize
                                    .min, // Đảm bảo Row chỉ bao quanh phần tử con
                                children: [
                                  SvgPicture.asset(
                                    index <
                                            (entry as MoodCheckin)
                                                .activities
                                                .length
                                        ? icon_url(widget
                                            .entries_viewmodel
                                            .map_activity[(entry as MoodCheckin)
                                                .activities[index]]!
                                            .icon)
                                        : icon_url(widget
                                            .entries_viewmodel
                                            .map_feeling[(entry as MoodCheckin)
                                                    .feelings[
                                                index -
                                                    (entry as MoodCheckin)
                                                        .activities
                                                        .length]]!
                                            .icon),
                                    colorFilter: ColorFilter.mode(
                                        is_darkmode
                                            ? Colors.white.withOpacity(0.5)
                                            : Colors.black.withOpacity(0.3),
                                        BlendMode.srcIn),
                                    height: screenWidth * 0.04,
                                  ),
                                  SizedBox(
                                      width: screenWidth *
                                          0.025), // Khoảng cách giữa icon và text
                                  Text(
                                    index <
                                            (entry as MoodCheckin)
                                                .activities
                                                .length
                                        ? widget
                                            .entries_viewmodel
                                            .map_activity[(entry as MoodCheckin)
                                                .activities[index]]!
                                            .title
                                        : widget
                                            .entries_viewmodel
                                            .map_feeling[(entry as MoodCheckin)
                                                    .feelings[
                                                index -
                                                    (entry as MoodCheckin)
                                                        .activities
                                                        .length]]!
                                            .title,
                                    style: TextStyle(
                                      color: is_darkmode
                                          ? Colors.white.withOpacity(0.5)
                                          : Colors.black.withOpacity(0.3),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    if (entry is User_Challenge || entry is Photo)
                      SizedBox(
                        height: screenWidth * 0.03,
                      ),
                    if (entry is Photo)
                      ListPhotoViewer(
                        photos: ["${(entry as Photo).UUID}.png"],
                        route: true,
                      ),
                    if (entry is User_Challenge)
                      ListPhotoViewer(
                        photos: (entry as User_Challenge).photos,
                        route: true,
                      ),
                    if (entry is User_reflection &&
                        (entry as User_reflection).photos.length > 0)
                      ListPhotoViewer(
                        photos: (entry as User_reflection).photos,
                        route: true,
                      ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  RichText reflection_text(String text, double fontsize) {
    // Biểu thức regex để tìm chuỗi giữa các dấu ##
    final regex = RegExp(r'#([^#]+)#');
    final matches = regex.allMatches(text);

    // Khởi tạo danh sách các đoạn text và phần in đậm
    List<TextSpan> spans = [];
    int start = 0;

    for (var match in matches) {
      // Thêm phần trước dấu ##
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }

      // Thêm phần giữa dấu ## và in đậm
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));

      // Cập nhật vị trí bắt đầu cho đoạn tiếp theo
      start = match.end;
    }

    // Thêm phần còn lại sau cùng
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(
            fontSize: fontsize,
            color: is_darkmode ? Colors.white : Colors.black,
            fontFamily: "Google"), // Định dạng chung
        children: spans,
      ),
    );
  }

  Widget header(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    // Hàm tiện ích để trả về nội dung bên trong ClipOval
    Widget _getEntryContent() {
      if (entry is User_Challenge) {
        return Image.asset(
          "assets/timeline_avatars/timeline_challenge_completed.png",
          fit: BoxFit.cover,
        );
      } else if (entry is MoodCheckin) {
        return Padding(
          padding: const EdgeInsets.all(4),
          child: SvgPicture.asset(
            mood[(entry as MoodCheckin).mood.toInt()]!,
            colorFilter: ColorFilter.mode(
              is_darkmode
                  ? Colors.white.withOpacity(0.7)
                  : Colors.black.withOpacity(0.5),
              BlendMode.srcIn,
            ),
          ),
        );
      } else if (entry is Photo || entry is VoiceNote) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: SvgPicture.asset(
            entry is Photo ? "assets/ico/photo.svg" : "assets/img/activity.svg",
            colorFilter: ColorFilter.mode(
              is_darkmode
                  ? Colors.white.withOpacity(0.75)
                  : Colors.black.withOpacity(0.5),
              BlendMode.srcIn,
            ),
          ),
        );
      } else {
        return Image.asset(
          "assets/completion_topic_avatars/(${img}).png",
          fit: BoxFit.cover,
        );
      }
    }

    // Hàm tiện ích để lấy tiêu đề
    String _getTitle() {
      if (entry is User_Challenge) {
        return "Daily Challenge";
      } else if (entry is MoodCheckin) {
        final moodEntry = entry as MoodCheckin;
        return moodEntry.title.isNotEmpty
            ? moodEntry.title.substring(0,
                    moodEntry.title.length > 25 ? 25 : moodEntry.title.length) +
                (moodEntry.title.length > 25 ? '...' : '')
            : mood_title[moodEntry.mood.toInt()];
      } else if (entry is Photo) {
        return "Photo";
      } else if (entry is VoiceNote) {
        final voiceEntry = entry as VoiceNote;
        return voiceEntry.title.isNotEmpty ? voiceEntry.title : "VoiceNote";
      } else {
        return "Daily Reflection";
      }
    }

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: entry is User_Challenge
                ? all_color[theme_selected][0]
                : is_darkmode
                    ? Colors.white.withOpacity(0.1)
                    : const Color.fromARGB(255, 242, 242, 242),
            border: Border.all(
              color: is_darkmode ? Colors.transparent : Colors.white,
              width: 3,
            ),
            boxShadow: [
              if (!is_darkmode)
                BoxShadow(
                  color: const Color.fromARGB(47, 210, 210, 210),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: ClipOval(
            child: _getEntryContent(),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getTitle(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: is_darkmode ? Colors.white : Colors.black,
              ),
            ),
            Text(
              "${hours_format(entry.submitTime)}",
              style: TextStyle(
                color: is_darkmode
                    ? Colors.white.withOpacity(0.5)
                    : Colors.black.withOpacity(0.5),
                fontSize: screenWidth * 0.03,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
