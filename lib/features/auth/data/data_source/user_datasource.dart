import 'dart:io';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserDataSource {
  /// Register a new user
  Future<void> registerUser(UserEntity userData);

  /// Login and get token
  Future<String> loginUser(String username, String password);

  /// Upload profile picture and get filename/url
  Future<String> uploadProfilePicture(File file);

  /// Get current logged-in user data
  Future<UserEntity> getCurrentUser();
}
