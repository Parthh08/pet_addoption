import 'package:equatable/equatable.dart';

class Pet extends Equatable {
  final String id;
  final String name;
  final String breed;
  final int age;
  final double price;
  final String imageUrl;
  final String description;
  final String type; 
  final String gender;
  final String size;
  final bool isAdopted;
  final bool isFavorite;
  final DateTime? adoptedDate;

  const Pet({
    required this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.type,
    required this.gender,
    required this.size,
    this.isAdopted = false,
    this.isFavorite = false,
    this.adoptedDate,
  });

  Pet copyWith({
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
    return Pet(
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

  @override
  List<Object?> get props => [
    id,
    name,
    breed,
    age,
    price,
    imageUrl,
    description,
    type,
    gender,
    size,
    isAdopted,
    isFavorite,
    adoptedDate,
  ];
}
