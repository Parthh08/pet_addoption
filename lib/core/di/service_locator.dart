import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

// Data Sources
import '../../data/datasources/pet_remote_data_source.dart';
import '../../data/datasources/pet_remote_data_source_impl.dart';
import '../../data/datasources/pet_local_data_source.dart';
import '../../data/datasources/pet_local_data_source_impl.dart';

// Repositories
import '../../domain/repositories/pet_repository.dart';
import '../../domain/repositories/adoption_history_repository.dart';
import '../../data/repositories/pet_repository_impl.dart';
import '../../data/repositories/adoption_history_repository_impl.dart';

// Use Cases
import '../../domain/usecases/get_pets_usecase.dart';
import '../../domain/usecases/search_pets_usecase.dart';
import '../../domain/usecases/adopt_pet_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import '../../domain/usecases/get_favorite_pets_usecase.dart';
import '../../domain/usecases/get_adoption_history_usecase.dart';

// BLoCs
import '../../presentation/bloc/pet_bloc.dart';
import '../../presentation/bloc/favorites_bloc.dart';
import '../../presentation/bloc/history_bloc.dart';
import '../../presentation/bloc/theme_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  final dio = Dio();
  dio.options.connectTimeout = const Duration(seconds: 10);
  dio.options.receiveTimeout = const Duration(seconds: 10);
  sl.registerLazySingleton(() => dio);

  sl.registerLazySingleton<PetRemoteDataSource>(
    () => PetRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<PetLocalDataSource>(
    () => PetLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<PetRepository>(
    () => PetRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<AdoptionHistoryRepository>(
    () => AdoptionHistoryRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetPetsUseCase(sl()));
  sl.registerLazySingleton(() => SearchPetsUseCase(sl()));
  sl.registerLazySingleton(() => AdoptPetUseCase(sl(), sl()));
  sl.registerLazySingleton(() => ToggleFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => GetFavoritePetsUseCase(sl()));
  sl.registerLazySingleton(() => GetAdoptionHistoryUseCase(sl()));

  sl.registerFactory(
    () => PetBloc(
      getPetsUseCase: sl(),
      searchPetsUseCase: sl(),
      adoptPetUseCase: sl(),
      toggleFavoriteUseCase: sl(),
    ),
  );

  sl.registerFactory(() => FavoritesBloc(getFavoritePetsUseCase: sl()));

  sl.registerFactory(() => HistoryBloc(getAdoptionHistoryUseCase: sl()));

  sl.registerFactory(() => ThemeBloc(sharedPreferences: sl()));
}
