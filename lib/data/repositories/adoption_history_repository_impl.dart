import '../../domain/entities/adoption_history.dart';
import '../../domain/repositories/adoption_history_repository.dart';
import '../datasources/pet_local_data_source.dart';
import '../models/adoption_history_model.dart';

class AdoptionHistoryRepositoryImpl implements AdoptionHistoryRepository {
  final PetLocalDataSource localDataSource;

  AdoptionHistoryRepositoryImpl({required this.localDataSource});

  @override
  Future<List<AdoptionHistory>> getAdoptionHistory() async {
    return await localDataSource.getAdoptionHistory();
  }

  @override
  Future<void> addToHistory(AdoptionHistory adoption) async {
    final historyModel = AdoptionHistoryModel(
      petId: adoption.petId,
      petName: adoption.petName,
      petImageUrl: adoption.petImageUrl,
      adoptedDate: adoption.adoptedDate,
      price: adoption.price,
    );

    await localDataSource.saveAdoptionHistory(historyModel);
  }

  @override
  Future<void> clearHistory() async {
    await localDataSource.clearAllData();
  }
}
