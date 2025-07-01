import 'package:equatable/equatable.dart';
import '../../domain/entities/pet.dart';

abstract class PetEvent extends Equatable {
  const PetEvent();

  @override
  List<Object> get props => [];
}

class LoadPets extends PetEvent {
  final int page;
  final bool isRefresh;

  const LoadPets({this.page = 0, this.isRefresh = false});

  @override
  List<Object> get props => [page, isRefresh];
}

class SearchPets extends PetEvent {
  final String query;
  final int page;

  const SearchPets({required this.query, this.page = 0});

  @override
  List<Object> get props => [query, page];
}

class LoadMorePets extends PetEvent {
  const LoadMorePets();
}

class AdoptPet extends PetEvent {
  final Pet pet;

  const AdoptPet(this.pet);

  @override
  List<Object> get props => [pet];
}

class ToggleFavoritePet extends PetEvent {
  final Pet pet;

  const ToggleFavoritePet(this.pet);

  @override
  List<Object> get props => [pet];
}

class ClearSearch extends PetEvent {
  const ClearSearch();
}
