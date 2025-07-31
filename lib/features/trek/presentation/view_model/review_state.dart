import 'package:equatable/equatable.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final List<TrekEntity> treks;

  const ReviewLoaded(this.treks);

  @override
  List<Object?> get props => [treks];
}

class ReviewError extends ReviewState {
  final String message;

  const ReviewError(this.message);

  @override
  List<Object?> get props => [message];
}
