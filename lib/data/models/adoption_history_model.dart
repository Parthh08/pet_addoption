import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/adoption_history.dart';

part 'adoption_history_model.g.dart';

@JsonSerializable()
class AdoptionHistoryModel extends AdoptionHistory {
  const AdoptionHistoryModel({
    required super.petId,
    required super.petName,
    required super.petImageUrl,
    required super.adoptedDate,
    required super.price,
  });

  factory AdoptionHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$AdoptionHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdoptionHistoryModelToJson(this);
}
