import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pet_adoption_app/data/datasources/favorites_local_datasource.dart';
import 'package:pet_adoption_app/data/datasources/pet_cache_datasource.dart';
import 'package:pet_adoption_app/domain/entities/pet.dart';
import 'package:pet_adoption_app/domain/repositories/pet_repository.dart';

// Events
abstract class FavoritesEvent {}

class LoadFavorites extends FavoritesEvent {}

class ToggleFavorite extends FavoritesEvent {
  final String petId;
  ToggleFavorite(this.petId);
}

// States
abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Pet> favoritePets;
  final Set<String> favoriteIds;

  FavoritesLoaded({
    required this.favoritePets,
    required this.favoriteIds,
  });
}

class FavoritesError extends FavoritesState {
  final String message;
  FavoritesError(this.message);
}

@injectable
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesLocalDataSource _favoritesLocalDataSource;
  final PetRepository _petRepository;
  final PetCacheDataSource _petCacheDataSource;

  FavoritesBloc(
    this._favoritesLocalDataSource,
    this._petRepository,
    this._petCacheDataSource,
  ) : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      emit(FavoritesLoading());

      // Get favorite IDs
      final favoriteIds = await _favoritesLocalDataSource.getFavoriteIds();

      if (favoriteIds.isEmpty) {
        emit(FavoritesLoaded(
          favoritePets: [],
          favoriteIds: <String>{},
        ));
        return;
      }

      // Try to get pets from the shared cache first (faster)
      final List<Pet> favoritePets = [];
      final List<String> missingPetIds = [];

      for (final petId in favoriteIds) {
        final cachedPet = await _petCacheDataSource.getCachedPet(petId);
        if (cachedPet != null) {
          favoritePets.add(cachedPet);
        } else {
          missingPetIds.add(petId);
        }
      }

      // If some pets are not in the shared cache, try local favorites cache
      if (missingPetIds.isNotEmpty) {
        final localFavorites =
            await _favoritesLocalDataSource.getFavoritePets();
        final Map<String, Pet> localFavoritesMap = {
          for (final pet in localFavorites) pet.id: pet
        };

        for (final petId in missingPetIds.toList()) {
          final localPet = localFavoritesMap[petId];
          if (localPet != null) {
            favoritePets.add(localPet);
            missingPetIds.remove(petId);
            // Cache in shared cache for future use
            await _petCacheDataSource.cachePet(localPet);
          }
        }
      }

      // Only fetch from API if absolutely necessary
      if (missingPetIds.isNotEmpty) {
        try {
          final allPets = await _petRepository.getPets(limit: 100, page: 0);
          final missingPets =
              allPets.where((pet) => missingPetIds.contains(pet.id)).toList();

          for (final pet in missingPets) {
            favoritePets.add(pet);
            // Cache in both shared cache and local favorites cache
            await _petCacheDataSource.cachePet(pet);
            await _favoritesLocalDataSource.cacheFavoritePet(pet);
          }
        } catch (e) {
          // If API fails, continue with what we have
          print('Failed to fetch missing pets from API: $e');
        }
      }

      emit(FavoritesLoaded(
        favoritePets: favoritePets,
        favoriteIds: favoriteIds.toSet(),
      ));
    } catch (e) {
      emit(FavoritesError('Failed to load favorites: ${e.toString()}'));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final isFavorite =
          await _favoritesLocalDataSource.isFavorite(event.petId);

      if (isFavorite) {
        await _favoritesLocalDataSource.removeFromFavorites(event.petId);
      } else {
        // When adding to favorites, try to get pet data from shared cache first
        Pet? petData = await _petCacheDataSource.getCachedPet(event.petId);

        if (petData != null) {
          // Use cached pet data
          await _favoritesLocalDataSource.addToFavorites(event.petId,
              petData: petData);
        } else {
          // Try to fetch from API if not in cache
          try {
            petData = await _petRepository.getPetById(event.petId);
            if (petData != null) {
              // Cache in shared cache for future use
              await _petCacheDataSource.cachePet(petData);
              await _favoritesLocalDataSource.addToFavorites(event.petId,
                  petData: petData);
            } else {
              await _favoritesLocalDataSource.addToFavorites(event.petId);
            }
          } catch (e) {
            // If fetching pet data fails, still add to favorites without data
            await _favoritesLocalDataSource.addToFavorites(event.petId);
          }
        }
      }

      // Reload favorites
      add(LoadFavorites());
    } catch (e) {
      emit(FavoritesError('Failed to toggle favorite: ${e.toString()}'));
    }
  }

  Future<bool> isFavorite(String petId) async {
    return await _favoritesLocalDataSource.isFavorite(petId);
  }
}
