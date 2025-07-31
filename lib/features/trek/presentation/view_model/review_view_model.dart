import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';
import 'package:flutter_application_trek_e/features/home/domain/use_case/get_all_treks_usecase.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewViewModel extends Bloc<ReviewEvent, ReviewState> {
  final GetAllTreksUsecase getAllTreksUsecase;

  ReviewViewModel({required this.getAllTreksUsecase}) : super(ReviewInitial()) {
    on<LoadAllReviews>((event, emit) async {
      emit(ReviewLoading());

      final Either<Failure, List<TrekEntity>> result = await getAllTreksUsecase();

      result.fold(
        (failure) => emit(ReviewError(failure.toString())),
        (treks) => emit(ReviewLoaded(treks)),
      );
    });
  }
}
