import 'dart:math';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pet_adoption_app/core/api/api_keys.dart';
import 'package:pet_adoption_app/domain/entities/pet.dart';

abstract class PetRemoteDataSource {
  Future<List<Pet>> getPets({int page = 0, int limit = 20});
  Future<Pet?> getPetById(String id);
}

@Injectable(as: PetRemoteDataSource)
class PetRemoteDataSourceImpl implements PetRemoteDataSource {
  final Dio _dio;

  PetRemoteDataSourceImpl(this._dio);

  @override
  Future<List<Pet>> getPets({int page = 0, int limit = 20}) async {
    try {
      await Future.delayed(
          const Duration(milliseconds: 500)); // Simulate network delay

      final mockPets = await _generateMockPets(page, limit);
      return mockPets;
    } catch (e) {
      throw Exception('Failed to fetch pets: $e');
    }
  }

  @override
  Future<Pet?> getPetById(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      return await _generateSpecificPet(id);
    } catch (e) {
      throw Exception('Failed to fetch pet: $e');
    }
  }

  Future<List<Pet>> _generateMockPets(int page, int limit) async {
    final petFutures = <Future<Pet>>[];

    for (int i = 0; i < limit; i++) {
      final index = (page * limit) + i;
      petFutures.add(_createMockPet(index));
    }

    return await Future.wait(petFutures);
  }

  Future<Pet> _generateSpecificPet(String id) async {
    return await _createMockPet(int.parse(id));
  }

  List<String> _getPlaceholderImages(int count) {
    return List.generate(
        count,
        (i) =>
            'https://picsum.photos/400/300?random=${DateTime.now().millisecondsSinceEpoch + i}');
  }

  Future<Map<String, dynamic>> _fetchRandomBreed({required bool isDog}) async {
    final domain = isDog ? 'thedogapi' : 'thecatapi';
    final apiKey = isDog ? theDogApiKey : theCatApiKey;
    final url = 'https://api.$domain.com/v1/breeds';

    try {
      final response = await _dio.get(
        url,
        options: Options(headers: {'x-api-key': apiKey}),
      );

      if (response.statusCode == 200 && response.data is List) {
        final breeds = response.data as List;
        if (breeds.isNotEmpty) {
          final random = Random();
          final randomBreed = breeds[random.nextInt(breeds.length)];
          return {
            'id': randomBreed['id'],
            'name': randomBreed['name'],
            'temperament': randomBreed['temperament'],
          };
        }
      }
    } catch (e) {
      // If API fails, return fallback breed data
    }

    // Fallback breed data
    final fallbackDogBreeds = [
      {
        'id': 1,
        'name': 'Golden Retriever',
        'temperament': 'Friendly, Intelligent, Devoted'
      },
      {
        'id': 2,
        'name': 'Labrador',
        'temperament': 'Outgoing, Active, Friendly'
      },
      {
        'id': 3,
        'name': 'German Shepherd',
        'temperament': 'Confident, Courageous, Smart'
      },
    ];
    final fallbackCatBreeds = [
      {
        'id': 1,
        'name': 'Maine Coon',
        'temperament': 'Gentle, Friendly, Intelligent'
      },
      {
        'id': 2,
        'name': 'Siamese',
        'temperament': 'Active, Affectionate, Intelligent'
      },
      {'id': 3, 'name': 'Persian', 'temperament': 'Quiet, Sweet, Gentle'},
    ];

    final fallbacks = isDog ? fallbackDogBreeds : fallbackCatBreeds;
    final random = Random();
    return fallbacks[random.nextInt(fallbacks.length)];
  }

  Future<List<String>> _fetchPetImages(
      {required bool isDog, dynamic breedId, int count = 3}) async {
    final domain = isDog ? 'thedogapi' : 'thecatapi';
    final apiKey = isDog ? theDogApiKey : theCatApiKey;

    // Try to get breed-specific images first
    String url = 'https://api.$domain.com/v1/images/search?limit=$count';
    if (breedId != null) {
      url += '&breed_id=$breedId';
    }

    try {
      final response = await _dio.get(
        url,
        options: Options(headers: {'x-api-key': apiKey}),
      );

      if (response.statusCode == 200 && response.data is List) {
        final imageUrls = (response.data as List)
            .map<String>((item) => item['url'] as String)
            .toList();
        if (imageUrls.isNotEmpty) {
          return imageUrls;
        }
      }
    } catch (e) {
      // If breed-specific search fails, try general search
    }

    // Fallback to general search without breed filter
    try {
      final fallbackUrl =
          'https://api.$domain.com/v1/images/search?limit=$count';
      final response = await _dio.get(
        fallbackUrl,
        options: Options(headers: {'x-api-key': apiKey}),
      );

      if (response.statusCode == 200 && response.data is List) {
        final imageUrls = (response.data as List)
            .map<String>((item) => item['url'] as String)
            .toList();
        return imageUrls.isNotEmpty ? imageUrls : _getPlaceholderImages(count);
      }
    } catch (e) {
      // If API fails completely, return placeholder images
    }
    return _getPlaceholderImages(count);
  }

  Future<Pet> _createMockPet(int index) async {
    final names = [
      'Max',
      'Luna',
      'Charlie',
      'Bella',
      'Rocky',
      'Lucy',
      'Cooper',
      'Daisy',
      'Milo',
      'Molly',
      'Oliver',
      'Sadie',
      'Leo',
      'Zoe',
      'Simba',
      'Cleo',
      'Buddy',
      'Ruby',
      'Tucker',
      'Penny',
      'Bear',
      'Rosie',
      'Duke',
      'Lily'
    ];

    final colors = [
      'Golden',
      'Black',
      'Brown',
      'White',
      'Gray',
      'Cream',
      'Chocolate',
      'Red',
      'Blue',
      'Silver',
      'Tabby',
      'Tortoiseshell',
      'Brindle',
      'Tricolor'
    ];
    final sizes = ['Small', 'Medium', 'Large'];
    final genders = ['Male', 'Female'];
    final locations = [
      'New York, NY',
      'Los Angeles, CA',
      'Chicago, IL',
      'Houston, TX',
      'Phoenix, AZ',
      'Philadelphia, PA',
      'San Antonio, TX',
      'San Diego, CA',
      'Dallas, TX',
      'San Jose, CA'
    ];

    // Determine if this should be a dog or cat (70% dogs, 30% cats for variety)
    final random = Random(index * 42);
    final isDog = random.nextDouble() < 0.7;

    // Fetch real breed data and images
    final breedData = await _fetchRandomBreed(isDog: isDog);
    final images =
        await _fetchPetImages(isDog: isDog, breedId: breedData['id']);

    final nameIndex = random.nextInt(names.length);
    final colorIndex = random.nextInt(colors.length);
    final sizeIndex = random.nextInt(sizes.length);
    final genderIndex = random.nextInt(genders.length);
    final locationIndex = random.nextInt(locations.length);
    final age = random.nextInt(12) + 1;

    // Create description using real breed temperament if available
    final temperament = breedData['temperament'] ?? 'Friendly, Loving';
    final breedName =
        breedData['name'] ?? (isDog ? 'Mixed Breed Dog' : 'Mixed Breed Cat');

    return Pet(
      id: index.toString(),
      name: names[nameIndex],
      breed: breedName,
      age: age,
      gender: genders[genderIndex],
      size: sizes[sizeIndex],
      color: colors[colorIndex],
      description:
          'Meet ${names[nameIndex]}, a wonderful ${age}-year-old $breedName looking for a loving home. ${names[nameIndex]} is ${genders[genderIndex].toLowerCase()} and has a ${colors[colorIndex].toLowerCase()} coat. Known for being $temperament, this ${sizes[sizeIndex].toLowerCase()}-sized companion would make a perfect addition to your family!',
      images: images,
      location: locations[locationIndex],
      isAdopted: false,
      contactEmail: 'adopt@shelter.com',
      contactPhone: '+1-555-${(1000 + index).toString().substring(1)}',
      createdAt: DateTime.now().subtract(Duration(days: (index + 1) * 2)),
    );
  }
}
