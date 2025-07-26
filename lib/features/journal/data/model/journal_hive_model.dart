import 'package:equatable/equatable.dart';
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';
import 'package:flutter_application_trek_e/app/constant/hive_table_constant.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'journal_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.journalTableId)
class JournalHiveModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String username;

  @HiveField(3)
  final String trekId;
  @HiveField(4)
  final String trekName;

  @HiveField(5)
  final String date;
  @HiveField(6)
  final String text;
  @HiveField(7)
  final List<String> photos;

  @HiveField(8)
  final DateTime createdAt;
  @HiveField(9)
  final DateTime updatedAt;

  JournalHiveModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.trekId,
    required this.trekName,
    required this.date,
    required this.text,
    required this.photos,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JournalHiveModel.fromEntity(JournalEntity entity) {
    return JournalHiveModel(
      id: entity.id,
      userId: entity.userId,
      username: entity.user?.username ?? 'unknown',
      trekId: entity.trekId,
      trekName: entity.trek?.name ?? 'unknown',
      date: entity.date,
      text: entity.text,
      photos: entity.photos,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  JournalEntity toEntity() {
    return JournalEntity(
      id: id,
      userId: userId,
      trekId: trekId,
      date: date,
      text: text,
      photos: photos,
      createdAt: createdAt,
      updatedAt: updatedAt,
      user: null,  // hive cannot store nested objects; keep null
      trek: null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        username,
        trekId,
        trekName,
        date,
        text,
        photos,
        createdAt,
        updatedAt,
      ];
}
