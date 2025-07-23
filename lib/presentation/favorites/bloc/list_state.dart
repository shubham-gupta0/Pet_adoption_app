part of 'list_bloc.dart';

abstract class ListState extends Equatable {
  const ListState();
  @override
  List<Object> get props => [];
}

class ListLoading extends ListState {}

class ListLoaded extends ListState {
  final List<Pet> pets;
  const ListLoaded(this.pets);
  @override
  List<Object> get props => [pets];
}

class ListError extends ListState {
  final String message;
  const ListError(this.message);
  @override
  List<Object> get props => [message];
}