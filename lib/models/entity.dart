import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'entity.g.dart'; // Đảm bảo file này đã được tạo bằng `flutter packages pub run build_runner build`

@HiveType(typeId: 7)
@JsonSerializable()
class Activity extends HiveObject {
  @HiveField(0)
  final String UUID;

  @HiveField(1)
  final int icon;

  @HiveField(2)
  final String title;

  @HiveField(3)
  bool archive = false;

  Activity(
      {required this.UUID,
      required this.icon,
      required this.title,
      required this.archive});

  // Tạo phương thức toJson và fromJson
  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityToJson(this);
}

@HiveType(typeId: 8) // TypeId đặt là 111 hoặc một số khác nếu 111 đã dùng
@JsonSerializable()
class Feeling extends HiveObject {
  @HiveField(0)
  final String UUID;

  @HiveField(1)
  final int icon;

  @HiveField(2)
  final String title;

  @HiveField(3)
  bool archive = false;

  Feeling(
      {required this.UUID,
      required this.icon,
      required this.title,
      required this.archive});

  // Phương thức để chuyển từ JSON sang Feeling
  factory Feeling.fromJson(Map<String, dynamic> json) =>
      _$FeelingFromJson(json);

  // Phương thức để chuyển từ Feeling sang JSON
  Map<String, dynamic> toJson() => _$FeelingToJson(this);
}

@HiveType(typeId: 9) // Đặt typeId cho class Quotes
class Quote {
  @HiveField(0)
  String id;

  @HiveField(1)
  String content;

  @HiveField(2)
  String categoryId;

  @HiveField(3)
  bool like;

  @HiveField(4)
  String author;

  Quote({
    required this.id,
    required this.content,
    required this.categoryId,
    required this.like,
    required this.author,
  });
}

@HiveType(typeId: 10) // Đảm bảo typeId là duy nhất
@JsonSerializable() // Thêm annotation để hỗ trợ JSON
class Challenge extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String description;

  Challenge({
    required this.id,
    required this.description,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] ?? '', // Nếu json['id'] là null, gán là chuỗi rỗng
      description: json['description'] ??
          '', // Nếu json['description'] là null, gán là chuỗi rỗng
    );
  }

  Map<String, dynamic> toJson() => _$ChallengeToJson(this);
}

@HiveType(typeId: 11)
@JsonSerializable()
class Reflection extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String description;

  @HiveField(2)
  int category;

  Reflection(
      {required this.id, required this.description, required this.category});

  factory Reflection.fromJson(Map<String, dynamic> json) =>
      _$ReflectionFromJson(json);

  Map<String, dynamic> toJson() => _$ReflectionToJson(this);
}

@HiveType(typeId: 12)
@JsonSerializable()
class User extends HiveObject {
  @HiveField(0)
  String user_name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String? avatar;

  @HiveField(3)
  String refresh_token;

  @HiveField(4)
  int quotesTheme;

  @HiveField(5)
  bool darkmode;

  @HiveField(6)
  bool passcode;

  @HiveField(7)
  bool checkin_reminder;

  @HiveField(8)
  bool possitive_reminder;

  @HiveField(9)
  int theme_color;

  @HiveField(10)
  int quote_category;

  @HiveField(11)
  List<String> quote_hearted;

  @HiveField(12)
  DateTime time_checkin_reminder;

  @HiveField(13)
  int count_positivity_reminder;

  @HiveField(14)
  DateTime start_positivity_reminder;

  @HiveField(15)
  DateTime end_positivity_reminder;

  @HiveField(16)
  String access_token;

  User(
      {required this.end_positivity_reminder,
      required this.start_positivity_reminder,
      required this.count_positivity_reminder,
      required this.time_checkin_reminder,
      required this.user_name,
      required this.email,
      this.avatar,
      required this.refresh_token,
      required this.quotesTheme,
      required this.darkmode,
      required this.passcode,
      required this.checkin_reminder,
      required this.possitive_reminder,
      required this.theme_color,
      required this.quote_category,
      required this.quote_hearted,
      required this.access_token});

  // Phương thức chuyển đổi từ JSON sang User object
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  // Phương thức chuyển đổi từ User object sang JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable() // Sử dụng JsonSerializable
@HiveType(typeId: 13)
class Data_Sync extends HiveObject {
  @HiveField(0)
  int name;

  @HiveField(1)
  int action;

  @HiveField(2)
  String jsonData;

  @HiveField(3)
  DateTime timeStamp;

  @HiveField(4)
  String id;

  Data_Sync(
      {required this.name,
      required this.action,
      required this.jsonData,
      required this.timeStamp,
      required this.id});

  // Chuyển đổi Entry_Sync thành Map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'action': action,
      'json_data': jsonData,
      'timeStamp': timeStamp.toIso8601String(),
    };
  }
}

@HiveType(typeId: 14)
class HomeModel extends HiveObject {
  @HiveField(0)
  Challenge? todayChallenge;

  @HiveField(1)
  List<Reflection> weeklyReflection;

  @HiveField(2)
  List<Quote> weeklyQuote;

  @HiveField(3)
  List<bool> completeCheckin;

  @HiveField(4)
  List<bool> reflectionShared;

  @HiveField(5)
  DateTime start;

  @HiveField(6)
  List<int> challenge_completed;

  HomeModel(
      {required this.todayChallenge,
      required this.weeklyReflection,
      required this.weeklyQuote,
      required this.completeCheckin,
      required this.reflectionShared,
      required this.start,
      required this.challenge_completed});
}
