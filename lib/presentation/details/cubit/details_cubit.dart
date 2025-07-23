import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:pet_adoption_app/domain/entities/pet.dart';
import 'package:pet_adoption_app/domain/repositories/pet_repository.dart';

part 'details_state.dart';

@injectable
class DetailsCubit extends Cubit<DetailsState> {
  final PetRepository _petRepository;

  DetailsCubit(this._petRepository) : super(const DetailsState());

  Future<void> loadPetStatus(Pet pet) async {
    try {
      final isFavorite = await _petRepository.isFavorite(pet.id);
      emit(state.copyWith(
        isAdopted: pet.isAdopted,
        isFavorite: isFavorite,
      ));
    } catch (e) {
      // Handle error
      print("Failed to load pet status: $e");
    }
  }

  Future<void> adoptPet(Pet pet) async {
    if (state.isAdopted) return;
    try {
      await _petRepository.adoptPet(pet.id);
      emit(state.copyWith(isAdopted: true));
    } catch (e) {
      // Handle error, maybe emit an error state
      print("Failed to adopt pet: $e");
    }
  }

  Future<void> toggleFavorite(Pet pet) async {
    try {
      if (state.isFavorite) {
        await _petRepository.removeFromFavorites(pet.id);
      } else {
        await _petRepository.addToFavorites(pet.id);
      }
      emit(state.copyWith(isFavorite: !state.isFavorite));
    } catch (e) {
      // Handle error
      print("Failed to toggle favorite: $e");
    }
  }
}
