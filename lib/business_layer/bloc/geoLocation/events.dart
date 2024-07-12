part of 'location_bloc.dart';

abstract class LocationEvents extends Equatable {
  const LocationEvents();

  @override
  List<Object> get props => [];
}

class GetLocation extends LocationEvents {}

class ResetState extends LocationEvents {}
