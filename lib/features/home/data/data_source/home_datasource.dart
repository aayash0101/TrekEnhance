import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/review_entity.dart';

abstract interface class IHomeLocalDataSource {
  /// Cache list of treks locally
  Future<void> cacheTreks(List<TrekEntity> treks);

  /// Get cached treks from local storage
  Future<List<TrekEntity>> getCachedTreks();

  /// Clear cached treks
  Future<void> clearCache();
}

abstract interface class IHomeRemoteDataSource {
  /// Fetch all treks from remote API
  Future<List<TrekEntity>> getAllTreks();

  /// Fetch trek details by ID from remote API
  Future<TrekEntity> getTrekById(String id);

  /// Fetch all reviews from all treks from remote API
  Future<List<ReviewEntity>> getAllReviewsFromAllTreks();

  /// Add review to a trek by trekId
  Future<void> addReview({
    required String trekId,
    required String userId,
    required String username,
    required String review,
  });
}
