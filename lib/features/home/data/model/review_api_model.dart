import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/review_entity.dart';

part 'review_api_model.g.dart';

@JsonSerializable()
class ReviewApiModel extends Equatable {
  final String? userId;
  final String? username;
  final String? review;

  // Make date nullable to handle missing values
  final DateTime? date;

  const ReviewApiModel({
    this.userId,
    this.username,
    this.review,
    this.date,
  });

  factory ReviewApiModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewApiModelToJson(this);

  factory ReviewApiModel.fromEntity(ReviewEntity entity) {
    return ReviewApiModel(
      userId: entity.userId,
      username: entity.username,
      review: entity.review,
      date: entity.date,
    );
  }

  ReviewEntity toEntity() {
    return ReviewEntity(
      userId: userId ?? '',              // fallback to empty if null
      username: username ?? '',
      review: review ?? '',
      date: date ?? DateTime.now(),      // fallback to now if null
    );
  }

  @override
  List<Object?> get props => [userId, username, review, date];
}
