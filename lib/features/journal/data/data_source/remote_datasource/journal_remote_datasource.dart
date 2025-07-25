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
    final response = await dio.post(
      ApiEndpoints.journalBaseUrl + ApiEndpoints.createJournal,
      data: {
        'userId': userId,
        'trekId': trekId,
        'date': date,
        'text': text,
        'photos': photos,
      },
    );
    return JournalApiModel.fromJson(response.data);
  }

  @override
  Future<List<JournalApiModel>> getAllJournals() async {
    final response = await dio.get(ApiEndpoints.journalBaseUrl + ApiEndpoints.getAllJournals);
    return (response.data as List)
        .map((json) => JournalApiModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<JournalApiModel>> getJournalsByTrekAndUser({
    required String trekId,
    required String userId,
  }) async {
    final url = ApiEndpoints.journalBaseUrl + "$trekId/$userId";
    final response = await dio.get(url);
    return (response.data as List)
        .map((json) => JournalApiModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<JournalApiModel>> getJournalsByUser(String userId) async {
    final url = ApiEndpoints.journalBaseUrl + "user/$userId";
    final response = await dio.get(url);
    return (response.data as List)
        .map((json) => JournalApiModel.fromJson(json))
        .toList();
  }

  @override
  Future<JournalApiModel> updateJournal({
    required String id,
    required String date,
    required String text,
    required List<String> photos,
  }) async {
    final url = ApiEndpoints.journalBaseUrl + ApiEndpoints.updateJournalById(id);
    final response = await dio.put(
      url,
      data: {
        'date': date,
        'text': text,
        'photos': photos,
      },
    );
    return JournalApiModel.fromJson(response.data);
  }

  @override
  Future<bool> deleteJournal(String id) async {
    final url = ApiEndpoints.journalBaseUrl + ApiEndpoints.deleteJournalById(id);
    await dio.delete(url);
    return true;
  }
}
