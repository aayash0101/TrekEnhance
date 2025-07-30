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

  /// Login user with username and password, save token and user to Hive locally.
  @override
  Future<String> loginUser(String username, String password) async {
    try {
      print('🔑 Starting loginUser for username: $username');

      final response = await apiService.dio.post(
        '${ApiEndpoints.userBaseUrl}${ApiEndpoints.login}',
        data: {'username': username, 'password': password},
      );

      print('✔ Login API raw response data: ${response.data}');

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final userJson = response.data['user'];

        print('✔ Parsed userJson before mapping: $userJson');

        // Map 'id' → '_id' for consistency with Hive model
        if (userJson != null && userJson['id'] != null) {
          userJson['_id'] = userJson['id'];
        }

        final userApiModel = UserApiModel.fromJson(userJson);
        print(
          '✔ userApiModel.userId (parsed from _id): ${userApiModel.userId}',
        );

        if (userApiModel.userId == null) {
          throw Exception(
            '❌ User ID missing in API response; cannot save to Hive.',
          );
        }

        final hiveModel = userApiModel.toHiveModel();
        print('📦 About to save to Hive with userId: ${hiveModel.userId}');

        await hiveService.register(hiveModel);

        print(
          '✅ Successfully saved user to Hive with userId: ${hiveModel.userId}',
        );
        return token;
      } else {
        print(
          '❌ Login failed: statusCode=${response.statusCode}, message=${response.statusMessage}',
        );
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('⚠️ Dio error during login: ${e.message}');
      if (e.response != null) {
        print('⚠️ Dio error response data: ${e.response?.data}');
      }
      throw Exception('Failed to login: ${e.message}');
    }
  }

  /// Register a new user via API.
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
      print('⚠️ Dio error during register: ${e.message}');
      throw Exception('Failed to register: ${e.message}');
    }
  }

  /// Upload user profile picture file to server.
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
      print('⚠️ Dio error during upload: ${e.message}');
      throw Exception('Failed to upload picture: ${e.message}');
    }
  }

  /// Fetch current user profile from backend using userId stored in Hive.
  @override
  Future<UserEntity> getCurrentUser() async {
    try {
      print('👀 Starting getCurrentUser...');
      final userId = await hiveService.getUserId();
      print('📌 getUserId() returned: $userId');

      if (userId == null) throw Exception('User ID not found in Hive');

      final url =
          ApiEndpoints.userBaseUrl + ApiEndpoints.getProfileById(userId);
      print('🌍 Making API call to: $url');

      final response = await apiService.dio.get(url);

      print(
        '📦 API response status: ${response.statusCode}, data: ${response.data}',
      );

      if (response.statusCode == 200) {
        final userJson = response.data['data'] ?? response.data;

        if (userJson != null && userJson['id'] != null) {
          userJson['_id'] = userJson['id'];
        }

        final userApiModel = UserApiModel.fromJson(userJson);
        print(
          '✅ Successfully mapped API response to UserApiModel with userId: ${userApiModel.userId}',
        );

        return userApiModel.toEntity();
      } else {
        print('❌ Failed to fetch user: ${response.statusMessage}');
        throw Exception('Failed to fetch user: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('⚠️ Dio error during getCurrentUser: ${e.message}');
      if (e.response != null) {
        print('⚠️ Dio error response data: ${e.response?.data}');
      }
      throw Exception('Failed to get user: ${e.message}');
    }
  }

  /// Update current user's profile on backend.
  @override
  Future<UserEntity> updateUserProfile({
    required String username,
    String? bio,
    String? location,
    String? profileImageUrl,
  }) async {
    try {
      final userId = await hiveService.getUserId();
      if (userId == null) throw Exception('User ID not found in Hive');

      print('📌 Updating userId from Hive: $userId');

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
      print('⚠️ Dio error during updateUserProfile: ${e.message}');
      throw Exception('Failed to update profile: ${e.message}');
    }
  }
}
