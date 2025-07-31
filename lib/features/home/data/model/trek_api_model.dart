import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';
import 'package:flutter_application_trek_e/features/home/data/model/review_api_model.dart';

part 'trek_api_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TrekApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String? location;
  final String? smallDescription;
  final String? description;
  final String? difficulty;
  final double? distance;
  final String? bestSeason;
  final String? imageUrl;
  final List<String>? highlights;
  final List<ReviewApiModel>? reviews;

  const TrekApiModel({
    this.id,
    required this.name,
    this.location,
    this.smallDescription,
    this.description,
    this.difficulty,
    this.distance,
    this.bestSeason,
    this.imageUrl,
    this.highlights,
    this.reviews,
  });

  /// ✅ From JSON
  factory TrekApiModel.fromJson(Map<String, dynamic> json) =>
      _$TrekApiModelFromJson(json);

  /// ✅ To JSON
  Map<String, dynamic> toJson() => _$TrekApiModelToJson(this);

  /// ✅ Convert from Domain Entity to API Model
  factory TrekApiModel.fromEntity(TrekEntity entity) {
    return TrekApiModel(
      id: entity.id,
      name: entity.name,
      location: entity.location,
      smallDescription: entity.smallDescription,
      description: entity.description,
      difficulty: entity.difficulty,
      distance: entity.distance,
      bestSeason: entity.bestSeason,
      imageUrl: entity.imageUrl,
      highlights: entity.highlights,
      reviews: entity.reviews
          ?.map((review) => ReviewApiModel.fromEntity(review))
          .toList(),
    );
  }

  /// ✅ Convert to Domain Entity
  TrekEntity toEntity() {
    return TrekEntity(
      id: id ?? '',
      name: name,
      location: location,
      smallDescription: smallDescription,
      description: description,
      difficulty: difficulty,
      distance: distance,
      bestSeason: bestSeason,
      imageUrl: imageUrl,
      highlights: highlights,
      reviews: reviews?.map((r) => r.toEntity()).toList() ?? [],
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        location,
        smallDescription,
        description,
        difficulty,
        distance,
        bestSeason,
        imageUrl,
        highlights,
        reviews,
      ];
}
