import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:pet_adoption_app/domain/entities/pet.dart';

abstract class PetCacheDataSource {
  Future<void> cachePets(List<Pet> pets);
  Future<List<Pet>> getCachedPets();
  Future<void> cachePet(Pet pet);
  Future<Pet?> getCachedPet(String id);
  Future<void> clearCache();
  Future<bool> hasCachedData();
  Future<DateTime?> getLastCacheTime();
}

@Injectable(as: PetCacheDataSource)
class PetCacheDataSourceImpl implements PetCacheDataSource {
  static const String _petsBoxName = 'cached_pets';
  static const String _metadataBoxName = 'cache_metadata';
  static const String _lastCacheTimeKey = 'last_cache_time';

  Box<Pet> get _petsBox => Hive.box<Pet>(_petsBoxName);
  Box get _metadataBox => Hive.box(_metadataBoxName);

  @override
  Future<void> cachePets(List<Pet> pets) async {
    await _petsBox.clear();

    for (final pet in pets) {
      await _petsBox.put(pet.id, pet);
    }

    await _metadataBox.put(_lastCacheTimeKey, DateTime.now().toIso8601String());
  }

  @override
  Future<List<Pet>> getCachedPets() async {
    return _petsBox.values.toList();
  }

  @override
  Future<void> cachePet(Pet pet) async {
    await _petsBox.put(pet.id, pet);
  }

  @override
  Future<Pet?> getCachedPet(String id) async {
    return _petsBox.get(id);
  }

  @override
  Future<void> clearCache() async {
    await _petsBox.clear();
    await _metadataBox.delete(_lastCacheTimeKey);
  }

  @override
  Future<bool> hasCachedData() async {
    return _petsBox.isNotEmpty;
  }

  @override
  Future<DateTime?> getLastCacheTime() async {
    final timeString = _metadataBox.get(_lastCacheTimeKey) as String?;
    if (timeString != null) {
      return DateTime.parse(timeString);
    }
    return null;
  }
}
