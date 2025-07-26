import 'package:equatable/equatable.dart';
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'journal_api_model.g.dart';

@JsonSerializable(explicitToJson: true)
class JournalApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;

  final UserEntity user;
  final TrekEntity? trek;
  final String date;
  final String text;
  final List<String> photos;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const JournalApiModel({
    this.id,
    required this.user,
    required this.trek,
    required this.date,
    required this.text,
    required this.photos,
    this.createdAt,
    this.updatedAt,
  });

  factory JournalApiModel.fromJson(Map<String, dynamic> json) {
    // Helper to parse UserEntity from String ID or Map or null
    UserEntity parseUser(dynamic userData) {
      if (userData == null) {
        return UserEntity(
          userId: '',
          username: '',
          email: '',
          password: '',
        );
      }
      if (userData is String) {
        return UserEntity(
          userId: userData,
          username: '',
          email: '',
          password: '',
        );
      }
      if (userData is Map<String, dynamic>) {
        return UserEntity.fromJson(userData);
      }
      throw Exception('Unexpected user data format');
    }

    // Helper to parse TrekEntity similarly
    TrekEntity? parseTrek(dynamic trekData) {
      if (trekData == null) {
        return null;
      }
      if (trekData is String) {
        return TrekEntity(id: trekData, name: '');
      }
      if (trekData is Map<String, dynamic>) {
        return TrekEntity.fromJson(trekData);
      }
      throw Exception('Unexpected trek data format');
    }

    return JournalApiModel(
      id: json['_id'] as String?,
      user: parseUser(json['user'] ?? json['userId']),
      trek: parseTrek(json['trek'] ?? json['trekId']),
      date: json['date'] as String? ?? '',
      text: json['text'] as String? ?? '',
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => _$JournalApiModelToJson(this);

  JournalEntity toEntity() {
    return JournalEntity(
      id: id ?? '',
      userId: user.userId ?? '',
      trekId: trek?.id ?? '',
      date: date,
      text: text,
      photos: photos,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
      user: user,
      trek: trek,
    );
  }

  @override
  List<Object?> get props => [
        id,
        user,
        trek,
        date,
        text,
        photos,
        createdAt,
        updatedAt,
      ];
}
