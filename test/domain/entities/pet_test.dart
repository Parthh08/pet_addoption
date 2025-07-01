import 'package:flutter_test/flutter_test.dart';
import 'package:pet_addoption/domain/entities/pet.dart';

void main() {
  group('Pet Entity Tests', () {
    test('should create a pet instance with required properties', () {
      // Arrange
      const pet = Pet(
        id: '1',
        name: 'Buddy',
        breed: 'Golden Retriever',
        age: 2,
        price: 200.0,
        imageUrl: 'https://example.com/buddy.jpg',
        description: 'A friendly dog',
        type: 'dog',
        gender: 'Male',
        size: 'Large',
      );

      // Assert
      expect(pet.id, '1');
      expect(pet.name, 'Buddy');
      expect(pet.breed, 'Golden Retriever');
      expect(pet.age, 2);
      expect(pet.price, 200.0);
      expect(pet.isAdopted, false);
      expect(pet.isFavorite, false);
    });

    test('should copy pet with updated properties', () {
      // Arrange
      const pet = Pet(
        id: '1',
        name: 'Buddy',
        breed: 'Golden Retriever',
        age: 2,
        price: 200.0,
        imageUrl: 'https://example.com/buddy.jpg',
        description: 'A friendly dog',
        type: 'dog',
        gender: 'Male',
        size: 'Large',
      );

      // Act
      final updatedPet = pet.copyWith(
        isAdopted: true,
        adoptedDate: DateTime(2023, 1, 1),
      );

      // Assert
      expect(updatedPet.id, '1');
      expect(updatedPet.name, 'Buddy');
      expect(updatedPet.isAdopted, true);
      expect(updatedPet.adoptedDate, DateTime(2023, 1, 1));
    });

    test('should support equality comparison', () {
      // Arrange
      const pet1 = Pet(
        id: '1',
        name: 'Buddy',
        breed: 'Golden Retriever',
        age: 2,
        price: 200.0,
        imageUrl: 'https://example.com/buddy.jpg',
        description: 'A friendly dog',
        type: 'dog',
        gender: 'Male',
        size: 'Large',
      );

      const pet2 = Pet(
        id: '1',
        name: 'Buddy',
        breed: 'Golden Retriever',
        age: 2,
        price: 200.0,
        imageUrl: 'https://example.com/buddy.jpg',
        description: 'A friendly dog',
        type: 'dog',
        gender: 'Male',
        size: 'Large',
      );

      // Assert
      expect(pet1, equals(pet2));
    });
  });
}
