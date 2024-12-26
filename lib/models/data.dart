import 'package:myrefectly/models/entity.dart';

Map<int, String> mood = {
  0: "assets/mood/m (1).svg",
  1: "assets/mood/m (2).svg",
  2: "assets/mood/m (3).svg",
  3: "assets/mood/m (4).svg",
  4: "assets/mood/m (5).svg"
};

List<String> mood_title = [
  "REALLY TERRIBLE",
  "SOMEWHAT BAD",
  "COMPLETELY OKAY",
  "PRETTY GOOD",
  "SUPER AWSOME"
];

Map<int, String> month = {
  1: "JAN",
  2: "FEB",
  3: "MAR",
  4: "APR",
  5: "MAY",
  6: "JUN",
  7: "JUL",
  8: "AUG",
  9: "SEP",
  10: "OCT",
  11: "NOV",
  12: "DEC",
};

Map<int, String> fullMonth = {
  1: "January",
  2: "February",
  3: "March",
  4: "April",
  5: "May",
  6: "June",
  7: "July",
  8: "August",
  9: "September",
  10: "October",
  11: "November",
  12: "December",
};

Map<int, String> weekday = {
  1: "Monday",
  2: "Tuesday",
  3: "Wednesday",
  4: "Thursday",
  5: "Friday",
  6: "Saturday",
  7: "Sunday",
};

List<String> day = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

Map<int, String> reflection = {
  1: "Mindfulness",
  2: "Truth",
  3: "Wisdom",
  4: "Identity",
  5: "Favorites",
  6: "Celebration",
  7: "Gratitude",
};

Map<int, String> reflection_content = {
  1: "Every Monday, find presence and focus",
  2: "Every Tuesday, speak your truth",
  3: "Every Wednesday, open your mind",
  4: "Every Thursday, reflect on who you are",
  5: "Every Friday, share your favorite things",
  6: "Every Saturday, celebrate the small things",
  7: "Every Sunday, practice thankfulness",
};

final List<Activity> activities_list_default = List.unmodifiable([
  Activity(UUID: "0", icon: 30, title: "weather", archive: false),
  Activity(UUID: "1", icon: 12, title: "work", archive: false),
  Activity(UUID: "2", icon: 13, title: "achievement", archive: false),
  Activity(UUID: "3", icon: 34, title: "candy", archive: false),
  Activity(UUID: "4", icon: 35, title: "gaming", archive: false),
  Activity(UUID: "5", icon: 16, title: "schedule", archive: false),
  Activity(UUID: "6", icon: 37, title: "pancake", archive: false),
  Activity(UUID: "7", icon: 38, title: "bread", archive: false),
]);

final List<Feeling> feelings_list_default = List.unmodifiable([
  Feeling(UUID: "0", icon: 2, title: "happy", archive: false),
  Feeling(UUID: "1", icon: 3, title: "confused", archive: false),
  Feeling(UUID: "2", icon: 6, title: "down", archive: false),
  Feeling(UUID: "3", icon: 67, title: "angry", archive: false),
  Feeling(UUID: "4", icon: 26, title: "awkward", archive: false),
]);
String icon_url(int id) {
  return "assets/all/($id).svg";
}

String get_time_str(DateTime time) {
  return (time.hour >= 6 && time.hour <= 12)
      ? "morning"
      : (time.hour >= 12 && time.hour <= 18)
          ? "afternoon"
          : (time.hour >= 18 && time.hour <= 21)
              ? "evening"
              : (time.hour >= 21)
                  ? "night"
                  : "day";
}

String get_full_time_string(DateTime dateTime) {
  // Danh sách các tháng để lấy tên tháng dưới dạng chữ
  const List<String> months = [
    'JANUARY',
    'FEBRUARY',
    'MARCH',
    'APRIL',
    'MAY',
    'JUNE',
    'JULY',
    'AUGUST',
    'SEPTEMBER',
    'OCTOBER',
    'NOVEMBER',
    'DECEMBER'
  ];

  // Lấy tên tháng từ danh sách
  String month = months[dateTime.month - 1];
  String day = dateTime.day.toString();
  String hour = (dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12).toString();
  String minute = dateTime.minute.toString().padLeft(2, '0');
  String period = dateTime.hour >= 12 ? 'PM' : 'AM';

  // Trả về chuỗi định dạng yêu cầu
  return '$month $day - $hour:$minute $period';
}

String hours_format(DateTime dateTime) {
  int hour = dateTime.hour;
  int minute = dateTime.minute;
  String period = hour >= 12 ? "P.M" : "A.M";

  // Định dạng giờ thành 12-hour format
  hour = hour % 12;
  hour = hour == 0 ? 12 : hour; // Chuyển 0 thành 12 cho 12-hour format

  // Định dạng phút
  String minuteStr = minute.toString().padLeft(2, '0');

  return "${hour.toString().padLeft(2, '0')}:$minuteStr $period";
}

String get_reflection_desc(String? s) {
  if (s == null) return "ERROR";
  return s.replaceFirst("##", "________");
}

String timeDifference(DateTime start, DateTime end) {
  Duration difference = end.difference(start);

  if (difference.inDays >= 1) {
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''}';
  } else {
    int hours = difference.inHours;
    int minutes = difference.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}

List<String> all_category() {
  return [
    "General",
    "Favorites",
    "Sadness",
    "Heart Broken",
    "Loneliness",
    "Breakup",
    "Letting Go",
    "Depression",
    "Mood Disorder",
    "Dealing with anxiety",
    "Addiction Disorder",
    "Success",
    "Focus",
    "Study",
    "Before a test",
  ];
}

String server_root_url = "https://d628-2001-ee0-227-b567-fc0b-e1a7-b2b0-5ca6.ngrok-free.app";

bool isHiveInitialized = false;
