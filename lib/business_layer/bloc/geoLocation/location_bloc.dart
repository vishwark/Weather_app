import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/utility/geolocation.dart';

part 'events.dart';
part 'state.dart';

class LocationBloc extends Bloc<LocationEvents, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<GetLocation>((event, emit) async {
      try {
        print("22222222222----inside event event");
        emit(FetchingLocation());
        GeolocationResult result =
            await GeolocationUtility().determinePosition();
        if (result.status == GeolocationStatus.granted) {
          emit(LocationLoaded(location: result.position!));
          print("22222222222----location fetched ${result.position}");
        } else {
          print("22222222222----permission denied ${result.position}");
          emit(LocationPermissionDenied());
        }
      } catch (e) {
        emit(LocationError(error: e.toString()));
      }
    });

    on<ResetState>((event, emit) {
      emit(LocationInitial());
    });
  }
}
