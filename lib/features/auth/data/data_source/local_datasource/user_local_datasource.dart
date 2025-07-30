import 'dart:io';
import 'package:flutter_application_trek_e/features/auth/data/data_source/user_datasource.dart';
import 'package:flutter_application_trek_e/features/auth/data/model/user_hive_model.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';
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
      print('✅ User logged in locally: ${user.userId}');
      return "Login successful";
    } else {
      print('⚠️ Invalid local login attempt for username: $username');
      throw Exception("Invalid username or password");
    }
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    final user = await hiveService.getCurrentUser();
    if (user != null) {
      print('✅ Got current user from Hive: ${user.userId}');
      return user.toEntity();
    } else {
      print('⚠️ No user found in Hive');
      throw Exception("No user logged in");
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) {
    // Local datasource does not support file uploads
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
      print('✅ Updated user profile in Hive: ${updatedUser.userId}');
      return updatedUser.toEntity();
    } else {
      print('⚠️ Failed to update user: user not found in Hive');
      throw Exception("Failed to update user: user not found");
    }
  }
}
