part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

class FetchPets extends HomeEvent {
  final bool isRefresh;
  const FetchPets({this.isRefresh = false});

  @override
  List<Object> get props => [isRefresh];
}

class SearchPets extends HomeEvent {
  final String query;
  const SearchPets(this.query);

  @override
  List<Object> get props => [query];
}
