import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/create_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/delete_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/get_all_journals_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/get_journals_by_trek_and_user_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/get_journals_by_user_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/update_journal_usecase.dart';

class JournalViewModel extends ChangeNotifier {
  final CreateJournalUsecase createJournalUsecase;
  final GetAllJournalsUsecase getAllJournalsUsecase;
  final GetJournalsByTrekAndUserUsecase getJournalsByTrekAndUserUsecase;
  final GetJournalsByUserUsecase getJournalsByUserUsecase;
  final UpdateJournalUsecase updateJournalUsecase;
  final DeleteJournalUsecase deleteJournalUsecase;

  JournalViewModel({
    required this.createJournalUsecase,
    required this.getAllJournalsUsecase,
    required this.getJournalsByTrekAndUserUsecase,
    required this.getJournalsByUserUsecase,
    required this.updateJournalUsecase,
    required this.deleteJournalUsecase,
  });

  List<JournalEntity> _journals = [];          // Original full list
  List<JournalEntity> _filteredJournals = [];  // Filtered list to display

  List<JournalEntity> get journals => _journals;
  List<JournalEntity> get filteredJournals => _filteredJournals;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // Fetch all journals
  Future<void> fetchAllJournals() async {
    _setLoading(true);
    final result = await getAllJournalsUsecase();
    _handleResult(result);
  }

  // Fetch by user
  Future<void> fetchJournalsByUser(String userId) async {
    _setLoading(true);
    final result = await getJournalsByUserUsecase(userId);
    _handleResult(result);
  }

  // Fetch by trek & user
  Future<void> fetchJournalsByTrekAndUser(String trekId, String userId) async {
    _setLoading(true);
    final result = await getJournalsByTrekAndUserUsecase(trekId: trekId, userId: userId);
    _handleResult(result);
  }

  // Create journal
  Future<void> createJournal({
    required String userId,
    required String trekId,
    required String date,
    required String text,
    required List<String> photos,
  }) async {
    _setLoading(true);
    final result = await createJournalUsecase(
      userId: userId,
      trekId: trekId,
      date: date,
      text: text,
      photos: photos,
    );
    result.fold(
      (failure) => _error = failure.message,
      (created) {
        _error = null;
        _journals.add(created);
        _filteredJournals.add(created); // keep filtered updated
      },
    );
    _setLoading(false);
  }

  // Update journal
  Future<void> updateJournal({
    required String id,
    required String date,
    required String text,
    required List<String> photos,
  }) async {
    _setLoading(true);
    final result = await updateJournalUsecase(
      id: id,
      date: date,
      text: text,
      photos: photos,
    );
    result.fold(
      (failure) => _error = failure.message,
      (updated) {
        _error = null;
        final index = _journals.indexWhere((j) => j.id == id);
        if (index != -1) _journals[index] = updated;

        final filteredIndex = _filteredJournals.indexWhere((j) => j.id == id);
        if (filteredIndex != -1) _filteredJournals[filteredIndex] = updated;
      },
    );
    _setLoading(false);
  }

  // Delete journal
  Future<void> deleteJournal(String id) async {
    _setLoading(true);
    final result = await deleteJournalUsecase(id);
    result.fold(
      (failure) => _error = failure.message,
      (_) {
        _journals.removeWhere((j) => j.id == id);
        _filteredJournals.removeWhere((j) => j.id == id);
      },
    );
    _setLoading(false);
  }

  // Filter journals by text (username, trek name, or text)
  void filterJournals(String query) {
    if (query.isEmpty) {
      _filteredJournals = List.from(_journals);
    } else {
      final lowerQuery = query.toLowerCase();
      _filteredJournals = _journals.where((journal) {
        final userName = journal.user?.username?.toLowerCase() ?? '';
        final trekName = journal.trek?.name?.toLowerCase() ?? '';
        final text = journal.text.toLowerCase();

        return userName.contains(lowerQuery) ||
               trekName.contains(lowerQuery) ||
               text.contains(lowerQuery);
      }).toList();
    }
    notifyListeners();
  }

  // Private helpers
  void _handleResult(Either<Failure, List<JournalEntity>> result) {
    result.fold(
      (failure) {
        _error = failure.message;
        _journals = [];
        _filteredJournals = [];
      },
      (data) {
        _error = null;
        _journals = data;
        _filteredJournals = List.from(data);
      },
    );
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
