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
}
