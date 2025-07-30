import 'package:equatable/equatable.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/review_entity.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final List<ReviewEntity> reviews;

  const ReviewLoaded(this.reviews);

  @override
  List<Object?> get props => [reviews];
}

class ReviewError extends ReviewState {
  final String message;

  const ReviewError(this.message);

  @override
  List<Object?> get props => [message];
}
