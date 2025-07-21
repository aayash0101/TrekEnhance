// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewApiModel _$ReviewApiModelFromJson(Map<String, dynamic> json) =>
    ReviewApiModel(
      userId: json['userId'] as String,
      username: json['username'] as String,
      review: json['review'] as String,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$ReviewApiModelToJson(ReviewApiModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'review': instance.review,
      'date': instance.date.toIso8601String(),
    };
