import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';

abstract interface class IJournalRepository {
  /// Create a new journal entry
  Future<Either<Failure, JournalEntity>> createJournal({
    required String userId,
    required String trekId,
    required String date,
    required String text,
    required List<String> photos,
  });

  /// Get all journal entries (public feed)
  Future<Either<Failure, List<JournalEntity>>> getAllJournals();

  /// Get journals by trek and user
  Future<Either<Failure, List<JournalEntity>>> getJournalsByTrekAndUser({
    required String trekId,
    required String userId,
  });

  /// Get all journals by a user
  Future<Either<Failure, List<JournalEntity>>> getJournalsByUser(String userId);

  /// Update a journal entry by ID
  Future<Either<Failure, JournalEntity>> updateJournal({
    required String id,
    required String date,
    required String text,
    required List<String> photos,
  });

  /// Delete a journal entry by ID
  Future<Either<Failure, bool>> deleteJournal(String id);

  /// Save a journal entry for offline access
  Future<Either<Failure, bool>> saveJournal({
    required String journalId,
    required String userId,
  });

  /// Remove a saved journal entry
  Future<Either<Failure, bool>> unsaveJournal({
    required String journalId,
    required String userId,
  });

  /// Get all saved journal entries by user
  Future<Either<Failure, List<JournalEntity>>> getSavedJournals(String userId);

  /// Check if a journal is saved by user
  Future<Either<Failure, bool>> isJournalSaved({
    required String journalId,
    required String userId,
  });

  /// Add a journal to favorites
  Future<Either<Failure, bool>> favoriteJournal({
    required String journalId,
    required String userId,
  });

  /// Remove a journal from favorites
  Future<Either<Failure, bool>> unfavoriteJournal({
    required String journalId,
    required String userId,
  });

  /// Get all favorite journal entries by user
  Future<Either<Failure, List<JournalEntity>>> getFavoriteJournals(String userId);

  /// Check if a journal is favorited by user
  Future<Either<Failure, bool>> isJournalFavorited({
    required String journalId,
    required String userId,
  });

  /// Get journals with updated save/favorite status for a specific user
  Future<Either<Failure, List<JournalEntity>>> getJournalsWithStatus({
    required List<JournalEntity> journals,
    required String userId,
  });
}
