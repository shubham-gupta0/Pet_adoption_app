import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_adoption_app/data/datasources/favorites_local_datasource.dart';
import 'package:pet_adoption_app/domain/entities/pet.dart';
import 'package:pet_adoption_app/domain/repositories/pet_repository.dart';
import 'package:pet_adoption_app/presentation/favorites/bloc/favorites_bloc.dart';

class MockFavoritesLocalDataSource extends Mock
    implements FavoritesLocalDataSource {}

class MockPetRepository extends Mock implements PetRepository {}

void main() {
  group('FavoritesBloc', () {
    late FavoritesBloc favoritesBloc;
    late MockFavoritesLocalDataSource mockLocalDataSource;
    late MockPetRepository mockRepository;

    setUp(() {
      mockLocalDataSource = MockFavoritesLocalDataSource();
      mockRepository = MockPetRepository();
      favoritesBloc = FavoritesBloc(mockLocalDataSource, mockRepository);
    });

    tearDown(() {
      favoritesBloc.close();
    });

    test('initial state is FavoritesInitial', () {
      expect(favoritesBloc.state, isA<FavoritesInitial>());
    });

    group('LoadFavorites', () {
      final testPets = [
        const Pet(
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
          price: 250.0,
        ),
        const Pet(
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
          price: 200.0,
        ),
      ];

      blocTest<FavoritesBloc, FavoritesState>(
        'emits [FavoritesLoading, FavoritesLoaded] when LoadFavorites is added successfully',
        build: () {
          when(() => mockLocalDataSource.getFavoriteIds())
              .thenAnswer((_) async => ['1', '2']);
          when(() => mockRepository.getPets(limit: 100, page: 1))
              .thenAnswer((_) async => testPets);
          return favoritesBloc;
        },
        act: (bloc) => bloc.add(LoadFavorites()),
        expect: () => [
          isA<FavoritesLoading>(),
          isA<FavoritesLoaded>().having(
            (state) => state.favoriteIds,
            'favoriteIds',
            {'1', '2'},
          ),
        ],
        verify: (_) {
          verify(() => mockLocalDataSource.getFavoriteIds()).called(1);
          verify(() => mockRepository.getPets(limit: 100, page: 1)).called(1);
        },
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'emits [FavoritesLoading, FavoritesLoaded] with empty list when no favorites',
        build: () {
          when(() => mockLocalDataSource.getFavoriteIds())
              .thenAnswer((_) async => []);
          when(() => mockRepository.getPets(limit: 100, page: 1))
              .thenAnswer((_) async => testPets);
          return favoritesBloc;
        },
        act: (bloc) => bloc.add(LoadFavorites()),
        expect: () => [
          isA<FavoritesLoading>(),
          isA<FavoritesLoaded>().having(
            (state) => state.favoritePets.isEmpty,
            'empty favoritePets',
            true,
          ),
        ],
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'emits [FavoritesLoading, FavoritesError] when LoadFavorites fails',
        build: () {
          when(() => mockLocalDataSource.getFavoriteIds())
              .thenThrow(Exception('Database error'));
          return favoritesBloc;
        },
        act: (bloc) => bloc.add(LoadFavorites()),
        expect: () => [
          isA<FavoritesLoading>(),
          isA<FavoritesError>(),
        ],
      );
    });

    group('ToggleFavorite', () {
      blocTest<FavoritesBloc, FavoritesState>(
        'adds pet to favorites when not already favorited',
        build: () {
          when(() => mockLocalDataSource.isFavorite('1'))
              .thenAnswer((_) async => false);
          when(() => mockLocalDataSource.addToFavorites('1'))
              .thenAnswer((_) async {});
          when(() => mockLocalDataSource.getFavoriteIds())
              .thenAnswer((_) async => ['1']);
          when(() => mockRepository.getPets(limit: 100, page: 1))
              .thenAnswer((_) async => []);
          return favoritesBloc;
        },
        act: (bloc) => bloc.add(ToggleFavorite('1')),
        expect: () => [
          isA<FavoritesLoading>(),
          isA<FavoritesLoaded>(),
        ],
        verify: (_) {
          verify(() => mockLocalDataSource.isFavorite('1')).called(1);
          verify(() => mockLocalDataSource.addToFavorites('1')).called(1);
        },
      );
    });

    test('isFavorite returns correct value', () async {
      // Arrange
      when(() => mockLocalDataSource.isFavorite('1'))
          .thenAnswer((_) async => true);

      // Act
      final result = await favoritesBloc.isFavorite('1');

      // Assert
      expect(result, true);
      verify(() => mockLocalDataSource.isFavorite('1')).called(1);
    });
  });
}
