import 'package:dio/dio.dart';
import 'package:flutter_application_trek_e/app/constant/api_endpoint.dart';
import 'package:flutter_application_trek_e/features/journal/data/model/journal_api_model.dart';

abstract interface class IJournalRemoteDataSource {
  Future<JournalApiModel> createJournal({
    required String userId,
    required String trekId,
    required String date,
    required String text,
    required List<String> photos,
  });

  Future<List<JournalApiModel>> getAllJournals();

  Future<List<JournalApiModel>> getJournalsByTrekAndUser({
    required String trekId,
    required String userId,
  });

  Future<List<JournalApiModel>> getJournalsByUser(String userId);

  Future<JournalApiModel> updateJournal({
    required String id,
    required String date,
    required String text,
    required List<String> photos,
  });

  Future<bool> deleteJournal(String id);

  // Save functionality
  Future<bool> saveJournal({
    required String journalId,
    required String userId,
  });

  Future<bool> unsaveJournal({
    required String journalId,
    required String userId,
  });

  Future<List<JournalApiModel>> getSavedJournals(String userId);

  Future<bool> isJournalSaved({
    required String journalId,
    required String userId,
  });

  // Favorite functionality
  Future<bool> favoriteJournal({
    required String journalId,
    required String userId,
  });

  Future<bool> unfavoriteJournal({
    required String journalId,
    required String userId,
  });

  Future<List<JournalApiModel>> getFavoriteJournals(String userId);

  Future<bool> isJournalFavorited({
    required String journalId,
    required String userId,
  });
}

class JournalRemoteDataSource implements IJournalRemoteDataSource {
  final Dio dio;

  JournalRemoteDataSource({required this.dio});

  @override
  Future<JournalApiModel> createJournal({
    required String userId,
    required String trekId,
    required String date,
    required String text,
    required List<String> photos,
  }) async {
    try {
      final response = await dio.post(
        '${ApiEndpoints.journalBaseUrl}${ApiEndpoints.createJournal}',
        data: {
          'userId': userId,
          'trekId': trekId,
          'date': date,
          'text': text,
          'photos': photos,
        },
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return JournalApiModel.fromJson(data);
      } else {
        throw Exception('Unexpected response format: $data');
      }
    } catch (e) {
      throw Exception('Failed to create journal: $e');
    }
  }

  @override
  Future<List<JournalApiModel>> getAllJournals() async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.journalBaseUrl}${ApiEndpoints.getAllJournals}',
      );
      final data = response.data;
      if (data is List) {
        return data
            .where((item) => item != null && item is Map<String, dynamic>)
            .map((json) => JournalApiModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Unexpected response format: $data');
      }
    } catch (e) {
      throw Exception('Failed to fetch all journals: $e');
    }
  }

  @override
  Future<List<JournalApiModel>> getJournalsByTrekAndUser({
    required String trekId,
    required String userId,
  }) async {
    try {
      final url = '${ApiEndpoints.journalBaseUrl}$trekId/$userId';
      final response = await dio.get(url);
      final data = response.data;
      if (data is List) {
        return data
            .where((item) => item != null && item is Map<String, dynamic>)
            .map((json) => JournalApiModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Unexpected response format: $data');
      }
    } catch (e) {
      throw Exception('Failed to fetch journals by trek and user: $e');
    }
  }

  @override
  Future<List<JournalApiModel>> getJournalsByUser(String userId) async {
    try {
      if (userId.isEmpty) {
        throw Exception('User ID cannot be empty');
      }
      print('Fetching journals by userId: $userId');

      final url = '${ApiEndpoints.journalBaseUrl}user/$userId';
      final response = await dio.get(url);
      final data = response.data;
      if (data is List) {
        return data
            .where((item) => item != null && item is Map<String, dynamic>)
            .map((json) => JournalApiModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Unexpected response format: $data');
      }
    } catch (e) {
      throw Exception('Failed to fetch journals by user: $e');
    }
  }

  @override
  Future<JournalApiModel> updateJournal({
    required String id,
    required String date,
    required String text,
    required List<String> photos,
  }) async {
    try {
      final url = '${ApiEndpoints.journalBaseUrl}${ApiEndpoints.updateJournalById(id)}';
      final response = await dio.put(
        url,
        data: {
          'date': date,
          'text': text,
          'photos': photos,
        },
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return JournalApiModel.fromJson(data);
      } else {
        throw Exception('Unexpected response format: $data');
      }
    } catch (e) {
      throw Exception('Failed to update journal: $e');
    }
  }

  @override
  Future<bool> deleteJournal(String id) async {
    try {
      final url = '${ApiEndpoints.journalBaseUrl}${ApiEndpoints.deleteJournalById(id)}';
      await dio.delete(url);
      return true;
    } catch (e) {
      throw Exception('Failed to delete journal: $e');
    }
  }

  @override
  Future<bool> saveJournal({
    required String journalId,
    required String userId,
  }) async {
    if (userId.isEmpty) {
      throw Exception('User ID cannot be empty');
    }
    print('Saving journal with userId: $userId, journalId: $journalId');
    try {
      final response = await dio.post(
        '${ApiEndpoints.userBaseUrl}$userId/saved/$journalId',
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception('Failed to save journal: $e');
    }
  }

  @override
  Future<bool> unsaveJournal({
    required String journalId,
    required String userId,
  }) async {
    if (userId.isEmpty) {
      throw Exception('User ID cannot be empty');
    }
    print('Unsaving journal with userId: $userId, journalId: $journalId');
    try {
      final response = await dio.delete(
        '${ApiEndpoints.userBaseUrl}$userId/saved/$journalId',
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to unsave journal: $e');
    }
  }

  @override
  Future<List<JournalApiModel>> getSavedJournals(String userId) async {
    if (userId.isEmpty) {
      throw Exception('User ID cannot be empty');
    }
    print('Fetching saved journals for userId: $userId');
    try {
      final response = await dio.get(
        '${ApiEndpoints.userBaseUrl}$userId/saved',
      );
      final data = response.data;
      if (data is List) {
        return data
            .where((item) => item != null && item is Map<String, dynamic>)
            .map((json) => JournalApiModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Unexpected response format: $data');
      }
    } catch (e) {
      throw Exception('Failed to fetch saved journals: $e');
    }
  }

  @override
  Future<bool> isJournalSaved({
    required String journalId,
    required String userId,
  }) async {
    if (userId.isEmpty) {
      throw Exception('User ID cannot be empty');
    }
    print('Checking if journal is saved for userId: $userId, journalId: $journalId');
    try {
      final savedJournals = await getSavedJournals(userId);
      final isSaved = savedJournals.any((journal) => journal.id == journalId);
      return isSaved;
    } catch (e) {
      throw Exception('Failed to check if journal is saved: $e');
    }
  }

  @override
  Future<bool> favoriteJournal({
    required String journalId,
    required String userId,
  }) async {
    if (userId.isEmpty) {
      throw Exception('User ID cannot be empty');
    }
    print('Favoriting journal with userId: $userId, journalId: $journalId');
    try {
      final response = await dio.post(
        '${ApiEndpoints.userBaseUrl}$userId/favorites/$journalId',
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception('Failed to favorite journal: $e');
    }
  }

  @override
  Future<bool> unfavoriteJournal({
    required String journalId,
    required String userId,
  }) async {
    if (userId.isEmpty) {
      throw Exception('User ID cannot be empty');
    }
    print('Unfavoriting journal with userId: $userId, journalId: $journalId');
    try {
      final response = await dio.delete(
        '${ApiEndpoints.userBaseUrl}$userId/favorites/$journalId',
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to unfavorite journal: $e');
    }
  }

  @override
  Future<List<JournalApiModel>> getFavoriteJournals(String userId) async {
    if (userId.isEmpty) {
      throw Exception('User ID cannot be empty');
    }
    print('Fetching favorite journals for userId: $userId');
    try {
      final response = await dio.get(
        '${ApiEndpoints.userBaseUrl}$userId/favorites',
      );
      final data = response.data;
      if (data is List) {
        return data
            .where((item) => item != null && item is Map<String, dynamic>)
            .map((json) => JournalApiModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Unexpected response format: $data');
      }
    } catch (e) {
      throw Exception('Failed to fetch favorite journals: $e');
    }
  }

  @override
  Future<bool> isJournalFavorited({
    required String journalId,
    required String userId,
  }) async {
    if (userId.isEmpty) {
      throw Exception('User ID cannot be empty');
    }
    print('Checking if journal is favorited for userId: $userId, journalId: $journalId');
    try {
      final favoriteJournals = await getFavoriteJournals(userId);
      final isFavorited = favoriteJournals.any((journal) => journal.id == journalId);
      return isFavorited;
    } catch (e) {
      throw Exception('Failed to check if journal is favorited: $e');
    }
  }
}
