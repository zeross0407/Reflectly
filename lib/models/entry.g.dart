// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EntryAdapter extends TypeAdapter<Entry> {
  @override
  final int typeId = 0;

  @override
  Entry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Entry(
      UUID: fields[0] as String,
      submitTime: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Entry obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.UUID)
      ..writeByte(1)
      ..write(obj.submitTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MoodCheckinAdapter extends TypeAdapter<MoodCheckin> {
  @override
  final int typeId = 1;

  @override
  MoodCheckin read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoodCheckin(
      UUID: fields[0] as String,
      submitTime: fields[1] as DateTime,
      title: fields[6] as String,
      mood: fields[3] as double,
      activities: (fields[4] as List).cast<String>(),
      feelings: (fields[5] as List).cast<String>(),
      description: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MoodCheckin obj) {
    writer
      ..writeByte(7)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.mood)
      ..writeByte(4)
      ..write(obj.activities)
      ..writeByte(5)
      ..write(obj.feelings)
      ..writeByte(6)
      ..write(obj.title)
      ..writeByte(0)
      ..write(obj.UUID)
      ..writeByte(1)
      ..write(obj.submitTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodCheckinAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DailyChallengeAdapter extends TypeAdapter<DailyChallenge> {
  @override
  final int typeId = 2;

  @override
  DailyChallenge read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyChallenge(
      id: fields[0] as int,
      step: fields[1] as int,
      description: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DailyChallenge obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.step)
      ..writeByte(2)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyChallengeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserChallengeAdapter extends TypeAdapter<User_Challenge> {
  @override
  final int typeId = 3;

  @override
  User_Challenge read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User_Challenge(
      UUID: fields[0] as String,
      description: fields[2] as String,
      submitTime: fields[1] as DateTime,
      photos: (fields[3] as List).cast<String>(),
      challenge_id: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User_Challenge obj) {
    writer
      ..writeByte(5)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.photos)
      ..writeByte(4)
      ..write(obj.challenge_id)
      ..writeByte(0)
      ..write(obj.UUID)
      ..writeByte(1)
      ..write(obj.submitTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserChallengeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PhotoAdapter extends TypeAdapter<Photo> {
  @override
  final int typeId = 4;

  @override
  Photo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Photo(
      UUID: fields[0] as String,
      submitTime: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Photo obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.UUID)
      ..writeByte(1)
      ..write(obj.submitTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserreflectionAdapter extends TypeAdapter<User_reflection> {
  @override
  final int typeId = 5;

  @override
  User_reflection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User_reflection(
      UUID: fields[0] as String,
      reflection: fields[2] as String,
      submitTime: fields[1] as DateTime,
      photos: (fields[3] as List).cast<String>(),
      reflection_id: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User_reflection obj) {
    writer
      ..writeByte(5)
      ..writeByte(2)
      ..write(obj.reflection)
      ..writeByte(3)
      ..write(obj.photos)
      ..writeByte(4)
      ..write(obj.reflection_id)
      ..writeByte(0)
      ..write(obj.UUID)
      ..writeByte(1)
      ..write(obj.submitTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserreflectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VoiceNoteAdapter extends TypeAdapter<VoiceNote> {
  @override
  final int typeId = 6;

  @override
  VoiceNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VoiceNote(
      UUID: fields[0] as String,
      description: fields[3] as String,
      title: fields[2] as String,
      submitTime: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, VoiceNote obj) {
    writer
      ..writeByte(4)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(0)
      ..write(obj.UUID)
      ..writeByte(1)
      ..write(obj.submitTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoiceNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Entry _$EntryFromJson(Map<String, dynamic> json) => Entry(
      UUID: json['UUID'] as String,
      submitTime: DateTime.parse(json['submitTime'] as String),
    );

Map<String, dynamic> _$EntryToJson(Entry instance) => <String, dynamic>{
      'UUID': instance.UUID,
      'submitTime': instance.submitTime.toIso8601String(),
    };

MoodCheckin _$MoodCheckinFromJson(Map<String, dynamic> json) => MoodCheckin(
      UUID: json['UUID'] as String,
      submitTime: DateTime.parse(json['submitTime'] as String),
      title: json['title'] as String,
      mood: (json['mood'] as num).toDouble(),
      activities: (json['activities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      feelings:
          (json['feelings'] as List<dynamic>).map((e) => e as String).toList(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$MoodCheckinToJson(MoodCheckin instance) =>
    <String, dynamic>{
      'UUID': instance.UUID,
      'submitTime': instance.submitTime.toIso8601String(),
      'description': instance.description,
      'mood': instance.mood,
      'activities': instance.activities,
      'feelings': instance.feelings,
      'title': instance.title,
    };

DailyChallenge _$DailyChallengeFromJson(Map<String, dynamic> json) =>
    DailyChallenge(
      id: (json['id'] as num).toInt(),
      step: (json['step'] as num).toInt(),
      description: json['description'] as String,
    );

Map<String, dynamic> _$DailyChallengeToJson(DailyChallenge instance) =>
    <String, dynamic>{
      'id': instance.id,
      'step': instance.step,
      'description': instance.description,
    };

User_Challenge _$User_ChallengeFromJson(Map<String, dynamic> json) =>
    User_Challenge(
      UUID: json['UUID'] as String,
      description: json['description'] as String,
      submitTime: DateTime.parse(json['submitTime'] as String),
      photos:
          (json['photos'] as List<dynamic>).map((e) => e as String).toList(),
      challenge_id: json['challenge_id'] as String,
    );

Map<String, dynamic> _$User_ChallengeToJson(User_Challenge instance) =>
    <String, dynamic>{
      'UUID': instance.UUID,
      'submitTime': instance.submitTime.toIso8601String(),
      'description': instance.description,
      'photos': instance.photos,
      'challenge_id': instance.challenge_id,
    };

Photo _$PhotoFromJson(Map<String, dynamic> json) => Photo(
      UUID: json['UUID'] as String,
      submitTime: DateTime.parse(json['submitTime'] as String),
    );

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'UUID': instance.UUID,
      'submitTime': instance.submitTime.toIso8601String(),
    };

User_reflection _$User_reflectionFromJson(Map<String, dynamic> json) =>
    User_reflection(
      UUID: json['UUID'] as String,
      reflection: json['reflection'] as String,
      submitTime: DateTime.parse(json['submitTime'] as String),
      photos:
          (json['photos'] as List<dynamic>).map((e) => e as String).toList(),
      reflection_id: json['reflection_id'] as String,
    );

Map<String, dynamic> _$User_reflectionToJson(User_reflection instance) =>
    <String, dynamic>{
      'UUID': instance.UUID,
      'submitTime': instance.submitTime.toIso8601String(),
      'reflection': instance.reflection,
      'photos': instance.photos,
      'reflection_id': instance.reflection_id,
    };

VoiceNote _$VoiceNoteFromJson(Map<String, dynamic> json) => VoiceNote(
      UUID: json['UUID'] as String,
      description: json['description'] as String,
      title: json['title'] as String,
      submitTime: DateTime.parse(json['submitTime'] as String),
    );

Map<String, dynamic> _$VoiceNoteToJson(VoiceNote instance) => <String, dynamic>{
      'UUID': instance.UUID,
      'submitTime': instance.submitTime.toIso8601String(),
      'title': instance.title,
      'description': instance.description,
    };
