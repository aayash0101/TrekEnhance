import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_application_trek_e/app/constant/hive_table_constant.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/review_entity.dart';

part 'review_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.reviewTableId)
class ReviewHiveModel extends Equatable {
  @HiveField(0)
  final String trekId;      // Added this field to relate review to trek
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String username;
  @HiveField(3)
  final String review;
  @HiveField(4)
  final DateTime date;

  ReviewHiveModel({
    required this.trekId,
    required this.userId,
    required this.username,
    required this.review,
    required this.date,
  });

  factory ReviewHiveModel.fromEntity(ReviewEntity entity, String trekId) {
    return ReviewHiveModel(
      trekId: trekId,
      userId: entity.userId,
      username: entity.username,
      review: entity.review,
      date: entity.date,
    );
  }

  ReviewEntity toEntity() {
    return ReviewEntity(
      userId: userId,
      username: username,
      review: review,
      date: date,
    );
  }

  @override
  List<Object?> get props => [trekId, userId, username, review, date];
}
