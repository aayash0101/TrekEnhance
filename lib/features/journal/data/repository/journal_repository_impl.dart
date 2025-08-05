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
      final entities = apiModels.map((model) => model.toEntity()).toList();
      return Right(entities);
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
      final entities = apiModels.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<JournalEntity>>> getJournalsByUser(String userId) async {
    try {
      final apiModels = await remoteDataSource.getJournalsByUser(userId);
      final entities = apiModels.map((model) => model.toEntity()).toList();
      return Right(entities);
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

  // Save/Unsave functionality
  @override
  Future<Either<Failure, bool>> saveJournal({
    required String journalId,
    required String userId,
  }) async {
    try {
      // Try remote first
      final success = await remoteDataSource.saveJournal(
        journalId: journalId,
        userId: userId,
      );
      
      // Also save locally for offline access
      if (success) {
        await localDataSource.saveJournal(journalId: journalId, userId: userId);
      }
      
      return Right(success);
    } catch (e) {
      // Fallback to local storage if remote fails
      try {
        await localDataSource.saveJournal(journalId: journalId, userId: userId);
        return const Right(true);
      } catch (localError) {
        return Left(RemoteDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> unsaveJournal({
    required String journalId,
    required String userId,
  }) async {
    try {
      // Try remote first
      final success = await remoteDataSource.unsaveJournal(
        journalId: journalId,
        userId: userId,
      );
      
      // Also remove from local storage
      if (success) {
        await localDataSource.unsaveJournal(journalId: journalId, userId: userId);
      }
      
      return Right(success);
    } catch (e) {
      // Fallback to local storage if remote fails
      try {
        await localDataSource.unsaveJournal(journalId: journalId, userId: userId);
        return const Right(true);
      } catch (localError) {
        return Left(RemoteDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<JournalEntity>>> getSavedJournals(String userId) async {
    try {
      // Try to get from remote first
      final apiModels = await remoteDataSource.getSavedJournals(userId);
      final entities = apiModels.map((model) => model.toEntity()).toList();
      
      // Update local cache
      await localDataSource.cacheSavedJournals(userId, entities);
      
      return Right(entities);
    } catch (e) {
      // Fallback to local storage
      try {
        final localEntities = await localDataSource.getSavedJournals(userId);
        return Right(localEntities);
      } catch (localError) {
        return Left(RemoteDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> isJournalSaved({
    required String journalId,
    required String userId,
  }) async {
    try {
      // Check remote first
      final isSaved = await remoteDataSource.isJournalSaved(
        journalId: journalId,
        userId: userId,
      );
      return Right(isSaved);
    } catch (e) {
      // Fallback to local storage
      try {
        final isSaved = await localDataSource.isJournalSaved(
          journalId: journalId,
          userId: userId,
        );
        return Right(isSaved);
      } catch (localError) {
        return Left(RemoteDatabaseFailure(message: e.toString()));
      }
    }
  }

  // Favorite functionality
  @override
  Future<Either<Failure, bool>> favoriteJournal({
    required String journalId,
    required String userId,
  }) async {
    try {
      final success = await remoteDataSource.favoriteJournal(
        journalId: journalId,
        userId: userId,
      );
      
      // Also save locally for offline access
      if (success) {
        await localDataSource.favoriteJournal(journalId: journalId, userId: userId);
      }
      
      return Right(success);
    } catch (e) {
      // Fallback to local storage if remote fails
      try {
        await localDataSource.favoriteJournal(journalId: journalId, userId: userId);
        return const Right(true);
      } catch (localError) {
        return Left(RemoteDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> unfavoriteJournal({
    required String journalId,
    required String userId,
  }) async {
    try {
      final success = await remoteDataSource.unfavoriteJournal(
        journalId: journalId,
        userId: userId,
      );
      
      // Also remove from local storage
      if (success) {
        await localDataSource.unfavoriteJournal(journalId: journalId, userId: userId);
      }
      
      return Right(success);
    } catch (e) {
      // Fallback to local storage if remote fails
      try {
        await localDataSource.unfavoriteJournal(journalId: journalId, userId: userId);
        return const Right(true);
      } catch (localError) {
        return Left(RemoteDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<JournalEntity>>> getFavoriteJournals(String userId) async {
    try {
      final apiModels = await remoteDataSource.getFavoriteJournals(userId);
      final entities = apiModels.map((model) => model.toEntity()).toList();
      
      // Update local cache
      await localDataSource.cacheFavoriteJournals(userId, entities);
      
      return Right(entities);
    } catch (e) {
      // Fallback to local storage
      try {
        final localEntities = await localDataSource.getFavoriteJournals(userId);
        return Right(localEntities);
      } catch (localError) {
        return Left(RemoteDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> isJournalFavorited({
    required String journalId,
    required String userId,
  }) async {
    try {
      final isFavorited = await remoteDataSource.isJournalFavorited(
        journalId: journalId,
        userId: userId,
      );
      return Right(isFavorited);
    } catch (e) {
      // Fallback to local storage
      try {
        final isFavorited = await localDataSource.isJournalFavorited(
          journalId: journalId,
          userId: userId,
        );
        return Right(isFavorited);
      } catch (localError) {
        return Left(RemoteDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<JournalEntity>>> getJournalsWithStatus({
    required List<JournalEntity> journals,
    required String userId,
  }) async {
    try {
      // Get saved and favorite journal IDs for the current user
      final savedResult = await getSavedJournals(userId);
      final favoriteResult = await getFavoriteJournals(userId);
      
      List<String> savedIds = [];
      List<String> favoriteIds = [];
      
      savedResult.fold(
        (failure) => savedIds = [],
        (savedJournals) => savedIds = savedJournals.map((j) => j.id).toList(),
      );
      
      favoriteResult.fold(
        (failure) => favoriteIds = [],
        (favoriteJournals) => favoriteIds = favoriteJournals.map((j) => j.id).toList(),
      );
      
      // Update journals with their save/favorite status
      final updatedJournals = journals.map((journal) {
        return journal.copyWith(
          isSaved: savedIds.contains(journal.id),
          isFavorite: favoriteIds.contains(journal.id),
        );
      }).toList();
      
      return Right(updatedJournals);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}