import 'package:equatable/equatable.dart';
import 'package:flutter_application_trek_e/features/home/data/model/home_model.dart';


abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<HomeModel> items;

  HomeLoaded(this.items);
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
