import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/journal/domain/repository/journal_repository.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/favorite_journal_params.dart';

class FavoriteJournalUseCase {
  final IJournalRepository repository;

  FavoriteJournalUseCase(this.repository);

  Future<Either<Failure, bool>> call(FavoriteJournalParams params) {
    return repository.favoriteJournal(
      journalId: params.journalId,
      userId: params.userId,
    );
  }
}