part of 'adoption_history_model.dart';

AdoptionHistoryModel _$AdoptionHistoryModelFromJson(
  Map<String, dynamic> json,
) => AdoptionHistoryModel(
  petId: json['petId'] as String,
  petName: json['petName'] as String,
  petImageUrl: json['petImageUrl'] as String,
  adoptedDate: DateTime.parse(json['adoptedDate'] as String),
  price: (json['price'] as num).toDouble(),
);

Map<String, dynamic> _$AdoptionHistoryModelToJson(
  AdoptionHistoryModel instance,
) => <String, dynamic>{
  'petId': instance.petId,
  'petName': instance.petName,
  'petImageUrl': instance.petImageUrl,
  'adoptedDate': instance.adoptedDate.toIso8601String(),
  'price': instance.price,
};
