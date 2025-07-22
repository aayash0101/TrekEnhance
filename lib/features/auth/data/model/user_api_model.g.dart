// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserApiModel _$UserApiModelFromJson(Map<String, dynamic> json) => UserApiModel(
      userId: json['_id'] as String?,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
    );

Map<String, dynamic> _$UserApiModelToJson(UserApiModel instance) =>
    <String, dynamic>{
      '_id': instance.userId,
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'bio': instance.bio,
      'location': instance.location,
      'profileImageUrl': instance.profileImageUrl,
    };
