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

  factory TrekEntity.fromJson(Map<String, dynamic> json) {
    return TrekEntity(
      id: json['_id'] as String? ?? '',
      name: json['name'] ?? '',
      location: json['location'],
      smallDescription: json['smallDescription'],
      description: json['description'],
      difficulty: json['difficulty'],
      distance: json['distance'] != null
          ? (json['distance'] as num).toDouble()
          : null,
      bestSeason: json['bestSeason'],
      imageUrl: json['imageUrl'],
      highlights: json['highlights'] != null
          ? List<String>.from(json['highlights'])
          : null,
      reviews: null, // or parse if you have review JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'location': location,
      'smallDescription': smallDescription,
      'description': description,
      'difficulty': difficulty,
      'distance': distance,
      'bestSeason': bestSeason,
      'imageUrl': imageUrl,
      'highlights': highlights,
      // reviews not serialized here to avoid deep serialization
    };
  }
}
