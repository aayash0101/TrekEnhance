import 'package:flutter_application_trek_e/features/journal/data/model/journal_api_model.dart';

void main() {
  final sampleJson = {
    "_id": "journal123",
    "userId": {
      "_id": "user456",
      "username": "JohnDoe",
      "email": "john@example.com",
      "bio": "Hello there",
      "location": "Earth",
      "profileImageUrl": "http://image.url/profile.jpg"
    },
    "trekId": {
      "_id": "trek789",
      "name": "Everest Base Camp",
      "location": "Nepal",
      "smallDescription": "A tough trek",
      "description": "Amazing views",
      "difficulty": "Hard",
      "distance": 130.5,
      "bestSeason": "Spring",
      "imageUrl": "http://image.url/trek.jpg",
      "highlights": ["Snow", "Mountains", "Adventure"]
    },
    "date": "2025-07-26",
    "text": "Awesome trek!",
    "photos": ["photo1.jpg", "photo2.jpg"],
    "createdAt": "2025-07-20T12:00:00Z",
    "updatedAt": "2025-07-21T12:00:00Z"
  };

  final journalApiModel = JournalApiModel.fromJson(sampleJson);
  final journalEntity = journalApiModel.toEntity();

  print('Journal ID: ${journalEntity.id}');
  print('User ID: ${journalEntity.userId}');
  print('User username: ${journalEntity.user?.username}');
  print('Trek ID: ${journalEntity.trekId}');
  print('Trek name: ${journalEntity.trek?.name}');
  print('Date: ${journalEntity.date}');
  print('Text: ${journalEntity.text}');
  print('Photos: ${journalEntity.photos}');
  print('Created At: ${journalEntity.createdAt}');
  print('Updated At: ${journalEntity.updatedAt}');
}
