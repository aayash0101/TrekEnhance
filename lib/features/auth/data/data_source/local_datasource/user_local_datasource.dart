import 'dart:io';
import 'package:flutter_application_trek_e/features/auth/data/data_source/user_datasource.dart';
import 'package:flutter_application_trek_e/features/auth/data/model/user_hive_model.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';
import 'package:flutter_application_trek_e/core/network/hive_service.dart';

class UserLocalDataSource implements IUserDataSource {
  final HiveService hiveService;

  UserLocalDataSource({required this.hiveService});

  @override
  Future<void> registerUser(UserEntity user) async {
    final userHiveModel = UserHiveModel.fromEntity(user);
    await hiveService.register(userHiveModel);
  }

  @override
  Future<String> loginUser(String username, String password) async {
    final user = await hiveService.login(username, password);
    if (user != null) {
      return "Login successful";
    } else {
      throw Exception("Invalid username or password");
    }
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    final user = await hiveService.getCurrentUser();
    if (user != null) {
      return user.toEntity();
    } else {
      throw Exception("No user logged in");
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) {
    throw UnimplementedError('uploadProfilePicture is not supported locally');
  }

  @override
  Future<UserEntity> updateUserProfile({
    required String username,
    String? bio,
    String? location,
    String? profileImageUrl,
  }) async {
    final updatedUser = await hiveService.updateUserProfile(
      username: username,
      bio: bio,
      location: location,
    );
    if (updatedUser != null) {
      return updatedUser.toEntity();
    } else {
      throw Exception("Failed to update user: user not found");
    }
  }

  @override
  Future<void> logout() async {
    await hiveService.clearUserData();
  }

  // === Added methods for saved and favorite journals ===

  Future<List<JournalEntity>> getSavedJournals() async {
    try {
      final savedJournals = await hiveService.getSavedJournals();
      return savedJournals.map((journal) => journal.toEntity()).toList();
    } catch (e) {
      throw Exception("Failed to fetch saved journals: $e");
    }
  }

  Future<List<JournalEntity>> getFavoriteJournals() async {
    try {
      final favoriteJournals = await hiveService.getFavoriteJournals();
      return favoriteJournals.map((journal) => journal.toEntity()).toList();
    } catch (e) {
      throw Exception("Failed to fetch favorite journals: $e");
    }
  }
}
