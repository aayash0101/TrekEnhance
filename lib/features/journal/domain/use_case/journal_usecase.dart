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

class GetAllJournalsUsecase {
  final IJournalRepository repository;

  GetAllJournalsUsecase(this.repository);

  Future<Either<Failure, List<JournalEntity>>> call() {
    return repository.getAllJournals();
  }
}

class GetJournalsByTrekAndUserUsecase {
  final IJournalRepository repository;

  GetJournalsByTrekAndUserUsecase(this.repository);

  Future<Either<Failure, List<JournalEntity>>> call({
    required String trekId,
    required String userId,
  }) {
    return repository.getJournalsByTrekAndUser(trekId: trekId, userId: userId);
  }
}

class GetJournalsByUserUsecase {
  final IJournalRepository repository;

  GetJournalsByUserUsecase(this.repository);

  Future<Either<Failure, List<JournalEntity>>> call(String userId) {
    return repository.getJournalsByUser(userId);
  }
}

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

class DeleteJournalUsecase {
  final IJournalRepository repository;

  DeleteJournalUsecase(this.repository);

  Future<Either<Failure, bool>> call(String id) {
    return repository.deleteJournal(id);
  }
}
