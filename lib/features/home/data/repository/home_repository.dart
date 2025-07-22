import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/home/data/data_source/remote_datasource/home_remote_datasource.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/review_entity.dart';
import 'package:flutter_application_trek_e/features/home/domain/repository/home_repository.dart';

class HomeRepository implements IHomeRepository {
  final HomeRemoteDatasource remoteDatasource;

  HomeRepository(this.remoteDatasource);

  @override
  Future<Either<Failure, List<TrekEntity>>> getAllTreks() async {
    try {
      final treks = await remoteDatasource.getAllTreks();
      return Right(treks);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TrekEntity>> getTrekById(String id) async {
    try {
      final trek = await remoteDatasource.getTrekById(id);
      return Right(trek);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> addReview({
    required String trekId,
    required String userId,
    required String username,
    required String review,
  }) async {
    try {
      await remoteDatasource.addReview(
        trekId: trekId,
        userId: userId,
        username: username,
        review: review,
      );

      // After adding review, fetch updated trek to get updated reviews:
      final trek = await remoteDatasource.getTrekById(trekId);
      return Right(trek.reviews ?? []);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getAllReviewsFromAllTreks() async {
    try {
      final allReviews = await remoteDatasource.getAllReviewsFromAllTreks();
      return Right(allReviews);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getReviews(String trekId) async {
    try {
      // Fetch single trek and return its reviews
      final trek = await remoteDatasource.getTrekById(trekId);
      return Right(trek.reviews ?? []);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
