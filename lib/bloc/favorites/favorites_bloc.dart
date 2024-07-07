import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data_model/gio_coordinates.dart';
import 'package:weather_app/data_model/weather_data.dart';
import 'package:weather_app/pages/add-city.dart';
import 'package:weather_app/utility/api_repository.dart';
import 'package:weather_app/utility/shared_preference/favCities.dart';

part 'events.dart';
part 'state.dart';

class FavoritesBloc extends Bloc<FavoritesEvents, FavoritesState> {
  FavoritesStateLoaded? _lastLoadedState;
  FavoritesBloc() : super(FavoritesStateInitial()) {
    _initializeFavorites();
    on<saveToFavorites>((event, emit) async {
      try {
        emit(FavoritesStateLoading());
        List<CityGioOrdinates>? cities =
            await CityPreferences().addCity(event.city);
        print("11111111111111--23");
        print(cities);
        if (cities == null) {
          emit(FavoritesStateDuplicateEntry());
          print("11111111111111-----24");
          print(_lastLoadedState);
          if (_lastLoadedState != null) {
            print("11111111111111-----25");
            emit(_lastLoadedState!);
          }
          return;
        }
        List<WeatherData> weatherData =
            await ApiRepository().fetchFavoriteCitiesWeatherData(cities!);
        _lastLoadedState = FavoritesStateLoaded(weatherData);
        emit(_lastLoadedState!);
      } catch (e) {
        emit(
          const FavoritesStateError("Failed to save new location!"),
        );
      }
    });

    on<deleteFromFavorites>((event, emit) async {
      try {
        emit(FavoritesStateLoading());
        List<CityGioOrdinates> cities =
            await CityPreferences().deleteCity(event.city);
        if (cities.length == 0) {
          return emit(FavoritesStateEmpty());
        }
        var weatherData =
            await ApiRepository().fetchFavoriteCitiesWeatherData(cities);
        emit(FavoritesStateLoaded(weatherData));
      } catch (e) {
        emit(
          const FavoritesStateError("Failed to fetch aqi data"),
        );
      }
    });
  }
  Future<void> _initializeFavorites() async {
    List<CityGioOrdinates> cities = await CityPreferences().loadCities();
    if (cities.isNotEmpty) {
      List<WeatherData> weatherData =
          await ApiRepository().fetchFavoriteCitiesWeatherData(cities);
      _lastLoadedState = FavoritesStateLoaded(weatherData);
      emit(_lastLoadedState!);
    } else {
      emit(FavoritesStateEmpty());
    }
  }
}
