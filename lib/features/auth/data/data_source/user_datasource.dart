import 'dart:io';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserDataSource {
  /// Register a new user
  Future<void> registerUser(UserEntity userData);

  /// Login and get token
  Future<String> loginUser(String username, String password);

  /// Upload profile picture and get filename or URL
  Future<String> uploadProfilePicture(File file);

  /// Get current logged-in user data
  Future<UserEntity> getCurrentUser();

  /// Update user profile and get updated user
  Future<UserEntity> updateUserProfile({
    required String username,
    String? bio,
    String? location,
    String? profileImageUrl,
  });

  /// Logout user (clear local session or call backend logout)
  Future<void> logout();
}
