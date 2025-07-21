import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_application_trek_e/app/constant/hive_table_constant.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';
import 'package:flutter_application_trek_e/features/home/data/model/review_hive_model.dart';

part 'trek_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.trekTableId)
class TrekHiveModel extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String location;
  @HiveField(3)
  final String smallDescription;
  @HiveField(4)
  final String description;
  @HiveField(5)
  final String difficulty;
  @HiveField(6)
  final double distance;
  @HiveField(7)
  final String bestSeason;
  @HiveField(8)
  final String imageUrl;
  @HiveField(9)
  final List<String> highlights;
  @HiveField(10)
  final List<ReviewHiveModel> reviews;

  TrekHiveModel({
    required this.id,
    required this.name,
    required this.location,
    required this.smallDescription,
    required this.description,
    required this.difficulty,
    required this.distance,
    required this.bestSeason,
    required this.imageUrl,
    required this.highlights,
    required this.reviews,
  });

  factory TrekHiveModel.fromEntity(TrekEntity entity) {
    return TrekHiveModel(
      id: entity.id,
      name: entity.name,
      location: entity.location ?? '',
      smallDescription: entity.smallDescription ?? '',
      description: entity.description ?? '',
      difficulty: entity.difficulty ?? '',
      distance: entity.distance ?? 0.0,
      bestSeason: entity.bestSeason ?? '',
      imageUrl: entity.imageUrl ?? '',
      highlights: entity.highlights ?? [],
      reviews: entity.reviews?.map((r) => ReviewHiveModel.fromEntity(r, entity.id)).toList() ?? [],
    );
  }

  TrekEntity toEntity() {
    return TrekEntity(
      id: id,
      name: name,
      location: location,
      smallDescription: smallDescription,
      description: description,
      difficulty: difficulty,
      distance: distance,
      bestSeason: bestSeason,
      imageUrl: imageUrl,
      highlights: highlights,
      reviews: reviews.map((r) => r.toEntity()).toList(),
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
