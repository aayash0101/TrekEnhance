import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/faliure.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';


abstract interface class IUserRepository {
  Future<Either<Failure, void>> registerUser(UserEntity student);

  Future<Either<Failure, String>> loginStudent(
    String username,
    String password,
  );

  Future<Either<Failure, String>> uploadProfilePicture(File file);

  Future<Either<Failure, UserEntity>> getCurrentUser();
}