abstract class HomeEvent {}

class LoadTreks extends HomeEvent {}

class SearchTreks extends HomeEvent {
  final String query;
  SearchTreks(this.query);
}
