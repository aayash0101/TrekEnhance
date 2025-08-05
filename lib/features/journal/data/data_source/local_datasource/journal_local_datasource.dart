import 'package:flutter_application_trek_e/core/network/hive_service.dart';
import 'package:flutter_application_trek_e/app/constant/hive_table_constant.dart';
import 'package:flutter_application_trek_e/features/journal/data/model/journal_hive_model.dart';
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';
import 'package:hive/hive.dart';

abstract interface class IJournalLocalDataSource {
  Future<void> cacheJournals(List<JournalHiveModel> journals);
  Future<List<JournalHiveModel>> getCachedJournals();
  Future<void> clearCachedJournals();

  // Save functionality
  Future<void> saveJournal({
    required String journalId,
    required String userId,
  });

  Future<void> unsaveJournal({
    required String journalId,
    required String userId,
  });

  Future<List<JournalEntity>> getSavedJournals(String userId);

  Future<bool> isJournalSaved({
    required String journalId,
    required String userId,
  });

  Future<void> cacheSavedJournals(String userId, List<JournalEntity> journals);

  // Favorite functionality
  Future<void> favoriteJournal({
    required String journalId,
    required String userId,
  });

  Future<void> unfavoriteJournal({
    required String journalId,
    required String userId,
  });

  Future<List<JournalEntity>> getFavoriteJournals(String userId);

  Future<bool> isJournalFavorited({
    required String journalId,
    required String userId,
  });

  Future<void> cacheFavoriteJournals(String userId, List<JournalEntity> journals);
}

class JournalLocalDataSource implements IJournalLocalDataSource {
  final HiveService hiveService;

  JournalLocalDataSource({required this.hiveService});

  static const String _journalBoxName = HiveTableConstant.journalBox;
  static const String _savedJournalsBoxName = 'savedJournalsBox';
  static const String _favoriteJournalsBoxName = 'favoriteJournalsBox';
  static const String _userSavedIdsBoxName = 'userSavedIdsBox';
  static const String _userFavoriteIdsBoxName = 'userFavoriteIdsBox';

  // Original journal caching methods
  @override
  Future<void> cacheJournals(List<JournalHiveModel> journals) async {
    final box = await _openJournalBox();
    await box.clear();
    await box.addAll(journals);
  }

  @override
  Future<List<JournalHiveModel>> getCachedJournals() async {
    final box = await _openJournalBox();
    return box.values.toList();
  }

  @override
  Future<void> clearCachedJournals() async {
    final box = await _openJournalBox();
    await box.clear();
  }

  // Save functionality implementation
  @override
  Future<void> saveJournal({
    required String journalId,
    required String userId,
  }) async {
    final box = await _openUserSavedIdsBox();
    List<String> savedIds = box.get(userId, defaultValue: <String>[])!;
    
    if (!savedIds.contains(journalId)) {
      savedIds.add(journalId);
      await box.put(userId, savedIds);
    }
  }

  @override
  Future<void> unsaveJournal({
    required String journalId,
    required String userId,
  }) async {
    final box = await _openUserSavedIdsBox();
    List<String> savedIds = box.get(userId, defaultValue: <String>[])!;
    
    savedIds.remove(journalId);
    await box.put(userId, savedIds);
  }

  @override
  Future<List<JournalEntity>> getSavedJournals(String userId) async {
    final box = await _openSavedJournalsBox();
    final savedJournals = box.get(userId, defaultValue: <JournalEntity>[])!;
    return savedJournals;
  }

  @override
  Future<bool> isJournalSaved({
    required String journalId,
    required String userId,
  }) async {
    final box = await _openUserSavedIdsBox();
    List<String> savedIds = box.get(userId, defaultValue: <String>[])!;
    return savedIds.contains(journalId);
  }

  @override
  Future<void> cacheSavedJournals(String userId, List<JournalEntity> journals) async {
    final box = await _openSavedJournalsBox();
    await box.put(userId, journals);
    
    // Also update the saved IDs list
    final idsBox = await _openUserSavedIdsBox();
    final savedIds = journals.map((journal) => journal.id).toList();
    await idsBox.put(userId, savedIds);
  }

  // Favorite functionality implementation
  @override
  Future<void> favoriteJournal({
    required String journalId,
    required String userId,
  }) async {
    final box = await _openUserFavoriteIdsBox();
    List<String> favoriteIds = box.get(userId, defaultValue: <String>[])!;
    
    if (!favoriteIds.contains(journalId)) {
      favoriteIds.add(journalId);
      await box.put(userId, favoriteIds);
    }
  }

  @override
  Future<void> unfavoriteJournal({
    required String journalId,
    required String userId,
  }) async {
    final box = await _openUserFavoriteIdsBox();
    List<String> favoriteIds = box.get(userId, defaultValue: <String>[])!;
    
    favoriteIds.remove(journalId);
    await box.put(userId, favoriteIds);
  }

  @override
  Future<List<JournalEntity>> getFavoriteJournals(String userId) async {
    final box = await _openFavoriteJournalsBox();
    final favoriteJournals = box.get(userId, defaultValue: <JournalEntity>[])!;
    return favoriteJournals;
  }

  @override
  Future<bool> isJournalFavorited({
    required String journalId,
    required String userId,
  }) async {
    final box = await _openUserFavoriteIdsBox();
    List<String> favoriteIds = box.get(userId, defaultValue: <String>[])!;
    return favoriteIds.contains(journalId);
  }

  @override
  Future<void> cacheFavoriteJournals(String userId, List<JournalEntity> journals) async {
    final box = await _openFavoriteJournalsBox();
    await box.put(userId, journals);
    
    // Also update the favorite IDs list
    final idsBox = await _openUserFavoriteIdsBox();
    final favoriteIds = journals.map((journal) => journal.id).toList();
    await idsBox.put(userId, favoriteIds);
  }

  // Helper methods to open different boxes
  Future<Box<JournalHiveModel>> _openJournalBox() async {
    return await hiveService.openBox<JournalHiveModel>(_journalBoxName);
  }

  Future<Box<List<JournalEntity>>> _openSavedJournalsBox() async {
    return await hiveService.openBox<List<JournalEntity>>(_savedJournalsBoxName);
  }

  Future<Box<List<JournalEntity>>> _openFavoriteJournalsBox() async {
    return await hiveService.openBox<List<JournalEntity>>(_favoriteJournalsBoxName);
  }

  Future<Box<List<String>>> _openUserSavedIdsBox() async {
    return await hiveService.openBox<List<String>>(_userSavedIdsBoxName);
  }

  Future<Box<List<String>>> _openUserFavoriteIdsBox() async {
    return await hiveService.openBox<List<String>>(_userFavoriteIdsBoxName);
  }
}