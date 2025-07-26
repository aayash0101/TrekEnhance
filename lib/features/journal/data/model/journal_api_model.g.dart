// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalApiModel _$JournalApiModelFromJson(Map<String, dynamic> json) =>
    JournalApiModel(
      id: json['_id'] as String?,
      user: UserEntity.fromJson(json['user'] as Map<String, dynamic>),
      trek: json['trek'] == null
          ? null
          : TrekEntity.fromJson(json['trek'] as Map<String, dynamic>),
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
      'user': instance.user.toJson(),
      'trek': instance.trek?.toJson(),
      'date': instance.date,
      'text': instance.text,
      'photos': instance.photos,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
