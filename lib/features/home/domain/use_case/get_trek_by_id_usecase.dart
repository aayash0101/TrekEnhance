import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/app/use_case/usecase.dart';
import 'package:flutter_application_trek_e/core/error/faliure.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';
import 'package:flutter_application_trek_e/features/home/domain/repository/home_repository.dart';

class GetTrekByIdUsecase implements UsecaseWithParams<TrekEntity, String> {
  final IHomeRepository repository;

  GetTrekByIdUsecase(this.repository);

  @override
  Future<Either<Failure, TrekEntity>> call(String id) {
    return repository.getTrekById(id);
  }
}
