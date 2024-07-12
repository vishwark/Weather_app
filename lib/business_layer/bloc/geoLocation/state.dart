part of 'location_bloc.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class FetchingLocation extends LocationState {}

class LocationLoaded extends LocationState {
  Position location;
  LocationLoaded({
    required this.location,
  });
}

class LocationError extends LocationState {
  String error;
  LocationError({
    required this.error,
  });
}

class LocationPermissionDenied extends LocationState {}
