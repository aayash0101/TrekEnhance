import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/app/use_case/usecase.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/review_entity.dart';
import 'package:flutter_application_trek_e/features/home/domain/repository/home_repository.dart';

class GetAllReviewsFromAllTreksUsecase implements UsecaseWithoutParams<List<ReviewEntity>> {
  final IHomeRepository repository;

  GetAllReviewsFromAllTreksUsecase(this.repository);

  @override
  Future<Either<Failure, List<ReviewEntity>>> call() {
    return repository.getAllReviewsFromAllTreks();
  }
}
