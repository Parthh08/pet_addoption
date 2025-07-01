import '../../domain/entities/pet.dart';
import '../../domain/repositories/pet_repository.dart';
import '../datasources/pet_remote_data_source.dart';
import '../datasources/pet_local_data_source.dart';
import '../models/pet_model.dart';

class PetRepositoryImpl implements PetRepository {
  final PetRemoteDataSource remoteDataSource;
  final PetLocalDataSource localDataSource;

  List<PetModel> _cachedPets = [];
  bool _hasInitialLoad = false;

  PetRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Pet>> getPets({int page = 0, int limit = 20}) async {
    try {
      List<PetModel> remotePets;

      if ((!_hasInitialLoad && page == 0) || (page > 0 && _hasInitialLoad)) {
        final newPets = await remoteDataSource.getPets(
          page: page,
          limit: limit,
        );

        if (page == 0) {
          _cachedPets = newPets;
          _hasInitialLoad = true;
        } else {
          _cachedPets.addAll(newPets);
        }
      }

      remotePets = _cachedPets;

      final adoptedPets = await localDataSource.getAdoptedPets();
      final favoritePets = await localDataSource.getFavoritePets();

      return remotePets.map((pet) {
        final isAdopted = adoptedPets.any((adopted) => adopted.id == pet.id);
        final isFavorite = favoritePets.any(
          (favorite) => favorite.id == pet.id,
        );
        final adoptedPet = adoptedPets.firstWhere(
          (adopted) => adopted.id == pet.id,
          orElse: () => pet,
        );

        return pet.copyWith(
          isAdopted: isAdopted,
          isFavorite: isFavorite,
          adoptedDate: isAdopted ? adoptedPet.adoptedDate : null,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get pets: $e');
    }
  }

  @override
  Future<List<Pet>> searchPets(
    String query, {
    int page = 0,
    int limit = 20,
  }) async {
    try {
      final remotePets = await remoteDataSource.searchPets(
        query,
        page: page,
        limit: limit,
      );
      final adoptedPets = await localDataSource.getAdoptedPets();
      final favoritePets = await localDataSource.getFavoritePets();

      return remotePets.map((pet) {
        final isAdopted = adoptedPets.any((adopted) => adopted.id == pet.id);
        final isFavorite = favoritePets.any(
          (favorite) => favorite.id == pet.id,
        );
        final adoptedPet = adoptedPets.firstWhere(
          (adopted) => adopted.id == pet.id,
          orElse: () => pet,
        );

        return pet.copyWith(
          isAdopted: isAdopted,
          isFavorite: isFavorite,
          adoptedDate: isAdopted ? adoptedPet.adoptedDate : null,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to search pets: $e');
    }
  }

  @override
  Future<Pet> getPetById(String id) async {
    try {
      final pets = await getPets(limit: 100);
      return pets.firstWhere((pet) => pet.id == id);
    } catch (e) {
      throw Exception('Pet not found');
    }
  }

  @override
  Future<List<Pet>> getFavoritePets() async {
    final favoritePets = await localDataSource.getFavoritePets();
    final adoptedPets = await localDataSource.getAdoptedPets();

    return favoritePets.map((pet) {
      final isAdopted = adoptedPets.any((adopted) => adopted.id == pet.id);
      final adoptedPet = adoptedPets.firstWhere(
        (adopted) => adopted.id == pet.id,
        orElse: () => pet,
      );

      return pet.copyWith(
        isAdopted: isAdopted,
        adoptedDate: isAdopted ? adoptedPet.adoptedDate : null,
      );
    }).toList();
  }

  @override
  Future<List<Pet>> getAdoptedPets() async {
    return await localDataSource.getAdoptedPets();
  }

  @override
  Future<void> adoptPet(Pet pet) async {
    final petModel = PetModel(
      id: pet.id,
      name: pet.name,
      breed: pet.breed,
      age: pet.age,
      price: pet.price,
      imageUrl: pet.imageUrl,
      description: pet.description,
      type: pet.type,
      gender: pet.gender,
      size: pet.size,
      isAdopted: true,
      isFavorite: pet.isFavorite,
      adoptedDate: DateTime.now(),
    );

    await localDataSource.saveAdoptedPet(petModel);
  }

  @override
  Future<void> toggleFavorite(Pet pet) async {
    final favoritePets = await localDataSource.getFavoritePets();
    final isFavorite = favoritePets.any((favorite) => favorite.id == pet.id);

    if (isFavorite) {
      await localDataSource.removeFavoritePet(pet.id);
    } else {
      final petModel = PetModel(
        id: pet.id,
        name: pet.name,
        breed: pet.breed,
        age: pet.age,
        price: pet.price,
        imageUrl: pet.imageUrl,
        description: pet.description,
        type: pet.type,
        gender: pet.gender,
        size: pet.size,
        isAdopted: pet.isAdopted,
        isFavorite: true,
        adoptedDate: pet.adoptedDate,
      );
      await localDataSource.saveFavoritePet(petModel);
    }
  }

  @override
  Future<void> clearCache() async {
    await localDataSource.clearAllData();
    _cachedPets.clear();
    _hasInitialLoad = false;
  }
}
