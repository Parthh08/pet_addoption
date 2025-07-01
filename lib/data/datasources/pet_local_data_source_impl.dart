import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../models/pet_model.dart';
import '../models/adoption_history_model.dart';
import 'pet_local_data_source.dart';

class PetLocalDataSourceImpl implements PetLocalDataSource {
  final SharedPreferences sharedPreferences;

  PetLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<PetModel>> getFavoritePets() async {
    try {
      final jsonString = sharedPreferences.getString(
        AppConstants.favoritePetsKey,
      );
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => PetModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<PetModel>> getAdoptedPets() async {
    try {
      final jsonString = sharedPreferences.getString(
        AppConstants.adoptedPetsKey,
      );
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => PetModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveFavoritePet(PetModel pet) async {
    final favorites = await getFavoritePets();
    final existingIndex = favorites.indexWhere((p) => p.id == pet.id);

    if (existingIndex == -1) {
      favorites.add(pet.copyWith(isFavorite: true));
    }

    final jsonString = json.encode(
      favorites.map((pet) => pet.toJson()).toList(),
    );
    await sharedPreferences.setString(AppConstants.favoritePetsKey, jsonString);
  }

  @override
  Future<void> removeFavoritePet(String petId) async {
    final favorites = await getFavoritePets();
    favorites.removeWhere((pet) => pet.id == petId);

    final jsonString = json.encode(
      favorites.map((pet) => pet.toJson()).toList(),
    );
    await sharedPreferences.setString(AppConstants.favoritePetsKey, jsonString);
  }

  @override
  Future<void> saveAdoptedPet(PetModel pet) async {
    final adopted = await getAdoptedPets();
    final existingIndex = adopted.indexWhere((p) => p.id == pet.id);

    if (existingIndex == -1) {
      adopted.add(pet.copyWith(isAdopted: true, adoptedDate: DateTime.now()));
    }

    final jsonString = json.encode(adopted.map((pet) => pet.toJson()).toList());
    await sharedPreferences.setString(AppConstants.adoptedPetsKey, jsonString);
  }

  @override
  Future<List<AdoptionHistoryModel>> getAdoptionHistory() async {
    try {
      final jsonString = sharedPreferences.getString(
        AppConstants.adoptionHistoryKey,
      );
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList
            .map((json) => AdoptionHistoryModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveAdoptionHistory(AdoptionHistoryModel history) async {
    final historyList = await getAdoptionHistory();
    historyList.add(history);

    historyList.sort((a, b) => b.adoptedDate.compareTo(a.adoptedDate));

    final jsonString = json.encode(historyList.map((h) => h.toJson()).toList());
    await sharedPreferences.setString(
      AppConstants.adoptionHistoryKey,
      jsonString,
    );
  }

  @override
  Future<void> clearAllData() async {
    await sharedPreferences.remove(AppConstants.favoritePetsKey);
    await sharedPreferences.remove(AppConstants.adoptedPetsKey);
    await sharedPreferences.remove(AppConstants.adoptionHistoryKey);
  }
}
