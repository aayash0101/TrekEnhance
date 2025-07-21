import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/faliure.dart';
import 'package:flutter_application_trek_e/features/home/data/data_source/remote_datasource/home_remote_datasource.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/review_entity.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';
import 'package:flutter_application_trek_e/features/home/domain/repository/home_repository.dart';

class HomeRemoteRepository implements IHomeRepository {
  final HomeRemoteDatasource remoteDatasource;

  HomeRemoteRepository(this.remoteDatasource);

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
      // After adding a review, fetch updated reviews for that trek
      final updatedReviews = await remoteDatasource.getReviews(trekId);
      return Right(updatedReviews);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getReviews(String trekId) async {
    try {
      final reviews = await remoteDatasource.getReviews(trekId);
      return Right(reviews);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getAllReviewsFromAllTreks() async {
    try {
      final reviews = await remoteDatasource.getAllReviewsFromAllTreks();
      return Right(reviews);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
