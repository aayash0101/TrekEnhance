import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';
import 'package:flutter_application_trek_e/features/journal/domain/repository/journal_repository.dart';


class UpdateJournalUsecase {
  final IJournalRepository repository;

  UpdateJournalUsecase(this.repository);

  Future<Either<Failure, JournalEntity>> call({
    required String id,
    required String date,
    required String text,
    required List<String> photos,
  }) {
    return repository.updateJournal(
      id: id,
      date: date,
      text: text,
      photos: photos,
    );
  }
}
