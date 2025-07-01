import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_favorite_pets_usecase.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavoritePetsUseCase getFavoritePetsUseCase;

  FavoritesBloc({required this.getFavoritePetsUseCase})
    : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<RefreshFavorites>(_onRefreshFavorites);
  }

  void _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      if (state is FavoritesInitial) {
        emit(FavoritesLoading());
      }

      final favorites = await getFavoritePetsUseCase();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  void _onRefreshFavorites(
    RefreshFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      emit(FavoritesLoading());
      final favorites = await getFavoritePetsUseCase();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}
