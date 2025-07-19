import 'dart:io';
import 'package:flutter_application_trek_e/core/network/hive_service.dart';
import 'package:flutter_application_trek_e/features/auth/data/model/user_hive_model.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_trek_e/features/auth/data/data_source/user_datasource.dart';

class UserLocalDataSource implements IUserDataSource {
  final HiveService _hiveService;

  UserLocalDataSource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<String> loginUser(String username, String password) async {
    try {
      final user = await _hiveService.login(username, password);
      if (user != null && user.password == password) {
        return "Login successful";
      } else {
        throw Exception("Invalid username or password");
      }
    } catch (e) {
      throw Exception("Local login failed: $e");
    }
  }

  @override
  Future<void> registerUser(UserEntity userData) async {
    try {
      final hiveModel = UserHiveModel.fromEntity(userData);
      await _hiveService.register(hiveModel);
    } catch (e) {
      throw Exception("Local registration failed: $e");
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) {
    // Usually local source won't implement this
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    try {
      final user = await _hiveService.getCurrentUser();
      if (user != null) {
        return user.toEntity();
      } else {
        throw Exception("No cached user found");
      }
    } catch (e) {
      throw Exception("Failed to get local user: $e");
    }
  }
}
