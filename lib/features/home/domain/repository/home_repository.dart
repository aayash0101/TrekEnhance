import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/faliure.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/review_entity.dart';

abstract interface class IHomeRepository {
  /// Get all treks
  Future<Either<Failure, List<TrekEntity>>> getAllTreks();

  /// Get a single trek by ID
  Future<Either<Failure, TrekEntity>> getTrekById(String id);

  /// Add review to a trek
  Future<Either<Failure, List<ReviewEntity>>> addReview({
    required String trekId,
    required String userId,
    required String username,
    required String review,
  });

  /// Get reviews for a trek
  Future<Either<Failure, List<ReviewEntity>>> getReviews(String trekId);

  /// Get all reviews from all treks (if you use it on homepage)
  Future<Either<Failure, List<ReviewEntity>>> getAllReviewsFromAllTreks();
}
