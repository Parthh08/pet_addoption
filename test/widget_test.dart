// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_addoption/presentation/widgets/pet_card.dart';
import 'package:pet_addoption/domain/entities/pet.dart';

void main() {
  group('PetCard Widget Tests', () {
    testWidgets('should display pet information correctly', (
      WidgetTester tester,
    ) async {
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
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: PetCard(pet: pet))),
      );

      // Assert
      expect(find.text('Buddy'), findsOneWidget);
      expect(find.text('Golden Retriever'), findsOneWidget);
      expect(find.text('\$200'), findsOneWidget);
      expect(find.text('2 years'), findsOneWidget);
      expect(find.text('Male'), findsOneWidget);
      expect(find.text('Large'), findsOneWidget);
    });

    testWidgets('should show adopt button for non-adopted pets', (
      WidgetTester tester,
    ) async {
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
        isAdopted: false,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: PetCard(pet: pet))),
      );

      // Assert
      expect(find.text('Adopt Me'), findsOneWidget);
    });

    testWidgets('should show adopted badge for adopted pets', (
      WidgetTester tester,
    ) async {
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
        isAdopted: true,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: PetCard(pet: pet))),
      );

      // Assert
      expect(find.text('ADOPTED'), findsOneWidget);
      expect(find.text('Adopt Me'), findsNothing);
    });
  });
}
