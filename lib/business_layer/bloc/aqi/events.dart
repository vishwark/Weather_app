part of 'aqi_bloc.dart';

abstract class AQIEvents extends Equatable {
  const AQIEvents();

  @override
  List<Object> get props => [];
}

class GetAQIData extends AQIEvents {
  final double longitude;
  final double latitude;

  const GetAQIData({required this.longitude, required this.latitude});

  @override
  List<Object> get props => [longitude, latitude];
}
