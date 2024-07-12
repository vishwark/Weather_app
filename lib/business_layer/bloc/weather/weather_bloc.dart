import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data_layer/data_model/weather_data.dart';
import 'package:weather_app/data_layer/api_repository.dart';

part 'events.dart';
part 'state.dart';

//for individual city weather data
class WeatherBloc extends Bloc<WeatherEvents, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    final ApiRepository apiRepository = ApiRepository();

    on<GetWeatherData>((event, emit) async {
      try {
        emit(WeatherLoading());
        final data = await apiRepository.fetchWeatherData(
          event.latitude,
          event.longitude,
        );
        emit(WeatherLoaded(data!));
      } catch (e) {
        emit(
            const WeatherError("Failed to fetch data. is your device online?"));
      }
    });
  }
}
