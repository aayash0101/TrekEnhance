import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/journal/domain/repository/journal_repository.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/saved_journal_params.dart';

class UnsaveJournalUseCase {
  final IJournalRepository repository;

  UnsaveJournalUseCase(this.repository);

  Future<Either<Failure, bool>> call(SaveJournalParams params) {
    return repository.unsaveJournal(
      journalId: params.journalId,
      userId: params.userId,
    );
  }
}