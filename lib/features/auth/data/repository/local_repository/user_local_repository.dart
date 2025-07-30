import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_trek_e/features/auth/domain/repository/user_repository.dart';

class UserLocalRepository implements IUserRepository {
  final UserLocalDataSource _userLocalDatasource;

  UserLocalRepository({required UserLocalDataSource userLocalDatasource})
      : _userLocalDatasource = userLocalDatasource;

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _userLocalDatasource.registerUser(user);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Failed to register: $e"));
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(String username, String password) async {
    try {
      final result = await _userLocalDatasource.loginUser(username, password);
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Failed to login: $e"));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    try {
      final imageName = await _userLocalDatasource.uploadProfilePicture(file);
      return Right(imageName);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Failed to upload picture: $e"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = await _userLocalDatasource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Failed to get user: $e"));
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
      final updatedUser = await _userLocalDatasource.updateUserProfile(
        username: username,
        bio: bio,
        location: location,
        profileImageUrl: profileImageUrl
      );
      return Right(updatedUser);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Failed to update profile: $e"));
    }
  }
}
