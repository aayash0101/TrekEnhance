// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalApiModel _$JournalApiModelFromJson(Map<String, dynamic> json) =>
    JournalApiModel(
      id: json['_id'] as String?,
      userId: json['userId'] as String,
      trekId: json['trekId'] as String,
      date: json['date'] as String,
      text: json['text'] as String,
      photos:
          (json['photos'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$JournalApiModelToJson(JournalApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'trekId': instance.trekId,
      'date': instance.date,
      'text': instance.text,
      'photos': instance.photos,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
