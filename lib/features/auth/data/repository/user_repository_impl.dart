import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/faliure.dart';
import 'package:flutter_application_trek_e/features/auth/data/data_source/user_datasource.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_trek_e/features/auth/domain/repository/user_repository.dart';

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
      // Optionally cache locally
      await localDataSource.registerUser(user);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> loginStudent(String username, String password) async {
    try {
      final token = await remoteDataSource.loginUser(username, password);
      // Optionally save logged-in user info locally, e.g., in Hive
      return Right(token);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    try {
      final imageUrlOrName = await remoteDataSource.uploadProfilePicture(file);
      return Right(imageUrlOrName);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      // Try local first (fast + offline)
      final user = await localDataSource.getCurrentUser();
      return Right(user);
    } catch (_) {
      try {
        // Fallback to remote (needs /me or /profile endpoint)
        final user = await remoteDataSource.getCurrentUser();
        return Right(user);
      } catch (e) {
        return Left(Failure(message: e.toString()));
      }
    }
  }
}
