import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_trek_e/features/home/domain/repository/home_repository.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeViewModel extends Bloc<HomeEvent, HomeState> {
  final IHomeRepository repository;

  // Keep the original list to use for searching
  List<TrekEntity> _allTreks = [];

  HomeViewModel(this.repository) : super(HomeInitial()) {
    on<LoadTreks>(_onLoadTreks);
    on<SearchTreks>(_onSearchTreks);
  }

  Future<void> _onLoadTreks(LoadTreks event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    final result = await repository.getAllTreks();

    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (treks) {
        _allTreks = treks;
        emit(HomeLoaded(treks));
      },
    );
  }

  void _onSearchTreks(SearchTreks event, Emitter<HomeState> emit) {
    if (event.query.isEmpty) {
      emit(HomeLoaded(_allTreks));
    } else {
      final filtered = _allTreks.where((trek) =>
        trek.name.toLowerCase().contains(event.query.toLowerCase())
      ).toList();
      emit(HomeLoaded(filtered));
    }
  }
}
