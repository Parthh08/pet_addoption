import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_addoption/domain/entities/pet.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/usecases/get_pets_usecase.dart';
import '../../domain/usecases/search_pets_usecase.dart';
import '../../domain/usecases/adopt_pet_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import 'pet_event.dart';
import 'pet_state.dart';

class PetBloc extends Bloc<PetEvent, PetState> {
  final GetPetsUseCase getPetsUseCase;
  final SearchPetsUseCase searchPetsUseCase;
  final AdoptPetUseCase adoptPetUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  PetBloc({
    required this.getPetsUseCase,
    required this.searchPetsUseCase,
    required this.adoptPetUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(PetInitial()) {
    on<LoadPets>(_onLoadPets);
    on<SearchPets>(_onSearchPets);
    on<LoadMorePets>(_onLoadMorePets);
    on<AdoptPet>(_onAdoptPet);
    on<ToggleFavoritePet>(_onToggleFavoritePet);
    on<ClearSearch>(_onClearSearch);
  }

  void _onLoadPets(LoadPets event, Emitter<PetState> emit) async {
    try {
      final isInitialLoad = event.isRefresh || state is PetInitial;

      if (isInitialLoad) {
        emit(PetLoading());
      }

      final limit =
          isInitialLoad ? AppConstants.initialPageSize : AppConstants.pageSize;

      final pets = await getPetsUseCase(page: event.page, limit: limit);

      if (pets.isEmpty) {
        emit(const PetLoaded(hasReachedMax: true));
      } else {
        emit(
          PetLoaded(
            pets: pets,
            hasReachedMax: pets.length < limit,
            currentPage: event.page,
          ),
        );
      }
    } catch (e) {
      emit(PetError(e.toString()));
    }
  }

  void _onSearchPets(SearchPets event, Emitter<PetState> emit) async {
    try {
      emit(PetLoading());

      final pets = await searchPetsUseCase(
        event.query,
        page: event.page,
        limit: AppConstants.pageSize,
      );

      emit(
        PetLoaded(
          pets: pets,
          hasReachedMax: pets.length < AppConstants.pageSize,
          currentPage: event.page,
          searchQuery: event.query,
        ),
      );
    } catch (e) {
      emit(PetError(e.toString()));
    }
  }

  void _onLoadMorePets(LoadMorePets event, Emitter<PetState> emit) async {
    if (state is PetLoaded) {
      final currentState = state as PetLoaded;

      if (currentState.hasReachedMax) return;

      try {
        final nextPage = currentState.currentPage + 1;
        List<dynamic> newPets;

        if (currentState.searchQuery != null &&
            currentState.searchQuery!.isNotEmpty) {
          newPets = await searchPetsUseCase(
            currentState.searchQuery!,
            page: nextPage,
            limit: AppConstants.pageSize,
          );
        } else {
          newPets = await getPetsUseCase(
            page: nextPage,
            limit: AppConstants.pageSize,
          );
        }

        emit(
          currentState.copyWith(
            pets: List.from(currentState.pets)
              ..addAll(newPets as Iterable<Pet>),
            hasReachedMax: newPets.length < AppConstants.pageSize,
            currentPage: nextPage,
          ),
        );
      } catch (e) {
        emit(PetError(e.toString()));
      }
    }
  }

  void _onAdoptPet(AdoptPet event, Emitter<PetState> emit) async {
    try {
      final currentState = state;

      await adoptPetUseCase(event.pet);
      emit(PetAdopted(event.pet));

      if (currentState is PetLoaded) {
        final updatedPets =
            currentState.pets.map((pet) {
              if (pet.id == event.pet.id) {
                return pet.copyWith(
                  isAdopted: true,
                  adoptedDate: DateTime.now(),
                );
              }
              return pet;
            }).toList();

        emit(currentState.copyWith(pets: updatedPets));
      }
    } catch (e) {
      emit(PetError(e.toString()));
    }
  }

  void _onToggleFavoritePet(
    ToggleFavoritePet event,
    Emitter<PetState> emit,
  ) async {
    try {
      await toggleFavoriteUseCase(event.pet);
      if (state is PetLoaded) {
        final currentState = state as PetLoaded;
        final updatedPets =
            currentState.pets.map((pet) {
              if (pet.id == event.pet.id) {
                return pet.copyWith(isFavorite: !pet.isFavorite);
              }
              return pet;
            }).toList();
        emit(FavoriteToggled(event.pet));

        emit(currentState.copyWith(pets: updatedPets));
      }
    } catch (e) {
      emit(PetError(e.toString()));
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<PetState> emit) async {
    try {
      final pets = await getPetsUseCase(
        page: 0,
        limit: AppConstants.initialPageSize,
      );

      emit(
        PetLoaded(
          pets: pets,
          hasReachedMax: pets.length < AppConstants.initialPageSize,
          currentPage: 0,
          searchQuery: null,
        ),
      );
    } catch (e) {
      emit(PetError(e.toString()));
    }
  }
}
