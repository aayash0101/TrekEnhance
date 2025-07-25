import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';

class JournalEntity {
  final String id;
  final String userId;
  final String trekId;
  final String date;
  final String text;
  final List<String> photos;
  final DateTime createdAt;
  final DateTime updatedAt;

  final UserEntity? user;
  final TrekEntity? trek;

  JournalEntity({
    required this.id,
    required this.userId,
    required this.trekId,
    required this.date,
    required this.text,
    required this.photos,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.trek,
  });

  factory JournalEntity.fromJson(Map<String, dynamic> json) {
    final userJson = json['userId'];
    final trekJson = json['trekId'];

    // Debug prints
    print('userJson: $userJson (${userJson.runtimeType})');
    print('trekJson: $trekJson (${trekJson.runtimeType})');

    String parseId(dynamic data) {
      if (data == null) return '';
      if (data is Map<String, dynamic>) {
        final id = data['_id'];
        if (id is String) return id;
      } else if (data is String) {
        return data;
      }
      return '';
    }

    return JournalEntity(
      id: json['_id'] as String,
      userId: parseId(userJson),
      trekId: parseId(trekJson),
      date: json['date'] ?? '',
      text: json['text'] ?? '',
      photos: (json['photos'] != null && json['photos'] is List)
          ? List<String>.from(json['photos'])
          : [],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      user: (userJson is Map<String, dynamic>)
          ? UserEntity(
              userId: userJson['_id'] as String?,
              username: userJson['username'] ?? '',
              email: userJson['email'] ?? '',
              password: '',
              bio: userJson['bio'],
              location: userJson['location'],
              profileImageUrl: userJson['profileImageUrl'],
            )
          : null,
      trek: (trekJson is Map<String, dynamic>)
          ? TrekEntity(
              id: trekJson['_id'] as String? ?? '',
              name: trekJson['name'] ?? '',
              location: trekJson['location'],
              smallDescription: trekJson['smallDescription'],
              description: trekJson['description'],
              difficulty: trekJson['difficulty'],
              distance: trekJson['distance'] != null
                  ? (trekJson['distance'] as num).toDouble()
                  : null,
              bestSeason: trekJson['bestSeason'],
              imageUrl: trekJson['imageUrl'],
              highlights: trekJson['highlights'] != null
                  ? List<String>.from(trekJson['highlights'])
                  : null,
              reviews: null,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': user != null ? user!.toJson() : userId,
      'trekId': trek != null ? trek!.toJson() : trekId,
      'date': date,
      'text': text,
      'photos': photos,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
