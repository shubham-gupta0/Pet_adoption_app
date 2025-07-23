part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Pet> pets;
  final List<Pet> filteredPets;
  final bool hasReachedMax;

  const HomeLoaded({
    required this.pets,
    required this.filteredPets,
    this.hasReachedMax = false,
  });

  HomeLoaded copyWith({
    List<Pet>? pets,
    List<Pet>? filteredPets,
    bool? hasReachedMax,
  }) {
    return HomeLoaded(
      pets: pets ?? this.pets,
      filteredPets: filteredPets ?? this.filteredPets,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [pets, filteredPets, hasReachedMax];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
  @override
  List<Object> get props => [message];
}