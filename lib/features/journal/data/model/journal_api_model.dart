import 'package:equatable/equatable.dart';
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'journal_api_model.g.dart';

@JsonSerializable(explicitToJson: true)
class JournalApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;

  final String userId;
  final String trekId;
  final String date;
  final String text;
  final List<String> photos;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const JournalApiModel({
    this.id,
    required this.userId,
    required this.trekId,
    required this.date,
    required this.text,
    required this.photos,
    this.createdAt,
    this.updatedAt,
  });

  factory JournalApiModel.fromJson(Map<String, dynamic> json) =>
      _$JournalApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$JournalApiModelToJson(this);

  factory JournalApiModel.fromEntity(JournalEntity entity) {
    return JournalApiModel(
      id: entity.id,
      userId: entity.userId,
      trekId: entity.trekId,
      date: entity.date,
      text: entity.text,
      photos: entity.photos,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  JournalEntity toEntity() {
    return JournalEntity(
      id: id ?? '',
      userId: userId,
      trekId: trekId,
      date: date,
      text: text,
      photos: photos,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        trekId,
        date,
        text,
        photos,
        createdAt,
        updatedAt,
      ];
}
