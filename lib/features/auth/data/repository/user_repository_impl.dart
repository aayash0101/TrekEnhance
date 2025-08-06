import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/auth/data/data_source/user_datasource.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_trek_e/features/auth/domain/repository/user_repository.dart';
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';

class UserRepositoryImpl implements IUserRepository {
  final IUserDataSource remoteDataSource;
  final IUserDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await remoteDataSource.registerUser(user);
      try {
        await localDataSource.registerUser(user);
      } catch (_) {}
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(String username, String password) async {
    try {
      final token = await remoteDataSource.loginUser(username, password);
      return Right(token);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    try {
      final uploadedUrl = await remoteDataSource.uploadProfilePicture(file);
      return Right(uploadedUrl);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = await localDataSource.getCurrentUser();
      return Right(user);
    } catch (_) {
      try {
        final user = await remoteDataSource.getCurrentUser();
        try {
          await localDataSource.registerUser(user);
        } catch (_) {}
        return Right(user);
      } catch (e) {
        return Left(RemoteDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserProfile({
    required String username,
    String? bio,
    String? location,
    String? profileImageUrl,
  }) async {
    try {
      final updatedUser = await remoteDataSource.updateUserProfile(
        username: username,
        bio: bio,
        location: location,
        profileImageUrl: profileImageUrl,
      );
      try {
        await localDataSource.registerUser(updatedUser);
      } catch (_) {}
      return Right(updatedUser);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<void> logout() async {
    try {
      await localDataSource.logout();
    } catch (_) {
      rethrow;
    }
  }

  /// ✅ New implementations
  @override
  Future<Either<Failure, List<JournalEntity>>> getSavedJournals() async {
    try {
      final journals = await remoteDataSource.getSavedJournals();
      return Right(journals);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<JournalEntity>>> getFavoriteJournals() async {
    try {
      final journals = await remoteDataSource.getFavoriteJournals();
      return Right(journals);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
