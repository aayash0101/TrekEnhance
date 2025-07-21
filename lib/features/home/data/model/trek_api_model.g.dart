// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trek_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrekApiModel _$TrekApiModelFromJson(Map<String, dynamic> json) => TrekApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      location: json['location'] as String?,
      smallDescription: json['smallDescription'] as String?,
      description: json['description'] as String?,
      difficulty: json['difficulty'] as String?,
      distance: (json['distance'] as num?)?.toDouble(),
      bestSeason: json['bestSeason'] as String?,
      imageUrl: json['imageUrl'] as String?,
      highlights: (json['highlights'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => ReviewApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TrekApiModelToJson(TrekApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'smallDescription': instance.smallDescription,
      'description': instance.description,
      'difficulty': instance.difficulty,
      'distance': instance.distance,
      'bestSeason': instance.bestSeason,
      'imageUrl': instance.imageUrl,
      'highlights': instance.highlights,
      'reviews': instance.reviews?.map((e) => e.toJson()).toList(),
    };
