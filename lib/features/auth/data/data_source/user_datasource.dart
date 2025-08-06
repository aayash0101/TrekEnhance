import 'dart:io';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';

abstract class IUserDataSource {
  Future<String> loginUser(String username, String password);
  Future<void> registerUser(UserEntity userData);
  Future<String> uploadProfilePicture(File file);
  Future<UserEntity> getCurrentUser();
  Future<UserEntity> updateUserProfile({
    required String username,
    String? bio,
    String? location,
    String? profileImageUrl,
  });
  Future<void> logout();

  // New methods for journals
  Future<List<JournalEntity>> getSavedJournals();
  Future<List<JournalEntity>> getFavoriteJournals();
}
