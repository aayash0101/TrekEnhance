import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';
import 'package:flutter_application_trek_e/features/journal/domain/repository/journal_repository.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/get_journal_with_status_params.dart';

class GetJournalsWithStatusUseCase {
  final IJournalRepository repository;

  GetJournalsWithStatusUseCase(this.repository);

  Future<Either<Failure, List<JournalEntity>>> call(GetJournalsWithStatusParams params) {
    return repository.getJournalsWithStatus(
      journals: params.journals,
      userId: params.userId,
    );
  }
}