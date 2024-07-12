import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data_layer/data_model/air_pollution_param.dart';
import 'package:weather_app/data_layer/api_repository.dart';

part 'events.dart';
part 'state.dart';

class AQIBloc extends Bloc<AQIEvents, AQIState> {
  AQIBloc() : super(AQIInitial()) {
    final ApiRepository apiRepository = ApiRepository();

    on<GetAQIData>((event, emit) async {
      try {
        emit(AQILoading());
        final data = await apiRepository.fetchAirQualityData(
          event.latitude,
          event.longitude,
        );
        emit(AQILoaded(data!));
      } catch (e) {
        emit(
          const AQIError("Failed to fetch aqi data. is your device online?"),
        );
      }
    });
  }
}
