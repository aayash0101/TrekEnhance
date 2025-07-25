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
}
