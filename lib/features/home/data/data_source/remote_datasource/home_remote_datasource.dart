import 'package:dio/dio.dart';
import 'package:flutter_application_trek_e/app/constant/api_endpoint.dart';
import 'package:flutter_application_trek_e/features/home/data/data_source/home_datasource.dart';
import 'package:flutter_application_trek_e/features/home/data/model/trek_api_model.dart';
import 'package:flutter_application_trek_e/features/home/data/model/review_api_model.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/review_entity.dart';

class HomeRemoteDatasource implements IHomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDatasource({required this.dio});

  @override
  Future<List<TrekEntity>> getAllTreks() async {
    final response = await dio.get(
      ApiEndpoints.trekBaseUrl + ApiEndpoints.getAllTreks,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data
          .map((json) => TrekApiModel.fromJson(json).toEntity())
          .toList();
    } else {
      throw Exception('Failed to fetch treks');
    }
  }

  @override
  Future<TrekEntity> getTrekById(String id) async {
    final response = await dio.get(
      ApiEndpoints.trekBaseUrl + ApiEndpoints.getTrekById(id),
    );
    if (response.statusCode == 200) {
      return TrekApiModel.fromJson(response.data).toEntity();
    } else {
      throw Exception('Failed to fetch trek details');
    }
  }

  @override
  Future<List<ReviewEntity>> getAllReviewsFromAllTreks() async {
    final response = await dio.get(
      ApiEndpoints.trekBaseUrl + ApiEndpoints.getAllReviewsFromAllTreks,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;

      final List<ReviewEntity> allReviews = [];

      for (final trekJson in data) {
        final trekReviews = trekJson['reviews'] as List<dynamic>? ?? [];
        for (final reviewJson in trekReviews) {
          allReviews.add(ReviewApiModel.fromJson(reviewJson).toEntity());
        }
      }

      return allReviews;
    } else {
      throw Exception('Failed to fetch reviews');
    }
  }

  @override
  Future<List<ReviewEntity>> getReviews(String trekId) async {
    final response = await dio.get(
      ApiEndpoints.trekBaseUrl + ApiEndpoints.getReviews(trekId),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data
          .map((json) => ReviewApiModel.fromJson(json).toEntity())
          .toList();
    } else {
      throw Exception('Failed to fetch reviews for trek $trekId');
    }
  }

  @override
  Future<void> addReview({
    required String trekId,
    required String userId,
    required String username,
    required String review,
  }) async {
    final response = await dio.post(
      ApiEndpoints.trekBaseUrl + ApiEndpoints.addReview(trekId),
      data: {
        "userId": userId,
        "username": username,
        "review": review,
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add review');
    }
  }
}
