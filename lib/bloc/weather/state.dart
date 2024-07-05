part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherData weatherData;
  const WeatherLoaded(this.weatherData);
}

class FavoritesStateWithNewEntry extends WeatherState {
  final WeatherData weatherData;
  const FavoritesStateWithNewEntry(this.weatherData);
}

class WeatherError extends WeatherState {
  final String? message;
  const WeatherError(this.message);
}
