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
  
  // These will be set based on current user's saved/favorite lists
  bool isSaved;
  bool isFavorite;

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
    this.isSaved = false,
    this.isFavorite = false,
  });

  factory JournalEntity.fromJson(Map<String, dynamic> json) {
    final userJson = json['userId'];
    final trekJson = json['trekId'];

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
      user: (userJson is Map<String, dynamic>) ? UserEntity.fromJson(userJson) : null,
      trek: (trekJson is Map<String, dynamic>) ? TrekEntity.fromJson(trekJson) : null,
      
      // These will be updated after fetching user's saved/favorite lists
      isSaved: false,
      isFavorite: false,
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

  // Helper method to create a copy with updated save/favorite status
  JournalEntity copyWith({
    String? id,
    String? userId,
    String? trekId,
    String? date,
    String? text,
    List<String>? photos,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserEntity? user,
    TrekEntity? trek,
    bool? isSaved,
    bool? isFavorite,
  }) {
    return JournalEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      trekId: trekId ?? this.trekId,
      date: date ?? this.date,
      text: text ?? this.text,
      photos: photos ?? this.photos,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      trek: trek ?? this.trek,
      isSaved: isSaved ?? this.isSaved,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}