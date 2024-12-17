// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityAdapter extends TypeAdapter<Activity> {
  @override
  final int typeId = 7;

  @override
  Activity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Activity(
      UUID: fields[0] as String,
      icon: fields[1] as int,
      title: fields[2] as String,
      archive: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Activity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.UUID)
      ..writeByte(1)
      ..write(obj.icon)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.archive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FeelingAdapter extends TypeAdapter<Feeling> {
  @override
  final int typeId = 8;

  @override
  Feeling read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Feeling(
      UUID: fields[0] as String,
      icon: fields[1] as int,
      title: fields[2] as String,
      archive: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Feeling obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.UUID)
      ..writeByte(1)
      ..write(obj.icon)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.archive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeelingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuoteAdapter extends TypeAdapter<Quote> {
  @override
  final int typeId = 9;

  @override
  Quote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quote(
      id: fields[0] as String,
      content: fields[1] as String,
      categoryId: fields[2] as String,
      like: fields[3] as bool,
      author: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Quote obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.like)
      ..writeByte(4)
      ..write(obj.author);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChallengeAdapter extends TypeAdapter<Challenge> {
  @override
  final int typeId = 10;

  @override
  Challenge read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Challenge(
      id: fields[0] as String,
      description: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Challenge obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReflectionAdapter extends TypeAdapter<Reflection> {
  @override
  final int typeId = 11;

  @override
  Reflection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reflection(
      id: fields[0] as String,
      description: fields[1] as String,
      category: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Reflection obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReflectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 12;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      end_positivity_reminder: fields[15] as DateTime,
      start_positivity_reminder: fields[14] as DateTime,
      count_positivity_reminder: fields[13] as int,
      time_checkin_reminder: fields[12] as DateTime,
      user_name: fields[0] as String,
      email: fields[1] as String,
      avatar: fields[2] as String?,
      refresh_token: fields[3] as String,
      quotesTheme: fields[4] as int,
      darkmode: fields[5] as bool,
      passcode: fields[6] as bool,
      checkin_reminder: fields[7] as bool,
      possitive_reminder: fields[8] as bool,
      theme_color: fields[9] as int,
      quote_category: fields[10] as int,
      quote_hearted: (fields[11] as List).cast<String>(),
      access_token: fields[16] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.user_name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.avatar)
      ..writeByte(3)
      ..write(obj.refresh_token)
      ..writeByte(4)
      ..write(obj.quotesTheme)
      ..writeByte(5)
      ..write(obj.darkmode)
      ..writeByte(6)
      ..write(obj.passcode)
      ..writeByte(7)
      ..write(obj.checkin_reminder)
      ..writeByte(8)
      ..write(obj.possitive_reminder)
      ..writeByte(9)
      ..write(obj.theme_color)
      ..writeByte(10)
      ..write(obj.quote_category)
      ..writeByte(11)
      ..write(obj.quote_hearted)
      ..writeByte(12)
      ..write(obj.time_checkin_reminder)
      ..writeByte(13)
      ..write(obj.count_positivity_reminder)
      ..writeByte(14)
      ..write(obj.start_positivity_reminder)
      ..writeByte(15)
      ..write(obj.end_positivity_reminder)
      ..writeByte(16)
      ..write(obj.access_token);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DataSyncAdapter extends TypeAdapter<Data_Sync> {
  @override
  final int typeId = 13;

  @override
  Data_Sync read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Data_Sync(
      name: fields[0] as int,
      action: fields[1] as int,
      jsonData: fields[2] as String,
      timeStamp: fields[3] as DateTime,
      id: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Data_Sync obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.action)
      ..writeByte(2)
      ..write(obj.jsonData)
      ..writeByte(3)
      ..write(obj.timeStamp)
      ..writeByte(4)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataSyncAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HomeModelAdapter extends TypeAdapter<HomeModel> {
  @override
  final int typeId = 14;

  @override
  HomeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HomeModel(
      todayChallenge: fields[0] as Challenge?,
      weeklyReflection: (fields[1] as List).cast<Reflection>(),
      weeklyQuote: (fields[2] as List).cast<Quote>(),
      completeCheckin: (fields[3] as List).cast<bool>(),
      reflectionShared: (fields[4] as List).cast<bool>(),
      start: fields[5] as DateTime,
      challenge_completed: (fields[6] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, HomeModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.todayChallenge)
      ..writeByte(1)
      ..write(obj.weeklyReflection)
      ..writeByte(2)
      ..write(obj.weeklyQuote)
      ..writeByte(3)
      ..write(obj.completeCheckin)
      ..writeByte(4)
      ..write(obj.reflectionShared)
      ..writeByte(5)
      ..write(obj.start)
      ..writeByte(6)
      ..write(obj.challenge_completed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      UUID: json['UUID'] as String,
      icon: (json['icon'] as num).toInt(),
      title: json['title'] as String,
      archive: json['archive'] as bool,
    );

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'UUID': instance.UUID,
      'icon': instance.icon,
      'title': instance.title,
      'archive': instance.archive,
    };

Feeling _$FeelingFromJson(Map<String, dynamic> json) => Feeling(
      UUID: json['UUID'] as String,
      icon: (json['icon'] as num).toInt(),
      title: json['title'] as String,
      archive: json['archive'] as bool,
    );

Map<String, dynamic> _$FeelingToJson(Feeling instance) => <String, dynamic>{
      'UUID': instance.UUID,
      'icon': instance.icon,
      'title': instance.title,
      'archive': instance.archive,
    };

Challenge _$ChallengeFromJson(Map<String, dynamic> json) => Challenge(
      id: json['id'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$ChallengeToJson(Challenge instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
    };

Reflection _$ReflectionFromJson(Map<String, dynamic> json) => Reflection(
      id: json['id'] as String,
      description: json['description'] as String,
      category: (json['category'] as num).toInt(),
    );

Map<String, dynamic> _$ReflectionToJson(Reflection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'category': instance.category,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      end_positivity_reminder:
          DateTime.parse(json['end_positivity_reminder'] as String),
      start_positivity_reminder:
          DateTime.parse(json['start_positivity_reminder'] as String),
      count_positivity_reminder:
          (json['count_positivity_reminder'] as num).toInt(),
      time_checkin_reminder:
          DateTime.parse(json['time_checkin_reminder'] as String),
      user_name: json['user_name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      refresh_token: json['refresh_token'] as String,
      quotesTheme: (json['quotesTheme'] as num).toInt(),
      darkmode: json['darkmode'] as bool,
      passcode: json['passcode'] as bool,
      checkin_reminder: json['checkin_reminder'] as bool,
      possitive_reminder: json['possitive_reminder'] as bool,
      theme_color: (json['theme_color'] as num).toInt(),
      quote_category: (json['quote_category'] as num).toInt(),
      quote_hearted: (json['quote_hearted'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      access_token: json['access_token'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'user_name': instance.user_name,
      'email': instance.email,
      'avatar': instance.avatar,
      'refresh_token': instance.refresh_token,
      'quotesTheme': instance.quotesTheme,
      'darkmode': instance.darkmode,
      'passcode': instance.passcode,
      'checkin_reminder': instance.checkin_reminder,
      'possitive_reminder': instance.possitive_reminder,
      'theme_color': instance.theme_color,
      'quote_category': instance.quote_category,
      'quote_hearted': instance.quote_hearted,
      'time_checkin_reminder': instance.time_checkin_reminder.toIso8601String(),
      'count_positivity_reminder': instance.count_positivity_reminder,
      'start_positivity_reminder':
          instance.start_positivity_reminder.toIso8601String(),
      'end_positivity_reminder':
          instance.end_positivity_reminder.toIso8601String(),
      'access_token': instance.access_token,
    };

Data_Sync _$Data_SyncFromJson(Map<String, dynamic> json) => Data_Sync(
      name: (json['name'] as num).toInt(),
      action: (json['action'] as num).toInt(),
      jsonData: json['jsonData'] as String,
      timeStamp: DateTime.parse(json['timeStamp'] as String),
      id: json['id'] as String,
    );

Map<String, dynamic> _$Data_SyncToJson(Data_Sync instance) => <String, dynamic>{
      'name': instance.name,
      'action': instance.action,
      'jsonData': instance.jsonData,
      'timeStamp': instance.timeStamp.toIso8601String(),
      'id': instance.id,
    };
