import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/journal/data/data_source/local_datasource/journal_local_datasource.dart';
import 'package:flutter_application_trek_e/features/journal/data/data_source/remote_datasource/journal_remote_datasource.dart';
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';
import 'package:flutter_application_trek_e/features/journal/domain/repository/journal_repository.dart';

class JournalRepositoryImpl implements IJournalRepository {
  final JournalRemoteDataSource remoteDataSource;
  final JournalLocalDataSource localDataSource;

  JournalRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, JournalEntity>> createJournal({
    required String userId,
    required String trekId,
    required String date,
    required String text,
    required List<String> photos,
  }) async {
    try {
      final apiModel = await remoteDataSource.createJournal(
        userId: userId,
        trekId: trekId,
        date: date,
        text: text,
        photos: photos,
      );
      return Right(apiModel.toEntity());
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<JournalEntity>>> getAllJournals() async {
    try {
      final apiModels = await remoteDataSource.getAllJournals();
      return Right(apiModels.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<JournalEntity>>> getJournalsByTrekAndUser({
    required String trekId,
    required String userId,
  }) async {
    try {
      final apiModels = await remoteDataSource.getJournalsByTrekAndUser(
        trekId: trekId,
        userId: userId,
      );
      return Right(apiModels.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<JournalEntity>>> getJournalsByUser(String userId) async {
    try {
      final apiModels = await remoteDataSource.getJournalsByUser(userId);
      return Right(apiModels.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, JournalEntity>> updateJournal({
    required String id,
    required String date,
    required String text,
    required List<String> photos,
  }) async {
    try {
      final apiModel = await remoteDataSource.updateJournal(
        id: id,
        date: date,
        text: text,
        photos: photos,
      );
      return Right(apiModel.toEntity());
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteJournal(String id) async {
    try {
      final success = await remoteDataSource.deleteJournal(id);
      return Right(success);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
