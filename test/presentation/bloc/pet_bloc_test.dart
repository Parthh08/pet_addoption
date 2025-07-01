import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_addoption/domain/entities/pet.dart';
import 'package:pet_addoption/domain/usecases/get_pets_usecase.dart';
import 'package:pet_addoption/domain/usecases/search_pets_usecase.dart';
import 'package:pet_addoption/domain/usecases/adopt_pet_usecase.dart';
import 'package:pet_addoption/domain/usecases/toggle_favorite_usecase.dart';
import 'package:pet_addoption/presentation/bloc/pet_bloc.dart';
import 'package:pet_addoption/presentation/bloc/pet_event.dart';
import 'package:pet_addoption/presentation/bloc/pet_state.dart';

class MockGetPetsUseCase extends Mock implements GetPetsUseCase {}

class MockSearchPetsUseCase extends Mock implements SearchPetsUseCase {}

class MockAdoptPetUseCase extends Mock implements AdoptPetUseCase {}

class MockToggleFavoriteUseCase extends Mock implements ToggleFavoriteUseCase {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const Pet(
        id: 'fallback',
        name: 'Fallback',
        breed: 'Fallback',
        age: 1,
        price: 0.0,
        imageUrl: 'fallback',
        description: 'fallback',
        type: 'fallback',
        gender: 'fallback',
        size: 'fallback',
      ),
    );
  });

  group('PetBloc Tests', () {
    late PetBloc petBloc;
    late MockGetPetsUseCase mockGetPetsUseCase;
    late MockSearchPetsUseCase mockSearchPetsUseCase;
    late MockAdoptPetUseCase mockAdoptPetUseCase;
    late MockToggleFavoriteUseCase mockToggleFavoriteUseCase;

    setUp(() {
      mockGetPetsUseCase = MockGetPetsUseCase();
      mockSearchPetsUseCase = MockSearchPetsUseCase();
      mockAdoptPetUseCase = MockAdoptPetUseCase();
      mockToggleFavoriteUseCase = MockToggleFavoriteUseCase();

      petBloc = PetBloc(
        getPetsUseCase: mockGetPetsUseCase,
        searchPetsUseCase: mockSearchPetsUseCase,
        adoptPetUseCase: mockAdoptPetUseCase,
        toggleFavoriteUseCase: mockToggleFavoriteUseCase,
      );
    });

    tearDown(() {
      petBloc.close();
    });

    test('initial state should be PetInitial', () {
      expect(petBloc.state, PetInitial());
    });

    group('LoadPets', () {
      const tPets = [
        Pet(
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
        ),
      ];

      blocTest<PetBloc, PetState>(
        'should emit [PetLoading, PetLoaded] when LoadPets is successful',
        build: () {
          when(
            () => mockGetPetsUseCase(
              page: any(named: 'page'),
              limit: any(named: 'limit'),
            ),
          ).thenAnswer((_) async => tPets);
          return petBloc;
        },
        act: (bloc) => bloc.add(const LoadPets()),
        expect:
            () => [
              PetLoading(),
              const PetLoaded(pets: tPets, hasReachedMax: true, currentPage: 0),
            ],
        verify: (_) {
          verify(() => mockGetPetsUseCase(page: 0, limit: 10)).called(1);
        },
      );

      blocTest<PetBloc, PetState>(
        'should emit [PetLoading, PetError] when LoadPets fails',
        build: () {
          when(
            () => mockGetPetsUseCase(
              page: any(named: 'page'),
              limit: any(named: 'limit'),
            ),
          ).thenThrow(Exception('Failed to load pets'));
          return petBloc;
        },
        act: (bloc) => bloc.add(const LoadPets()),
        expect:
            () => [
              PetLoading(),
              const PetError('Exception: Failed to load pets'),
            ],
      );
    });

    group('AdoptPet', () {
      const tPet = Pet(
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

      blocTest<PetBloc, PetState>(
        'should emit [PetAdopted] when AdoptPet is successful',
        build: () {
          when(() => mockAdoptPetUseCase(any())).thenAnswer((_) async {});
          return petBloc;
        },
        seed: () => const PetLoaded(pets: [tPet]),
        act: (bloc) => bloc.add(const AdoptPet(tPet)),
        expect:
            () => [
              isA<PetAdopted>(),
              isA<PetLoaded>().having(
                (state) => state.pets.first.isAdopted,
                'first pet is adopted',
                true,
              ),
            ],
        verify: (_) {
          verify(() => mockAdoptPetUseCase(tPet)).called(1);
        },
      );
    });
  });
}
