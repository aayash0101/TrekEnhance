// journal_entity.dart

class JournalEntity {
  final String id;
  final String userId;
  final String trekId;
  final String date;
  final String text;
  final List<String> photos;
  final DateTime createdAt;
  final DateTime updatedAt;

  JournalEntity({
    required this.id,
    required this.userId,
    required this.trekId,
    required this.date,
    required this.text,
    required this.photos,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JournalEntity.fromJson(Map<String, dynamic> json) {
    return JournalEntity(
      id: json['_id'] as String,
      userId: json['userId'] is Map ? json['userId']['_id'] : json['userId'],
      trekId: json['trekId'] is Map ? json['trekId']['_id'] : json['trekId'],
      date: json['date'] ?? '',
      text: json['text'] ?? '',
      photos: List<String>.from(json['photos'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'trekId': trekId,
      'date': date,
      'text': text,
      'photos': photos,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
