import 'package:injectable/injectable.dart';
import 'package:pet_adoption_app/core/services/network_service.dart';
import 'package:pet_adoption_app/data/datasources/pet_cache_datasource.dart';
import 'package:pet_adoption_app/data/datasources/pet_local_datasource.dart';
import 'package:pet_adoption_app/data/datasources/pet_remote_datasource.dart';
import 'package:pet_adoption_app/domain/entities/pet.dart';
import 'package:pet_adoption_app/domain/repositories/pet_repository.dart';

@Injectable(as: PetRepository)
class PetRepositoryImpl implements PetRepository {
  final PetRemoteDataSource _remoteDataSource;
  final PetLocalDataSource _localDataSource;
  final PetCacheDataSource _cacheDataSource;
  final NetworkService _networkService;

  PetRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._cacheDataSource,
    this._networkService,
  );

  @override
  Future<List<Pet>> getPets({int page = 0, int limit = 20}) async {
    try {
      final isConnected = await _networkService.isConnected();

      if (isConnected) {
        // Try to fetch from remote and cache the result
        try {
          final remotePets =
              await _remoteDataSource.getPets(page: page, limit: limit);
          // Cache the fetched pets
          await _cacheDataSource.cachePets(remotePets);
          return remotePets;
        } catch (e) {
          // If remote fails, fallback to cache
          final cachedPets = await _cacheDataSource.getCachedPets();
          if (cachedPets.isNotEmpty) {
            // Apply pagination to cached data
            final startIndex = page * limit;
            final endIndex = (startIndex + limit).clamp(0, cachedPets.length);
            if (startIndex < cachedPets.length) {
              return cachedPets.sublist(startIndex, endIndex);
            }
          }
          rethrow;
        }
      } else {
        // No network, get from cache
        final cachedPets = await _cacheDataSource.getCachedPets();
        if (cachedPets.isNotEmpty) {
          // Apply pagination to cached data
          final startIndex = page * limit;
          final endIndex = (startIndex + limit).clamp(0, cachedPets.length);
          if (startIndex < cachedPets.length) {
            return cachedPets.sublist(startIndex, endIndex);
          }
        }
        throw Exception('No network connection and no cached data available');
      }
    } catch (e) {
      throw Exception('Failed to get pets: $e');
    }
  }

  @override
  Future<Pet?> getPetById(String id) async {
    try {
      final isConnected = await _networkService.isConnected();

      if (isConnected) {
        // Try to fetch from remote and cache the result
        try {
          final remotePet = await _remoteDataSource.getPetById(id);
          if (remotePet != null) {
            await _cacheDataSource.cachePet(remotePet);
          }
          return remotePet;
        } catch (e) {
          // If remote fails, fallback to cache
          final cachedPet = await _cacheDataSource.getCachedPet(id);
          if (cachedPet != null) {
            return cachedPet;
          }
          rethrow;
        }
      } else {
        // No network, get from cache
        final cachedPet = await _cacheDataSource.getCachedPet(id);
        if (cachedPet != null) {
          return cachedPet;
        }
        throw Exception('No network connection and no cached data available');
      }
    } catch (e) {
      throw Exception('Failed to get pet by ID: $e');
    }
  }

  @override
  Future<void> adoptPet(String petId) async {
    try {
      final pet = await _remoteDataSource.getPetById(petId);
      if (pet != null) {
        await _localDataSource.adoptPet(pet);
      }
    } catch (e) {
      throw Exception('Failed to adopt pet: $e');
    }
  }

  @override
  Future<List<Pet>> getAdoptedPets() async {
    try {
      return await _localDataSource.getAdoptedPets();
    } catch (e) {
      throw Exception('Failed to get adopted pets: $e');
    }
  }

  @override
  Future<void> addToFavorites(String petId) async {
    try {
      await _localDataSource.addToFavorites(petId);
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  @override
  Future<void> removeFromFavorites(String petId) async {
    try {
      await _localDataSource.removeFromFavorites(petId);
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  @override
  Future<List<String>> getFavoritePetIds() async {
    try {
      return await _localDataSource.getFavoritePetIds();
    } catch (e) {
      throw Exception('Failed to get favorite pet IDs: $e');
    }
  }

  @override
  Future<bool> isFavorite(String petId) async {
    try {
      return await _localDataSource.isFavorite(petId);
    } catch (e) {
      return false;
    }
  }
}
