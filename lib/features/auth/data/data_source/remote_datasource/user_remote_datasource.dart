import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_application_trek_e/app/constant/api_endpoint.dart';
import 'package:flutter_application_trek_e/core/network/api_service.dart';
import 'package:flutter_application_trek_e/features/auth/data/model/user_api_model.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_trek_e/features/auth/data/data_source/user_datasource.dart';

class UserRemoteDataSource implements IUserDataSource {
  final ApiService _apiService;

  UserRemoteDataSource({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<String> loginUser(String username, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'username': username, 'password': password},
      );
      if (response.statusCode == 200) {
        return response.data['token'];
      } else {
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to login: ${e.message}');
    }
  }

  @override
  Future<void> registerUser(UserEntity userData) async {
    try {
      final userApiModel = UserApiModel.fromEntity(userData);
      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Registration failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to register: ${e.message}');
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        'profilePicture': await MultipartFile.fromFile(file.path, filename: fileName),
      });
      final response = await _apiService.dio.post(
        ApiEndpoints.uploadImage,
        data: formData,
      );
      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception('Upload failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to upload picture: ${e.message}');
    }
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.userBaseUrl + ApiEndpoints.getProfile);
      if (response.statusCode == 200) {
        return UserApiModel.fromJson(response.data['data']).toEntity();
      } else {
        throw Exception('Failed to fetch user: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to get user: ${e.message}');
    }
  }

  @override
  Future<UserEntity> updateUserProfile({
    required String username,
    String? bio,
    String? location,
  }) async {
    try {
      final response = await _apiService.dio.put(
        ApiEndpoints.updateProfile, // e.g., /profile/update
        data: {
          'username': username,
          if (bio != null) 'bio': bio,
          if (location != null) 'location': location,
        },
      );
      if (response.statusCode == 200) {
        return UserApiModel.fromJson(response.data['data']).toEntity();
      } else {
        throw Exception('Failed to update profile: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update profile: ${e.message}');
    }
  }
}
