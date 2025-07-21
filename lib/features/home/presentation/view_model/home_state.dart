import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';


abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<TrekEntity> treks;
  HomeLoaded(this.treks);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
