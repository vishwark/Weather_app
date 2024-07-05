part of 'aqi_bloc.dart';

abstract class AQIState extends Equatable {
  const AQIState();

  @override
  List<Object?> get props => [];
}

class AQIInitial extends AQIState {}

class AQILoading extends AQIState {}

class AQILoaded extends AQIState {
  final AirQualityModel airQualityModel;
  const AQILoaded(this.airQualityModel);
}

class AQIError extends AQIState {
  final String? message;
  const AQIError(this.message);
}
