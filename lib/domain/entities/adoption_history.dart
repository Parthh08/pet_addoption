import 'package:equatable/equatable.dart';

class AdoptionHistory extends Equatable {
  final String petId;
  final String petName;
  final String petImageUrl;
  final DateTime adoptedDate;
  final double price;

  const AdoptionHistory({
    required this.petId,
    required this.petName,
    required this.petImageUrl,
    required this.adoptedDate,
    required this.price,
  });

  @override
  List<Object?> get props => [petId, petName, petImageUrl, adoptedDate, price];
}
