import 'package:flutter_application_trek_e/features/home/domain/entity/review_entity.dart';

class TrekEntity {
  final String id;
  final String name;
  final String? location;
  final String? smallDescription;
  final String? description;
  final String? difficulty;
  final double? distance;
  final String? bestSeason;
  final String? imageUrl;
  final List<String>? highlights;
  final List<ReviewEntity>? reviews;

  TrekEntity({
    required this.id,
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
}
