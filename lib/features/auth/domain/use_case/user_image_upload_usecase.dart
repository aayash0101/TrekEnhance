import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/app/use_case/usecase.dart';
import 'package:flutter_application_trek_e/core/error/faliure.dart';
import 'package:flutter_application_trek_e/features/auth/domain/repository/user_repository.dart';

class UploadImageParams {
  final File file;

  const UploadImageParams({required this.file});
}

class UploadImageUsecase
    implements UsecaseWithParams<String, UploadImageParams> {
  final IUserRepository _studentRepository;

  UploadImageUsecase({required IUserRepository studentRepository})
    : _studentRepository = studentRepository;

  @override
  Future<Either<Failure, String>> call(UploadImageParams params) {
    return _studentRepository.uploadProfilePicture(params.file);
  }
}