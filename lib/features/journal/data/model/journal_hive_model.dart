import 'package:equatable/equatable.dart';
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_application_trek_e/app/constant/hive_table_constant.dart';

part 'journal_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.journalTableId)
class JournalHiveModel extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String trekId;
  @HiveField(3)
  final String date;
  @HiveField(4)
  final String text;
  @HiveField(5)
  final List<String> photos;
  @HiveField(6)
  final DateTime createdAt;
  @HiveField(7)
  final DateTime updatedAt;

  JournalHiveModel({
    required this.id,
    required this.userId,
    required this.trekId,
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
      id: id,
      userId: userId,
      trekId: trekId,
      date: date,
      text: text,
      photos: photos,
      createdAt: createdAt,
      updatedAt: updatedAt,
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
