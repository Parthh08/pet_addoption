import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/pet.dart';

part 'pet_model.g.dart';

@JsonSerializable()
class PetModel extends Pet {
  const PetModel({
    required super.id,
    required super.name,
    required super.breed,
    required super.age,
    required super.price,
    required super.imageUrl,
    required super.description,
    required super.type,
    required super.gender,
    required super.size,
    super.isAdopted,
    super.isFavorite,
    super.adoptedDate,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) =>
      _$PetModelFromJson(json);

  Map<String, dynamic> toJson() => _$PetModelToJson(this);
  factory PetModel.fromCatApi(Map<String, dynamic> json) {
    final breeds = json['breeds'] as List?;
    final breedInfo = breeds?.isNotEmpty == true ? breeds!.first : {};
    final fallbackBreeds = [
      'Persian',
      'Maine Coon',
      'British Shorthair',
      'Russian Blue',
      'Siamese',
      'Ragdoll',
      'Bengal',
      'Abyssinian',
      'Scottish Fold',
      'Sphynx',
      'American Shorthair',
      'Birman',
    ];

    return PetModel(
      id: json['id'] ?? '',
      name: _generateRandomName(),
      breed: breedInfo['name'] ?? _getRandomBreed(fallbackBreeds),
      age: _generateRandomAge(),
      price: _generateRandomPrice(),
      imageUrl: json['url'] ?? '',
      description:
          breedInfo['description'] ?? 'A lovely cat looking for a home.',
      type: 'cat',
      gender: _generateRandomGender(),
      size: _mapWeightToSize(breedInfo['weight']),
    );
  }

  factory PetModel.fromDogApi(Map<String, dynamic> json) {
    final breeds = json['breeds'] as List?;
    final breedInfo = breeds?.isNotEmpty == true ? breeds!.first : {};

    final fallbackBreeds = [
      'Golden Retriever',
      'Labrador Retriever',
      'German Shepherd',
      'Bulldog',
      'Poodle',
      'Beagle',
      'Rottweiler',
      'Siberian Husky',
      'Dachshund',
      'Border Collie',
      'Australian Shepherd',
      'Boxer',
    ];

    return PetModel(
      id: json['id'] ?? '',
      name: _generateRandomName(),
      breed: breedInfo['name'] ?? _getRandomBreed(fallbackBreeds),
      age: _generateRandomAge(),
      price: _generateRandomPrice(),
      imageUrl: json['url'] ?? '',
      description:
          breedInfo['temperament'] != null
              ? 'A ${breedInfo['temperament'].toString().toLowerCase()} dog looking for a loving home.'
              : 'A lovely dog looking for a home.',
      type: 'dog',
      gender: _generateRandomGender(),
      size: _mapWeightToSize(breedInfo['weight']),
    );
  }

  static String _generateRandomName() {
    final names = [
      'Buddy',
      'Max',
      'Bella',
      'Lucy',
      'Charlie',
      'Luna',
      'Cooper',
      'Daisy',
      'Milo',
      'Sadie',
      'Rocky',
      'Molly',
      'Bear',
      'Lola',
      'Jack',
      'Sophie',
      'Duke',
      'Stella',
      'Zeus',
      'Zoe',
      'Oliver',
      'Chloe',
      'Leo',
      'Penny',
      'Tucker',
      'Nala',
      'Finn',
      'Ruby',
      'Oscar',
      'Lily',
    ];
    names.shuffle();
    return names.first;
  }

  static String _getRandomBreed(List<String> breeds) {
    breeds.shuffle();
    return breeds.first;
  }

  static int _generateRandomAge() {
    return (1 + (8 * (0.5 - (0.5 * 0.8)))).round();
  }

  static double _generateRandomPrice() {
    final prices = [50.0, 75.0, 100.0, 125.0, 150.0, 200.0, 250.0, 300.0];
    prices.shuffle();
    return prices.first;
  }

  static String _generateRandomGender() {
    return ['Male', 'Female'][DateTime.now().millisecond % 2];
  }

  static String _mapWeightToSize(dynamic weight) {
    if (weight == null) return 'Medium';

    final weightStr =
        weight is Map ? weight['metric'] ?? '' : weight.toString();
    final weightRange = weightStr.toString().split(' - ');

    if (weightRange.isNotEmpty) {
      final firstWeight =
          double.tryParse(
            weightRange.first.replaceAll(RegExp(r'[^0-9.]'), ''),
          ) ??
          5;
      if (firstWeight < 5) return 'Small';
      if (firstWeight < 15) return 'Medium';
      return 'Large';
    }

    return 'Medium';
  }

  @override
  PetModel copyWith({
    String? id,
    String? name,
    String? breed,
    int? age,
    double? price,
    String? imageUrl,
    String? description,
    String? type,
    String? gender,
    String? size,
    bool? isAdopted,
    bool? isFavorite,
    DateTime? adoptedDate,
  }) {
    return PetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      type: type ?? this.type,
      gender: gender ?? this.gender,
      size: size ?? this.size,
      isAdopted: isAdopted ?? this.isAdopted,
      isFavorite: isFavorite ?? this.isFavorite,
      adoptedDate: adoptedDate ?? this.adoptedDate,
    );
  }
}
