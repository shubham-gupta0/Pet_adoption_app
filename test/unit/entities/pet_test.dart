import 'package:flutter_test/flutter_test.dart';
import 'package:pet_adoption_app/domain/entities/pet.dart';

void main() {
  group('Pet Entity Tests', () {
    test('should create Pet instance with all properties', () {
      // Arrange
      const pet = Pet(
        id: '1',
        name: 'Buddy',
        breed: 'Golden Retriever',
        age: 3,
        gender: 'Male',
        size: 'Large',
        color: 'Golden',
        description: 'A friendly and energetic dog',
        images: ['https://example.com/buddy.jpg'],
        location: 'New York',
        price: 250.0,
        isAdopted: false,
      );

      // Act & Assert
      expect(pet.id, '1');
      expect(pet.name, 'Buddy');
      expect(pet.breed, 'Golden Retriever');
      expect(pet.age, 3);
      expect(pet.gender, 'Male');
      expect(pet.size, 'Large');
      expect(pet.color, 'Golden');
      expect(pet.description, 'A friendly and energetic dog');
      expect(pet.images, ['https://example.com/buddy.jpg']);
      expect(pet.location, 'New York');
      expect(pet.price, 250.0);
      expect(pet.isAdopted, false);
    });

    test('should correctly serialize to JSON', () {
      // Arrange
      const pet = Pet(
        id: '1',
        name: 'Buddy',
        breed: 'Golden Retriever',
        age: 3,
        gender: 'Male',
        size: 'Large',
        color: 'Golden',
        description: 'A friendly and energetic dog',
        images: ['https://example.com/buddy.jpg'],
        location: 'New York',
        price: 250.0,
        isAdopted: false,
      );

      // Act
      final json = pet.toJson();

      // Assert
      expect(json['id'], '1');
      expect(json['name'], 'Buddy');
      expect(json['breed'], 'Golden Retriever');
      expect(json['age'], 3);
      expect(json['gender'], 'Male');
      expect(json['size'], 'Large');
      expect(json['color'], 'Golden');
      expect(json['description'], 'A friendly and energetic dog');
      expect(json['images'], ['https://example.com/buddy.jpg']);
      expect(json['location'], 'New York');
      expect(json['price'], 250.0);
      expect(json['isAdopted'], false);
    });

    test('should correctly deserialize from JSON', () {
      // Arrange
      final json = {
        'id': '1',
        'name': 'Buddy',
        'breed': 'Golden Retriever',
        'age': 3,
        'gender': 'Male',
        'size': 'Large',
        'color': 'Golden',
        'description': 'A friendly and energetic dog',
        'images': ['https://example.com/buddy.jpg'],
        'location': 'New York',
        'price': 250.0,
        'isAdopted': false,
      };

      // Act
      final pet = Pet.fromJson(json);

      // Assert
      expect(pet.id, '1');
      expect(pet.name, 'Buddy');
      expect(pet.breed, 'Golden Retriever');
      expect(pet.age, 3);
      expect(pet.gender, 'Male');
      expect(pet.size, 'Large');
      expect(pet.color, 'Golden');
      expect(pet.description, 'A friendly and energetic dog');
      expect(pet.images, ['https://example.com/buddy.jpg']);
      expect(pet.location, 'New York');
      expect(pet.price, 250.0);
      expect(pet.isAdopted, false);
    });

    test('should support copying with modifications', () {
      // Arrange
      const originalPet = Pet(
        id: '1',
        name: 'Buddy',
        breed: 'Golden Retriever',
        age: 3,
        gender: 'Male',
        size: 'Large',
        color: 'Golden',
        description: 'A friendly and energetic dog',
        images: ['https://example.com/buddy.jpg'],
        location: 'New York',
        price: 250.0,
        isAdopted: false,
      );

      // Act
      final adoptedPet = originalPet.copyWith(
        isAdopted: true,
        price: 0.0,
      );

      // Assert
      expect(adoptedPet.id, originalPet.id);
      expect(adoptedPet.name, originalPet.name);
      expect(adoptedPet.isAdopted, true);
      expect(adoptedPet.price, 0.0);
    });

    test('should maintain equality based on properties', () {
      // Arrange
      const pet1 = Pet(
        id: '1',
        name: 'Buddy',
        breed: 'Golden Retriever',
        age: 3,
        gender: 'Male',
        size: 'Large',
        color: 'Golden',
        description: 'A friendly and energetic dog',
        images: ['https://example.com/buddy.jpg'],
        location: 'New York',
        price: 250.0,
        isAdopted: false,
      );

      const pet2 = Pet(
        id: '1',
        name: 'Buddy',
        breed: 'Golden Retriever',
        age: 3,
        gender: 'Male',
        size: 'Large',
        color: 'Golden',
        description: 'A friendly and energetic dog',
        images: ['https://example.com/buddy.jpg'],
        location: 'New York',
        price: 250.0,
        isAdopted: false,
      );

      // Act & Assert
      expect(pet1, equals(pet2));
      expect(pet1.hashCode, equals(pet2.hashCode));
    });
  });
}
