import '../entities/pet.dart';
import '../repositories/pet_repository.dart';

class GetPetsUseCase {
  final PetRepository repository;

  GetPetsUseCase(this.repository);

  Future<List<Pet>> call({int page = 0, int limit = 20}) async {
    return repository.getPets(page: page, limit: limit);
  }
}
