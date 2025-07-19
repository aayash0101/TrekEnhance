import 'dart:io';

import 'package:flutter_application_trek_e/features/auth/data/data_source/user_datasource.dart';
import 'package:flutter_application_trek_e/features/auth/data/model/user_hive_model.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_trek_e/core/network/hive_service.dart';

class UserLocalDataSource implements IUserDataSource {
  final HiveService _hiveService;

  UserLocalDataSource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<void> registerUser(UserEntity user) async {
    final userHiveModel = UserHiveModel.fromEntity(user);
    await _hiveService.register(userHiveModel);
  }

  @override
  Future<String> loginUser(String username, String password) async {
    final user = await _hiveService.login(username, password);
    if (user != null) {
      return "Login successful";
    } else {
      throw Exception("Invalid username or password");
    }
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    final user = await _hiveService.getCurrentUser();
    if (user != null) {
      return user.toEntity();
    } else {
      throw Exception("No user logged in");
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) {
    // Not implemented for local data source
    throw UnimplementedError();
  }
}
