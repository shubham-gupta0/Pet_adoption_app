import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:pet_adoption_app/domain/entities/pet.dart';
import 'package:pet_adoption_app/domain/repositories/pet_repository.dart';

part 'list_event.dart';
part 'list_state.dart';

@injectable
class ListBloc extends Bloc<ListEvent, ListState> {
  final PetRepository _petRepository;

  ListBloc(this._petRepository) : super(ListLoading()) {
    on<FetchFavoriteList>(_onFetchFavorites);
    on<FetchHistoryList>(_onFetchHistory);
  }

  Future<void> _onFetchFavorites(
      FetchFavoriteList event, Emitter<ListState> emit) async {
    emit(ListLoading());
    try {
      final favoriteIds = await _petRepository.getFavoritePetIds();
      final List<Pet> pets = [];

      // For each favorite ID, get the pet details
      for (final id in favoriteIds) {
        final pet = await _petRepository.getPetById(id);
        if (pet != null) {
          pets.add(pet);
        }
      }

      emit(ListLoaded(pets));
    } catch (e) {
      emit(ListError("Failed to load favorites: ${e.toString()}"));
    }
  }

  Future<void> _onFetchHistory(
      FetchHistoryList event, Emitter<ListState> emit) async {
    emit(ListLoading());
    try {
      final pets = await _petRepository.getAdoptedPets();
      emit(ListLoaded(pets));
    } catch (e) {
      emit(ListError("Failed to load history: ${e.toString()}"));
    }
  }
}
