import '../entities/pet.dart';
import '../repositories/pet_repository.dart';

class SearchPetsUseCase {
  final PetRepository repository;

  SearchPetsUseCase(this.repository);

  Future<List<Pet>> call(String query, {int page = 0, int limit = 20}) async {
    if (query.trim().isEmpty) {
      return repository.getPets(page: page, limit: limit);
    }
    return repository.searchPets(query, page: page, limit: limit);
  }
}
