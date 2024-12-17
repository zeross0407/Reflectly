import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entry.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Entry {
  @HiveField(0)
  String UUID;

  @HiveField(1)
  DateTime submitTime;

  Entry({
    required this.UUID,
    required this.submitTime,
  });
}

@HiveType(typeId: 1)
@JsonSerializable()
class MoodCheckin extends Entry {
  @HiveField(2)
  String? description;

  @HiveField(3)
  double mood;

  @HiveField(4)
  List<String> activities;

  @HiveField(5)
  List<String> feelings;

  @HiveField(6)
  String title;

  MoodCheckin({
    required String UUID,
    required DateTime submitTime,
    required this.title,
    required this.mood,
    required this.activities,
    required this.feelings,
    this.description,
  }) : super(UUID: UUID, submitTime: submitTime);

  factory MoodCheckin.fromJson(Map<String, dynamic> json) =>
      _$MoodCheckinFromJson(json);
  Map<String, dynamic> toJson() => _$MoodCheckinToJson(this);
}

@HiveType(typeId: 2)
@JsonSerializable()
class DailyChallenge extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  int step;

  @HiveField(2)
  String description;

  DailyChallenge({
    required this.id,
    required this.step,
    required this.description,
  });

  factory DailyChallenge.fromJson(Map<String, dynamic> json) =>
      _$DailyChallengeFromJson(json);
  Map<String, dynamic> toJson() => _$DailyChallengeToJson(this);
}

@HiveType(typeId: 3)
@JsonSerializable()
class User_Challenge extends Entry with HiveObjectMixin {
  @HiveField(2)
  String description;

  @HiveField(3)
  List<String> photos;

  @HiveField(4)
  String challenge_id;

  User_Challenge({
    required String UUID,
    required this.description,
    required DateTime submitTime,
    required this.photos,
    required this.challenge_id,
  }) : super(UUID: UUID, submitTime: submitTime);

  factory User_Challenge.fromJson(Map<String, dynamic> json) =>
      _$User_ChallengeFromJson(json);
  Map<String, dynamic> toJson() => _$User_ChallengeToJson(this);
}

@HiveType(typeId: 4)
@JsonSerializable()
class Photo extends Entry {
  Photo({
    required String UUID,
    required DateTime submitTime,
  }) : super(UUID: UUID, submitTime: submitTime);

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}

@HiveType(typeId: 5)
@JsonSerializable()
class User_reflection extends Entry {
  @HiveField(2)
  String reflection;

  @HiveField(3)
  List<String> photos;

  @HiveField(4)
  String reflection_id;

  User_reflection({
    required String UUID,
    required this.reflection,
    required DateTime submitTime,
    required this.photos,
    required this.reflection_id,
  }) : super(UUID: UUID, submitTime: submitTime);

  factory User_reflection.fromJson(Map<String, dynamic> json) =>
      _$User_reflectionFromJson(json);
  Map<String, dynamic> toJson() => _$User_reflectionToJson(this);
}

@HiveType(typeId: 6)
@JsonSerializable()
class VoiceNote extends Entry {
  @HiveField(2)
  String title;

  @HiveField(3)
  String description;

  VoiceNote({
    required String UUID,
    required this.description,
    required this.title,
    required DateTime submitTime,
  }) : super(UUID: UUID, submitTime: submitTime);

  factory VoiceNote.fromJson(Map<String, dynamic> json) =>
      _$VoiceNoteFromJson(json);
  Map<String, dynamic> toJson() => _$VoiceNoteToJson(this);
}
