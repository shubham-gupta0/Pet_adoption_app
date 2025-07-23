part of 'list_bloc.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();
  @override
  List<Object> get props => [];
}

class FetchFavoriteList extends ListEvent {}

class FetchHistoryList extends ListEvent {}