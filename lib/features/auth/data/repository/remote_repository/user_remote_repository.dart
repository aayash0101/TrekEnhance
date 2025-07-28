import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/auth/data/data_source/user_datasource.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_trek_e/features/auth/domain/repository/user_repository.dart';

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
  Future<Either<Failure, String>> loginUser(String username, String password) async {
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
      return Left(RemoteDatabaseFailure(message: "Failed to upload picture: $e"));
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
  }) async {
    try {
      final updatedUser = await remoteDataSource.updateUserProfile(
        username: username,
        bio: bio,
        location: location,
      );
      return Right(updatedUser);
    } catch (e, stackTrace) {
      print('❌ updateUserProfile failed: $e\n$stackTrace');
      return Left(RemoteDatabaseFailure(message: "Failed to update profile: $e"));
    }
  }
}
