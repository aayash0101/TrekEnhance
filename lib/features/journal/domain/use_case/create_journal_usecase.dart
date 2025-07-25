import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';
import 'package:flutter_application_trek_e/features/journal/domain/repository/journal_repository.dart';


class CreateJournalUsecase {
  final IJournalRepository repository;

  CreateJournalUsecase(this.repository);

  Future<Either<Failure, JournalEntity>> call({
    required String userId,
    required String trekId,
    required String date,
    required String text,
    required List<String> photos,
  }) {
    return repository.createJournal(
      userId: userId,
      trekId: trekId,
      date: date,
      text: text,
      photos: photos,
    );
  }
}
