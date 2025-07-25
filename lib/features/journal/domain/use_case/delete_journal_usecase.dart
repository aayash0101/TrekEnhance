import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/journal/domain/repository/journal_repository.dart';

class DeleteJournalUsecase {
  final IJournalRepository repository;

  DeleteJournalUsecase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteJournal(id);
  }
}
