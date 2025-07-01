import '../models/pet_model.dart';
import '../models/adoption_history_model.dart';

abstract class PetLocalDataSource {
  Future<List<PetModel>> getFavoritePets();
  Future<List<PetModel>> getAdoptedPets();
  Future<void> saveFavoritePet(PetModel pet);
  Future<void> removeFavoritePet(String petId);
  Future<void> saveAdoptedPet(PetModel pet);
  Future<List<AdoptionHistoryModel>> getAdoptionHistory();
  Future<void> saveAdoptionHistory(AdoptionHistoryModel history);
  Future<void> clearAllData();
}
