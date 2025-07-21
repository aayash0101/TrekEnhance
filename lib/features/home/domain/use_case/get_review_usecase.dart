import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/app/use_case/usecase.dart';
import 'package:flutter_application_trek_e/core/error/faliure.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/review_entity.dart';
import 'package:flutter_application_trek_e/features/home/domain/repository/home_repository.dart';

class GetReviewsUsecase implements UsecaseWithParams<List<ReviewEntity>, String> {
  final IHomeRepository repository;

  GetReviewsUsecase(this.repository);

  @override
  Future<Either<Failure, List<ReviewEntity>>> call(String trekId) {
    return repository.getReviews(trekId);
  }
}
