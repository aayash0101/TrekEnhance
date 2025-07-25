import 'package:flutter_application_trek_e/core/network/hive_service.dart';
import 'package:flutter_application_trek_e/app/constant/hive_table_constant.dart';
import 'package:flutter_application_trek_e/features/journal/data/model/journal_hive_model.dart';
import 'package:hive/hive.dart';

abstract interface class IJournalLocalDataSource {
  Future<void> cacheJournals(List<JournalHiveModel> journals);
  Future<List<JournalHiveModel>> getCachedJournals();
  Future<void> clearCachedJournals();
}

class JournalLocalDataSource implements IJournalLocalDataSource {
  final HiveService hiveService;

  JournalLocalDataSource({required this.hiveService});

  static const String _boxName = HiveTableConstant.journalBox;  // e.g., "journalBox"

  /// Cache list of journals
  @override
  Future<void> cacheJournals(List<JournalHiveModel> journals) async {
    final box = await _openBox();
    await box.clear();
    await box.addAll(journals);
  }

  /// Get cached journals
  @override
  Future<List<JournalHiveModel>> getCachedJournals() async {
    final box = await _openBox();
    return box.values.toList();
  }

  /// Clear all cached journals
  @override
  Future<void> clearCachedJournals() async {
    final box = await _openBox();
    await box.clear();
  }

  /// Helper to open the box safely using HiveService
  Future<Box<JournalHiveModel>> _openBox() async {
    return await hiveService.openBox<JournalHiveModel>(_boxName);
  }
}
