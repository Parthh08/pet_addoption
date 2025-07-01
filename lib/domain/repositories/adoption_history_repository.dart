import '../entities/adoption_history.dart';

abstract class AdoptionHistoryRepository {
  Future<List<AdoptionHistory>> getAdoptionHistory();
  Future<void> addToHistory(AdoptionHistory adoption);
  Future<void> clearHistory();
}
