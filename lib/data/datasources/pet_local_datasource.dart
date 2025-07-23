import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:pet_adoption_app/domain/entities/pet.dart';

abstract class PetLocalDataSource {
  Future<void> adoptPet(Pet pet);
  Future<List<Pet>> getAdoptedPets();
  Future<void> addToFavorites(String petId);
  Future<void> removeFromFavorites(String petId);
  Future<List<String>> getFavoritePetIds();
  Future<bool> isFavorite(String petId);
}

@Injectable(as: PetLocalDataSource)
class PetLocalDataSourceImpl implements PetLocalDataSource {
  static const String _adoptedPetsBox = 'adopted_pets';
  static const String _favoritePetsBox = 'favorite_pets';

  @override
  Future<void> adoptPet(Pet pet) async {
    final box = Hive.box<Pet>(_adoptedPetsBox);
    await box.put(
        pet.id,
        pet.copyWith(
          isAdopted: true,
          createdAt: DateTime.now(), // Set adoption timestamp
        ));
  }

  @override
  Future<List<Pet>> getAdoptedPets() async {
    final box = Hive.box<Pet>(_adoptedPetsBox);
    final adoptedPets = box.values.toList();

    // Sort by adoption time (createdAt) in reverse chronological order (newest first)
    adoptedPets.sort((a, b) {
      final aTime = a.createdAt ?? DateTime(2020); // Fallback for null
      final bTime = b.createdAt ?? DateTime(2020);
      return bTime.compareTo(aTime); // Newest first
    });

    return adoptedPets;
  }

  @override
  Future<void> addToFavorites(String petId) async {
    final box = Hive.box<String>(_favoritePetsBox);
    await box.put(petId, petId);
  }

  @override
  Future<void> removeFromFavorites(String petId) async {
    final box = Hive.box<String>(_favoritePetsBox);
    await box.delete(petId);
  }

  @override
  Future<List<String>> getFavoritePetIds() async {
    final box = Hive.box<String>(_favoritePetsBox);
    return box.values.toList();
  }

  @override
  Future<bool> isFavorite(String petId) async {
    final box = Hive.box<String>(_favoritePetsBox);
    return box.containsKey(petId);
  }
}
