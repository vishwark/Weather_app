part of 'favorites_bloc.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesStateInitial extends FavoritesState {}

class FavoritesStateLoading extends FavoritesState {}

class FavoritesStateAdded extends FavoritesState {}

class FavoritesStateDeleted extends FavoritesState {}

class FavoritesStateDuplicateEntry extends FavoritesState {}

class FavoritesStateEmpty extends FavoritesState {}

class FavoritesStateLoaded extends FavoritesState {
  final List<WeatherData> favoritesStateData;
  const FavoritesStateLoaded(this.favoritesStateData);
}

class FavoritesStateError extends FavoritesState {
  final String message;
  const FavoritesStateError(this.message);
}
