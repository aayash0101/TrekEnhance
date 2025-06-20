import 'dart:io';

import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserDataSource {
  Future<void> registerStudent(UserEntity studentData);

  Future<String> loginStudent(String username, String password);

  Future<String> uploadProfilePicture(File file);

  Future<UserEntity> getCurrentUser();
}