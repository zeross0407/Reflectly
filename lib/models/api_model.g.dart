// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      refresh_token: json['refresh_token'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      username: json['username'] as String,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'refresh_token': instance.refresh_token,
      'email': instance.email,
      'avatar': instance.avatar,
      'username': instance.username,
    };

QuotesResponse _$QuotesResponseFromJson(Map<String, dynamic> json) =>
    QuotesResponse(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String?,
      favorite: (json['favorite'] as num).toInt(),
      categoryid: json['categoryid'] as String,
    );

Map<String, dynamic> _$QuotesResponseToJson(QuotesResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'favorite': instance.favorite,
      'categoryid': instance.categoryid,
    };
