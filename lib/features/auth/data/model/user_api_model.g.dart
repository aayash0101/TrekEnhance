// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserApiModel _$UserApiModelFromJson(Map<String, dynamic> json) => UserApiModel(
      userId: json['_id'] as String?,
      fname: json['fname'] as String,
      lname: json['lname'] as String,
      image: json['image'] as String?,
      phone: json['phone'] as String,
      username: json['username'] as String,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$UserApiModelToJson(UserApiModel instance) =>
    <String, dynamic>{
      '_id': instance.userId,
      'fname': instance.fname,
      'lname': instance.lname,
      'image': instance.image,
      'phone': instance.phone,
      'username': instance.username,
      'password': instance.password,
    };
