import '../entities/pet.dart';
import '../entities/adoption_history.dart';
import '../repositories/pet_repository.dart';
import '../repositories/adoption_history_repository.dart';

class AdoptPetUseCase {
  final PetRepository petRepository;
  final AdoptionHistoryRepository historyRepository;

  AdoptPetUseCase(this.petRepository, this.historyRepository);

  Future<void> call(Pet pet) async {
    
    final history = AdoptionHistory(
      petId: pet.id,
      petName: pet.name,
      petImageUrl: pet.imageUrl,
      adoptedDate: DateTime.now(),
      price: pet.price,
    );

    await historyRepository.addToHistory(history);

    await petRepository.adoptPet(pet);
  }
}
