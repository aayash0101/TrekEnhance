import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';
import 'package:flutter_application_trek_e/features/home/domain/use_case/get_all_treks_usecase.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewViewModel extends Bloc<ReviewEvent, ReviewState> {
  final GetAllTreksUsecase getAllTreksUsecase;

  List<TrekEntity> _allTreks = [];

  ReviewViewModel({required this.getAllTreksUsecase}) : super(ReviewInitial()) {
    on<LoadAllReviews>(_onLoadAllReviews);
    on<SearchReviews>(_onSearchReviews);
  }

  Future<void> _onLoadAllReviews(LoadAllReviews event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    final result = await getAllTreksUsecase();

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (treks) {
        _allTreks = treks;
        emit(ReviewLoaded(treks));
      },
    );
  }

  void _onSearchReviews(SearchReviews event, Emitter<ReviewState> emit) {
    final query = event.query.toLowerCase();

    final filtered = _allTreks.where((trek) =>
      trek.name.toLowerCase().contains(query) ||
      (trek.location?.toLowerCase() ?? '').contains(query)
    ).toList();

    emit(ReviewLoaded(filtered));
  }
}

