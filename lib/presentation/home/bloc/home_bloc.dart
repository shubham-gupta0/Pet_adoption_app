import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:pet_adoption_app/domain/entities/pet.dart';
import 'package:pet_adoption_app/domain/usecases/get_pets.dart';
import 'package:rxdart/rxdart.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetPetsUseCase _getPetsUseCase;
  int _currentPage = 0;

  HomeBloc(this._getPetsUseCase) : super(HomeInitial()) {
    on<FetchPets>(_onFetchPets, transformer: _throttleDroppable());
    on<SearchPets>(_onSearchPets);
  }

  Future<void> _onFetchPets(FetchPets event, Emitter<HomeState> emit) async {
    final currentState = state;
    if (currentState is HomeLoaded &&
        currentState.hasReachedMax &&
        !event.isRefresh) {
      return;
    }

    if (event.isRefresh) {
      _currentPage = 0;
      emit(HomeLoading());
    } else if (currentState is HomeInitial) {
      emit(HomeLoading());
    } else if (currentState is HomeLoading) {
      return; // Avoid concurrent fetches
    }

    try {
      final newPets = await _getPetsUseCase(page: _currentPage);
      _currentPage++;

      if (newPets.isEmpty) {
        if (currentState is HomeLoaded) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(const HomeLoaded(
              pets: [], filteredPets: [], hasReachedMax: true));
        }
        return;
      }

      final currentPets = (currentState is HomeLoaded && !event.isRefresh)
          ? currentState.pets
          : <Pet>[];
      final allPets = currentPets + newPets;

      emit(HomeLoaded(pets: allPets, filteredPets: allPets));
    } catch (e) {
      emit(HomeError("Failed to fetch pets: ${e.toString()}"));
    }
  }

  void _onSearchPets(SearchPets event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final loadedState = state as HomeLoaded;
      if (event.query.isEmpty) {
        emit(loadedState.copyWith(filteredPets: loadedState.pets));
      } else {
        final filtered = loadedState.pets
            .where((pet) =>
                pet.name.toLowerCase().contains(event.query.toLowerCase()) ||
                pet.breed.toLowerCase().contains(event.query.toLowerCase()))
            .toList();
        emit(loadedState.copyWith(filteredPets: filtered));
      }
    }
  }
}

// Prevents spamming the API with rapid-fire events
EventTransformer<E> _throttleDroppable<E>() {
  return (events, mapper) {
    return events
        .throttleTime(const Duration(milliseconds: 500))
        .asyncExpand(mapper);
  };
}
