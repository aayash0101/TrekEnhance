import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllReviews extends ReviewEvent {}

class SearchReviews extends ReviewEvent {
  final String query;

  const SearchReviews(this.query);

  @override
  List<Object?> get props => [query];
}
