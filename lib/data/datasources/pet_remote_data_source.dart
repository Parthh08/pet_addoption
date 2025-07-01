import '../models/pet_model.dart';

abstract class PetRemoteDataSource {
  Future<List<PetModel>> getPets({int page = 0, int limit = 20});
  Future<List<PetModel>> searchPets(
    String query, {
    int page = 0,
    int limit = 20,
  });
}
