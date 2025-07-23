import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_adoption_app/domain/entities/pet.dart';
import 'package:pet_adoption_app/presentation/favorites/bloc/favorites_bloc.dart';
import 'package:pet_adoption_app/presentation/home/view/widgets/pet_card.dart';

class MockFavoritesBloc extends Mock implements FavoritesBloc {}

void main() {
  group('PetCard Widget Tests', () {
    late MockFavoritesBloc mockFavoritesBloc;

    setUp(() {
      mockFavoritesBloc = MockFavoritesBloc();

      // Set up GetIt for testing
      final getIt = GetIt.instance;
      if (getIt.isRegistered<FavoritesBloc>()) {
        getIt.unregister<FavoritesBloc>();
      }
      getIt.registerSingleton<FavoritesBloc>(mockFavoritesBloc);

      // Mock the isFavorite method to return false by default
      when(() => mockFavoritesBloc.isFavorite(any()))
          .thenAnswer((_) async => false);
    });

    tearDown(() {
      final getIt = GetIt.instance;
      if (getIt.isRegistered<FavoritesBloc>()) {
        getIt.unregister<FavoritesBloc>();
      }
    });
    const testPet = Pet(
      id: '1',
      name: 'Buddy',
      breed: 'Golden Retriever',
      age: 3,
      gender: 'Male',
      size: 'Large',
      color: 'Golden',
      description: 'A friendly dog',
      images: ['https://example.com/buddy.jpg'],
      location: 'New York',
      cost: 250.0,
      isAdopted: false,
    );

    const adoptedPet = Pet(
      id: '2',
      name: 'Lucy',
      breed: 'Labrador',
      age: 2,
      gender: 'Female',
      size: 'Medium',
      color: 'Black',
      description: 'A playful dog',
      images: ['https://example.com/lucy.jpg'],
      location: 'California',
      cost: 200.0,
      isAdopted: true,
    );

    testWidgets('should display pet information correctly', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PetCard(pet: testPet),
          ),
        ),
      );

      // Wait for animations to start and complete
      await tester.pump(const Duration(milliseconds: 100)); // Initial delay
      await tester.pump(
          const Duration(milliseconds: 400)); // Animation duration + buffer

      // Assert
      expect(find.text('Buddy'), findsOneWidget);
      expect(find.text('Golden Retriever'), findsOneWidget);
      expect(find.text('3yr'), findsOneWidget);
      expect(find.text('L'), findsOneWidget); // Size first letter
    });

    testWidgets('should show adopted badge for adopted pets', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PetCard(pet: adoptedPet),
          ),
        ),
      );

      // Wait for animations to start and complete
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 400));

      // Assert
      expect(find.text('Adopted'), findsOneWidget);
    });

    testWidgets('should not show adopted badge for non-adopted pets',
        (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PetCard(pet: testPet),
          ),
        ),
      );

      // Wait for animations to start and complete
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 400));

      // Assert
      expect(find.text('Adopted'), findsNothing);
    });

    testWidgets('should have favorite button', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PetCard(pet: testPet),
          ),
        ),
      );

      // Wait for animations to start and complete
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 400));

      // Assert
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('should apply opacity to adopted pets', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PetCard(pet: adoptedPet),
          ),
        ),
      );

      // Wait for animations to start and complete
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 400));

      // Assert
      final opacityWidget = tester.widget<Opacity>(
        find
            .descendant(
              of: find.byType(PetCard),
              matching: find.byType(Opacity),
            )
            .first,
      );
      expect(opacityWidget.opacity, 0.6);
    });

    testWidgets('should not apply opacity to non-adopted pets', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PetCard(pet: testPet),
          ),
        ),
      );

      // Wait for animations to start and complete
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 400));

      // Assert
      final opacityWidget = tester.widget<Opacity>(
        find
            .descendant(
              of: find.byType(PetCard),
              matching: find.byType(Opacity),
            )
            .first,
      );
      expect(opacityWidget.opacity, 1.0);
    });

    testWidgets('should have hero animation tag', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PetCard(pet: testPet),
          ),
        ),
      );

      // Wait for animations to start and complete
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 400));

      // Assert
      final heroWidget = tester.widget<Hero>(
        find.descendant(
          of: find.byType(PetCard),
          matching: find.byType(Hero),
        ),
      );
      expect(heroWidget.tag, 'pet_image_1');
    });

    testWidgets('should truncate long pet names', (tester) async {
      // Arrange
      const longNamePet = Pet(
        id: '3',
        name: 'This is a very long pet name that should be truncated',
        breed: 'Golden Retriever',
        age: 3,
        gender: 'Male',
        size: 'Large',
        color: 'Golden',
        description: 'A friendly dog',
        images: ['https://example.com/buddy.jpg'],
        location: 'New York',
        cost: 250.0,
        isAdopted: false,
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PetCard(pet: longNamePet),
          ),
        ),
      );

      // Wait for animations to start and complete
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 400));

      // Assert
      final textWidget = tester.widget<Text>(
        find.text('This is a very long pet name that should be truncated'),
      );
      expect(textWidget.maxLines, 1);
      expect(textWidget.overflow, TextOverflow.ellipsis);
    });
  });
}
