import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, void>> registerUser(UserEntity user);
  Future<Either<Failure, String>> loginUser(String username, String password);
  Future<Either<Failure, String>> uploadProfilePicture(File file);
  Future<Either<Failure, UserEntity>> getCurrentUser();
  Future<Either<Failure, UserEntity>> updateUserProfile({
    required String username,
    String? bio,
    String? location,
    String? profileImageUrl,
  });
  Future<void> logout();

  /// ✅ New methods
  Future<Either<Failure, List<JournalEntity>>> getSavedJournals();
  Future<Either<Failure, List<JournalEntity>>> getFavoriteJournals();
}
