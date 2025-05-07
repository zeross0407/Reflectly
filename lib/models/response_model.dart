// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
    String refreshToken;
    String email;
    dynamic avatar;
    String username;
    List<MoodCheckinList> moodCheckinList;
    List<PhotoList> photoList;
    List<UserChallengeList> userChallengeList;
    List<UserReflectionList> userReflectionList;
    List<VoicenoteList> voicenoteList;
    List<ActivityListElement> activityList;
    List<ActivityListElement> feelingList;

    UserData({
        required this.refreshToken,
        required this.email,
        required this.avatar,
        required this.username,
        required this.moodCheckinList,
        required this.photoList,
        required this.userChallengeList,
        required this.userReflectionList,
        required this.voicenoteList,
        required this.activityList,
        required this.feelingList,
    });

    factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        refreshToken: json["refresh_token"],
        email: json["email"],
        avatar: json["avatar"],
        username: json["username"],
        moodCheckinList: List<MoodCheckinList>.from(json["mood_checkin_list"].map((x) => MoodCheckinList.fromJson(x))),
        photoList: List<PhotoList>.from(json["photo_list"].map((x) => PhotoList.fromJson(x))),
        userChallengeList: List<UserChallengeList>.from(json["user_challenge_list"].map((x) => UserChallengeList.fromJson(x))),
        userReflectionList: List<UserReflectionList>.from(json["user_reflection_list"].map((x) => UserReflectionList.fromJson(x))),
        voicenoteList: List<VoicenoteList>.from(json["voicenote_list"].map((x) => VoicenoteList.fromJson(x))),
        activityList: List<ActivityListElement>.from(json["activity_list"].map((x) => ActivityListElement.fromJson(x))),
        feelingList: List<ActivityListElement>.from(json["feeling_list"].map((x) => ActivityListElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "refresh_token": refreshToken,
        "email": email,
        "avatar": avatar,
        "username": username,
        "mood_checkin_list": List<dynamic>.from(moodCheckinList.map((x) => x.toJson())),
        "photo_list": List<dynamic>.from(photoList.map((x) => x.toJson())),
        "user_challenge_list": List<dynamic>.from(userChallengeList.map((x) => x.toJson())),
        "user_reflection_list": List<dynamic>.from(userReflectionList.map((x) => x.toJson())),
        "voicenote_list": List<dynamic>.from(voicenoteList.map((x) => x.toJson())),
        "activity_list": List<dynamic>.from(activityList.map((x) => x.toJson())),
        "feeling_list": List<dynamic>.from(feelingList.map((x) => x.toJson())),
    };
}

class ActivityListElement {
    String uuid;
    String userId;
    String title;
    int icon;
    bool archive;

    ActivityListElement({
        required this.uuid,
        required this.userId,
        required this.title,
        required this.icon,
        required this.archive,
    });

    factory ActivityListElement.fromJson(Map<String, dynamic> json) => ActivityListElement(
        uuid: json["uuid"],
        userId: json["userId"],
        title: json["title"],
        icon: json["icon"],
        archive: json["archive"],
    );

    Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "userId": userId,
        "title": title,
        "icon": icon,
        "archive": archive,
    };
}

class MoodCheckinList {
    double mood;
    List<String> activities;
    List<String> feelings;
    String title;
    String description;
    String uuid;
    DateTime submitTime;
    String userId;

    MoodCheckinList({
        required this.mood,
        required this.activities,
        required this.feelings,
        required this.title,
        required this.description,
        required this.uuid,
        required this.submitTime,
        required this.userId,
    });

    factory MoodCheckinList.fromJson(Map<String, dynamic> json) => MoodCheckinList(
        mood: json["mood"]?.toDouble(),
        activities: List<String>.from(json["activities"].map((x) => x)),
        feelings: List<String>.from(json["feelings"].map((x) => x)),
        title: json["title"] ?? "",
        description: json["description"]?? "",
        uuid: json["uuid"],
        submitTime: DateTime.parse(json["submitTime"]),
        userId: json["userId"],
    );

    Map<String, dynamic> toJson() => {
        "mood": mood,
        "activities": List<dynamic>.from(activities.map((x) => x)),
        "feelings": List<dynamic>.from(feelings.map((x) => x)),
        "title": title,
        "description": description,
        "uuid": uuid,
        "submitTime": submitTime.toIso8601String(),
        "userId": userId,
    };
}

class PhotoList {
    String uuid;
    DateTime submitTime;
    String userId;

    PhotoList({
        required this.uuid,
        required this.submitTime,
        required this.userId,
    });

    factory PhotoList.fromJson(Map<String, dynamic> json) => PhotoList(
        uuid: json["uuid"],
        submitTime: DateTime.parse(json["submitTime"]),
        userId: json["userId"],
    );

    Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "submitTime": submitTime.toIso8601String(),
        "userId": userId,
    };
}

class UserChallengeList {
    List<String> photos;
    String challengeId;
    String description;
    String uuid;
    DateTime submitTime;
    String userId;

    UserChallengeList({
        required this.photos,
        required this.challengeId,
        required this.description,
        required this.uuid,
        required this.submitTime,
        required this.userId,
    });

    factory UserChallengeList.fromJson(Map<String, dynamic> json) => UserChallengeList(
        photos: List<String>.from(json["photos"].map((x) => x)),
        challengeId: json["challenge_id"],
        description: json["description"],
        uuid: json["uuid"],
        submitTime: DateTime.parse(json["submitTime"]),
        userId: json["userId"],
    );

    Map<String, dynamic> toJson() => {
        "photos": List<dynamic>.from(photos.map((x) => x)),
        "challenge_id": challengeId,
        "description": description,
        "uuid": uuid,
        "submitTime": submitTime.toIso8601String(),
        "userId": userId,
    };
}

class UserReflectionList {
    List<String> photos;
    String reflectionId;
    String reflection;
    String uuid;
    DateTime submitTime;
    String userId;

    UserReflectionList({
        required this.photos,
        required this.reflectionId,
        required this.reflection,
        required this.uuid,
        required this.submitTime,
        required this.userId,
    });

    factory UserReflectionList.fromJson(Map<String, dynamic> json) => UserReflectionList(
        photos: List<String>.from(json["photos"].map((x) => x)),
        reflectionId: json["reflection_id"],
        reflection: json["reflection"],
        uuid: json["uuid"],
        submitTime: DateTime.parse(json["submitTime"]),
        userId: json["userId"],
    );

    Map<String, dynamic> toJson() => {
        "photos": List<dynamic>.from(photos.map((x) => x)),
        "reflection_id": reflectionId,
        "reflection": reflection,
        "uuid": uuid,
        "submitTime": submitTime.toIso8601String(),
        "userId": userId,
    };
}

class VoicenoteList {
    String title;
    String description;
    String uuid;
    DateTime submitTime;
    String userId;

    VoicenoteList({
        required this.title,
        required this.description,
        required this.uuid,
        required this.submitTime,
        required this.userId,
    });

    factory VoicenoteList.fromJson(Map<String, dynamic> json) => VoicenoteList(
        title: json["title"],
        description: json["description"],
        uuid: json["uuid"],
        submitTime: DateTime.parse(json["submitTime"]),
        userId: json["userId"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "uuid": uuid,
        "submitTime": submitTime.toIso8601String(),
        "userId": userId,
    };
}
