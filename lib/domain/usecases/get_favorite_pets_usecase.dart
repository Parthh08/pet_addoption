import '../entities/pet.dart';
import '../repositories/pet_repository.dart';

class GetFavoritePetsUseCase {
  final PetRepository repository;

  GetFavoritePetsUseCase(this.repository);

  Future<List<Pet>> call() async {
    return repository.getFavoritePets();
  }
}
