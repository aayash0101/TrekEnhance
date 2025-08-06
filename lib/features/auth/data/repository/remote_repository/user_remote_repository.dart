import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/auth/data/data_source/user_datasource.dart';
import 'package:flutter_application_trek_e/features/auth/data/repository/remote_repository/user_remote_repository.dart'
    as remoteDataSource;
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_trek_e/features/auth/domain/repository/user_repository.dart';
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';

class UserRemoteRepository implements IUserRepository {
  final IUserDataSource remoteDataSource;

  UserRemoteRepository({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await remoteDataSource.registerUser(user);
      return const Right(null);
    } catch (e, stackTrace) {
      print('❌ registerUser failed: $e\n$stackTrace');
      return Left(RemoteDatabaseFailure(message: "Failed to register: $e"));
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(
    String username,
    String password,
  ) async {
    try {
      final token = await remoteDataSource.loginUser(username, password);
      return Right(token);
    } catch (e, stackTrace) {
      print('❌ loginUser failed: $e\n$stackTrace');
      return Left(RemoteDatabaseFailure(message: "Failed to login: $e"));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    try {
      final imageName = await remoteDataSource.uploadProfilePicture(file);
      return Right(imageName);
    } catch (e, stackTrace) {
      print('❌ uploadProfilePicture failed: $e\n$stackTrace');
      return Left(
        RemoteDatabaseFailure(message: "Failed to upload picture: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } catch (e, stackTrace) {
      print('❌ getCurrentUser failed: $e\n$stackTrace');
      return Left(RemoteDatabaseFailure(message: "Failed to get user: $e"));
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
      return Right(updatedUser);
    } catch (e, stackTrace) {
      print('❌ updateUserProfile failed: $e\n$stackTrace');
      return Left(
        RemoteDatabaseFailure(message: "Failed to update profile: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, List<JournalEntity>>> getSavedJournals() async {
    try {
      final journals = await remoteDataSource.getSavedJournals();
      return Right(journals);
    } catch (e, stackTrace) {
      print('❌ getSavedJournals failed: $e\n$stackTrace');
      return Left(
        RemoteDatabaseFailure(message: "Failed to fetch saved journals: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, List<JournalEntity>>> getFavoriteJournals() async {
    try {
      final journals = await remoteDataSource.getFavoriteJournals();
      return Right(journals);
    } catch (e, stackTrace) {
      print('❌ getFavoriteJournals failed: $e\n$stackTrace');
      return Left(
        RemoteDatabaseFailure(message: "Failed to fetch favorite journals: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } catch (e, stackTrace) {
      print('❌ logout failed: $e\n$stackTrace');
      return Left(RemoteDatabaseFailure(message: "Failed to logout: $e"));
    }
  }
}
