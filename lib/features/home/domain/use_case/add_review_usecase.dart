import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/app/use_case/usecase.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/review_entity.dart';
import 'package:flutter_application_trek_e/features/home/domain/repository/home_repository.dart';

class AddReviewParams {
  final String trekId;
  final String userId;
  final String username;
  final String review;

  AddReviewParams({
    required this.trekId,
    required this.userId,
    required this.username,
    required this.review,
  });
}

class AddReviewUsecase implements UsecaseWithParams<List<ReviewEntity>, AddReviewParams> {
  final IHomeRepository repository;

  AddReviewUsecase(this.repository);

  @override
  Future<Either<Failure, List<ReviewEntity>>> call(AddReviewParams params) {
    return repository.addReview(
      trekId: params.trekId,
      userId: params.userId,
      username: params.username,
      review: params.review,
    );
  }
}
