import 'package:pet_adoption_app/domain/entities/pet.dart';

abstract class PetRepository {
  Future<List<Pet>> getPets({int page = 0, int limit = 20});
  Future<Pet?> getPetById(String id);
  Future<void> adoptPet(String petId);
  Future<List<Pet>> getAdoptedPets();
  Future<void> addToFavorites(String petId);
  Future<void> removeFromFavorites(String petId);
  Future<List<String>> getFavoritePetIds();
  Future<bool> isFavorite(String petId);
}
