import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_application_trek_e/app/constant/api_endpoint.dart';
import 'package:flutter_application_trek_e/core/network/api_service.dart';
import 'package:flutter_application_trek_e/core/network/hive_service.dart';
import 'package:flutter_application_trek_e/features/auth/data/data_source/user_datasource.dart';
import 'package:flutter_application_trek_e/features/auth/data/model/user_api_model.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';

class UserRemoteDataSource implements IUserDataSource {
  final ApiService apiService;
  final HiveService hiveService;

  UserRemoteDataSource({required this.apiService, required this.hiveService});

  @override
  Future<String> loginUser(String username, String password) async {
    try {
      final response = await apiService.dio.post(
        '${ApiEndpoints.userBaseUrl}${ApiEndpoints.login}',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final userJson = response.data['user'];

        if (userJson != null && userJson['id'] != null) {
          userJson['_id'] = userJson['id'];
        }

        final userApiModel = UserApiModel.fromJson(userJson);

        if (userApiModel.userId == null) {
          throw Exception('User ID missing in API response.');
        }

        final hiveModel = userApiModel.toHiveModel();
        await hiveService.register(hiveModel);

        return token;
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
      final response = await apiService.dio.post(
        '${ApiEndpoints.userBaseUrl}${ApiEndpoints.register}',
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
      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'profilePicture': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final response = await apiService.dio.post(
        '${ApiEndpoints.userBaseUrl}${ApiEndpoints.uploadImage}',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['data'] ?? '';
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
      final userId = await hiveService.getUserId();
      if (userId == null) throw Exception('User ID not found');

      final url = ApiEndpoints.userBaseUrl + ApiEndpoints.getProfileById(userId);
      final response = await apiService.dio.get(url);

      if (response.statusCode == 200) {
        final userJson = response.data['data'] ?? response.data;

        if (userJson != null && userJson['id'] != null) {
          userJson['_id'] = userJson['id'];
        }

        final userApiModel = UserApiModel.fromJson(userJson);
        return userApiModel.toEntity();
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
    String? profileImageUrl,
  }) async {
    try {
      final userId = await hiveService.getUserId();
      if (userId == null) throw Exception('User ID not found');

      final response = await apiService.dio.put(
        '${ApiEndpoints.userBaseUrl}${ApiEndpoints.updateProfileById(userId)}',
        data: {
          'username': username,
          if (bio != null) 'bio': bio,
          if (location != null) 'location': location,
          if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return UserApiModel.fromJson(data).toEntity();
      } else {
        throw Exception('Failed to update profile: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update profile: ${e.message}');
    }
  }

 @override
Future<void> logout() async {
  try {
    // No backend logout call, just clear local stored data
    await hiveService.clearUserData();
  } catch (e) {
    throw Exception('Logout failed: $e');
  }
}
}
