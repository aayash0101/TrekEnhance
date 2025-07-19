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
        final token = response.data['token'];
        return token;
      } else {
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to login: ${e.message}');
    } catch (e) {
      throw Exception('Failed to login: $e');
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
      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw Exception('Registration failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to register: ${e.message}');
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        'profilePicture': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      Response response = await _apiService.dio.post(
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
    } catch (e) {
      throw Exception('Failed to upload picture: $e');
    }
  }

  @override
  Future<UserEntity> getCurrentUser() {
    // TODO: Implement if you have an endpoint like /me or /profile
    throw UnimplementedError();
  }
}
