import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/faliure.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserRepository {
  /// Register a new user (remote + optionally local cache)
  Future<Either<Failure, void>> registerUser(UserEntity user);

  /// Login user and return auth token
  Future<Either<Failure, String>> loginUser(
    String username,
    String password,
  );

  /// Upload user's profile picture, returns uploaded filename or URL
  Future<Either<Failure, String>> uploadProfilePicture(File file);

  /// Get currently logged-in user info (try local first, then remote)
  Future<Either<Failure, UserEntity>> getCurrentUser();
}
