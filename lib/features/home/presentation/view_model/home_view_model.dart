import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_trek_e/features/home/domain/repository/home_repository.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeViewModel extends Bloc<HomeEvent, HomeState> {
  final IHomeRepository repository;

  HomeViewModel(this.repository) : super(HomeInitial()) {
    on<LoadTreks>(_onLoadTreks);
  }

  Future<void> _onLoadTreks(LoadTreks event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    final result = await repository.getAllTreks();

    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (treks) => emit(HomeLoaded(treks)),
    );
  }
}
