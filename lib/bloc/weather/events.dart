part of 'weather_bloc.dart';

abstract class WeatherEvents extends Equatable {
  const WeatherEvents();

  @override
  List<Object> get props => [];
}

class GetWeatherData extends WeatherEvents {
  final double longitude;
  final double latitude;

  const GetWeatherData({required this.longitude, required this.latitude});

  @override
  List<Object> get props => [longitude, latitude];
}
