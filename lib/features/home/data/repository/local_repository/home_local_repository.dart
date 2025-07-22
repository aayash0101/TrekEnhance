import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/home/data/data_source/local_datasource/home_local_datasource.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/review_entity.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';
import 'package:flutter_application_trek_e/features/home/domain/repository/home_repository.dart';

class HomeLocalRepository implements IHomeRepository {
  final HomeLocalDataSource localDatasource;

  HomeLocalRepository(this.localDatasource);

  @override
  Future<Either<Failure, List<TrekEntity>>> getAllTreks() async {
    try {
      final treks = await localDatasource.getCachedTreks();
      return Right(treks);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TrekEntity>> getTrekById(String id) async {
    try {
      final treks = await localDatasource.getCachedTreks();
      final trek = treks.firstWhere((t) => t.id == id, orElse: () => throw Exception('Trek not found'));
      return Right(trek);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> addReview({
    required String trekId,
    required String userId,
    required String username,
    required String review,
  }) async {
    // Local data source might not support adding reviews yet.
    // So returning a failure for now.
    return Left(LocalDatabaseFailure(message: 'Adding review not supported locally'));
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getReviews(String trekId) async {
    try {
      // You need to implement this in your localDatasource if possible.
      // Otherwise, return failure or empty list.
      // Here's an example returning empty list:
      return Right([]);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getAllReviewsFromAllTreks() async {
    try {
      // Same as above, implement if possible
      return Right([]);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
