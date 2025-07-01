import 'package:equatable/equatable.dart';
import '../../domain/entities/pet.dart';

abstract class PetState extends Equatable {
  const PetState();

  @override
  List<Object> get props => [];
}

class PetInitial extends PetState {}

class PetLoading extends PetState {}

class PetLoaded extends PetState {
  final List<Pet> pets;
  final bool hasReachedMax;
  final int currentPage;
  final String? searchQuery;

  const PetLoaded({
    this.pets = const [],
    this.hasReachedMax = false,
    this.currentPage = 0,
    this.searchQuery,
  });

  PetLoaded copyWith({
    List<Pet>? pets,
    bool? hasReachedMax,
    int? currentPage,
    String? searchQuery,
  }) {
    return PetLoaded(
      pets: pets ?? this.pets,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [
    pets,
    hasReachedMax,
    currentPage,
    searchQuery ?? '',
  ];
}

class PetError extends PetState {
  final String message;

  const PetError(this.message);

  @override
  List<Object> get props => [message];
}

class PetAdopted extends PetState {
  final Pet pet;

  const PetAdopted(this.pet);

  @override
  List<Object> get props => [pet];
}

class FavoriteToggled extends PetState {
  final Pet pet;

  const FavoriteToggled(this.pet);

  @override
  List<Object> get props => [pet];
}
