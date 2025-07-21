import 'package:flutter_application_trek_e/features/home/data/model/home_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeViewModel extends Bloc<HomeEvent, HomeState> {
  HomeViewModel() : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(
      LoadHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      // Simulate fetching data
      await Future.delayed(Duration(seconds: 1));

      final items = [
        HomeModel(title: 'Everest Base Camp', imageUrl: 'assets/images/everest.jpg', description: 'Hard trek to EBC'),
        HomeModel(title: 'Annapurna Base Camp', imageUrl: 'assets/images/annapurna.jpg', description: 'Moderate trek'),
      ];

      emit(HomeLoaded(items));
    } catch (e) {
      emit(HomeError('Failed to load data'));
    }
  }
}
