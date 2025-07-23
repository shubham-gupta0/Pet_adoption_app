import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:pet_adoption_app/domain/entities/pet.dart';

abstract class FavoritesLocalDataSource {
  Future<void> addToFavorites(String petId, {Pet? petData});
  Future<void> removeFromFavorites(String petId);
  Future<List<String>> getFavoriteIds();
  Future<List<Pet>> getFavoritePets();
  Future<bool> isFavorite(String petId);
  Future<void> cacheFavoritePet(Pet pet);
}

@Injectable(as: FavoritesLocalDataSource)
class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  static const String _favoritesBoxName = 'favorite_pets';
  static const String _favoritePetsDataBoxName = 'favorite_pets_data';

  Box<String> get _favoritesBox => Hive.box<String>(_favoritesBoxName);
  Box<Pet> get _favoritePetsDataBox => Hive.box<Pet>(_favoritePetsDataBoxName);

  @override
  Future<void> addToFavorites(String petId, {Pet? petData}) async {
    await _favoritesBox.put(petId, petId);
    if (petData != null) {
      await _favoritePetsDataBox.put(petId, petData);
    }
  }

  @override
  Future<void> removeFromFavorites(String petId) async {
    await _favoritesBox.delete(petId);
    await _favoritePetsDataBox.delete(petId);
  }

  @override
  Future<List<String>> getFavoriteIds() async {
    return _favoritesBox.values.toList();
  }

  @override
  Future<List<Pet>> getFavoritePets() async {
    return _favoritePetsDataBox.values.toList();
  }

  @override
  Future<bool> isFavorite(String petId) async {
    return _favoritesBox.containsKey(petId);
  }

  @override
  Future<void> cacheFavoritePet(Pet pet) async {
    await _favoritePetsDataBox.put(pet.id, pet);
  }
}
