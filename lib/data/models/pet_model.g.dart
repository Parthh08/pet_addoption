part of 'pet_model.dart';

PetModel _$PetModelFromJson(Map<String, dynamic> json) => PetModel(
  id: json['id'] as String,
  name: json['name'] as String,
  breed: json['breed'] as String,
  age: (json['age'] as num).toInt(),
  price: (json['price'] as num).toDouble(),
  imageUrl: json['imageUrl'] as String,
  description: json['description'] as String,
  type: json['type'] as String,
  gender: json['gender'] as String,
  size: json['size'] as String,
  isAdopted: json['isAdopted'] as bool? ?? false,
  isFavorite: json['isFavorite'] as bool? ?? false,
  adoptedDate:
      json['adoptedDate'] == null
          ? null
          : DateTime.parse(json['adoptedDate'] as String),
);

Map<String, dynamic> _$PetModelToJson(PetModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'breed': instance.breed,
  'age': instance.age,
  'price': instance.price,
  'imageUrl': instance.imageUrl,
  'description': instance.description,
  'type': instance.type,
  'gender': instance.gender,
  'size': instance.size,
  'isAdopted': instance.isAdopted,
  'isFavorite': instance.isFavorite,
  'adoptedDate': instance.adoptedDate?.toIso8601String(),
};
