part of 'favorites_bloc.dart';

abstract class FavoritesEvents extends Equatable {
  const FavoritesEvents();

  @override
  List<Object> get props => [];
}

class reFetchFavotires extends FavoritesEvents {}

class saveToFavorites extends FavoritesEvents {
  final CityGioOrdinates city;

  const saveToFavorites({required this.city});

  @override
  List<Object> get props => [city];
}

class deleteFromFavorites extends FavoritesEvents {
  final CityGioOrdinates city;

  const deleteFromFavorites({required this.city});

  @override
  List<Object> get props => [city];
}
