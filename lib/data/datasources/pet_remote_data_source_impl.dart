import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import '../models/pet_model.dart';
import 'pet_remote_data_source.dart';

class PetRemoteDataSourceImpl implements PetRemoteDataSource {
  final Dio dio;

  PetRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PetModel>> getPets({int page = 0, int limit = 20}) async {
    try {
      final pets = <PetModel>[];

      final catResponse = await dio.get(
        '${AppConstants.baseUrl}images/search',
        queryParameters: {
          'limit': limit ~/ 2,
          'page': page,
          'has_breeds': 1,
          'include_breeds': 1,
        },
      );

      if (catResponse.statusCode == 200) {
        final catData = catResponse.data as List;
        pets.addAll(catData.map((json) => PetModel.fromCatApi(json)).toList());
      }

      final dogResponse = await dio.get(
        '${AppConstants.dogApiUrl}images/search',
        queryParameters: {
          'limit': limit ~/ 2,
          'page': page,
          'has_breeds': 1,
          'include_breeds': 1,
        },
      );

      if (dogResponse.statusCode == 200) {
        final dogData = dogResponse.data as List;
        pets.addAll(dogData.map((json) => PetModel.fromDogApi(json)).toList());
      }

      pets.shuffle();
      return pets;
    } catch (e) {
      throw Exception('Failed to load pets: $e');
    }
  }

  @override
  Future<List<PetModel>> searchPets(
    String query, {
    int page = 0,
    int limit = 20,
  }) async {
    try {
      final allPets = await getPets(page: 0, limit: 50);
      final searchResults =
          allPets.where((pet) {
            final lowerQuery = query.toLowerCase();
            return pet.name.toLowerCase().contains(lowerQuery) ||
                pet.breed.toLowerCase().contains(lowerQuery) ||
                pet.type.toLowerCase().contains(lowerQuery);
          }).toList();

      return searchResults.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to search pets: $e');
    }
  }
}
