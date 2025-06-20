import 'dart:io';

import 'package:flutter_application_trek_e/core/network/hive_service.dart';
import 'package:flutter_application_trek_e/features/auth/data/data_source/user_datasource.dart';
import 'package:flutter_application_trek_e/features/auth/data/model/user_hive_model.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';


class UserLocalDatasource implements IUserDataSource{
  final HiveService _hiveService;

  UserLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<String> loginStudent(String username, String password) async {
    try {
      final studentData = await _hiveService.login(username, password);
      if (studentData != null && studentData.password == password) {
        return "Login successful";
      } else {
        throw Exception("Invalid username or password");
      }
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  @override
  Future<void> registerStudent(UserEntity student) async {
    try {
      // Convert StudentEntity to Hive model if necessary
      final studentHiveModel = UserHiveModel.fromEntity(student);
      await _hiveService.register(studentHiveModel);
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) {
    // TODO: implement uploadProfilePicture
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    // TODO: implement uploadProfilePicture
    throw UnimplementedError();
  }
}