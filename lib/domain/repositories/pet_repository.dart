import '../entities/pet.dart';

abstract class PetRepository {
  Future<List<Pet>> getPets({int page = 0, int limit = 20});
  Future<List<Pet>> searchPets(String query, {int page = 0, int limit = 20});
  Future<Pet> getPetById(String id);
  Future<List<Pet>> getFavoritePets();
  Future<List<Pet>> getAdoptedPets();
  Future<void> adoptPet(Pet pet);
  Future<void> toggleFavorite(Pet pet);
  Future<void> clearCache();
}
