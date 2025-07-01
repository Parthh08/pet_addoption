import '../entities/adoption_history.dart';
import '../repositories/adoption_history_repository.dart';

class GetAdoptionHistoryUseCase {
  final AdoptionHistoryRepository repository;

  GetAdoptionHistoryUseCase(this.repository);

  Future<List<AdoptionHistory>> call() async {
    return repository.getAdoptionHistory();
  }
}
