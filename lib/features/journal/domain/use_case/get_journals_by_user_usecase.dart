import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';
import 'package:flutter_application_trek_e/features/journal/domain/repository/journal_repository.dart';


class GetJournalsByUserUsecase {
  final IJournalRepository repository;

  GetJournalsByUserUsecase(this.repository);

  Future<Either<Failure, List<JournalEntity>>> call(String userId) {
    return repository.getJournalsByUser(userId);
  }
}
