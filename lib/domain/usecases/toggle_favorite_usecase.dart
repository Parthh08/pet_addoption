import '../entities/pet.dart';
import '../repositories/pet_repository.dart';

class ToggleFavoriteUseCase {
  final PetRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<void> call(Pet pet) async {
    await repository.toggleFavorite(pet);
  }
}
