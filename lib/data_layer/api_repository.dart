import 'package:weather_app/data_layer/data_model/air_pollution_param.dart';
import 'package:weather_app/data_layer/data_model/gio_coordinates.dart';
import 'package:weather_app/data_layer/data_model/weather_data.dart';
import 'package:weather_app/data_layer/api_provider.dart';

class ApiRepository {
  final _apiProvider = WeatherAPI();
  Future<List<dynamic>> searchCity(String city) {
    return _apiProvider.searchCity(city);
  }

  Future<WeatherData?> fetchWeatherData(double lon, double lat) {
    return _apiProvider.fetchWeatherData(lon, lat);
  }

  Future<AirQualityModel?> fetchAirQualityData(double lon, double lat) {
    return _apiProvider.getAQIdata(lon, lat);
  }

  Future<List<WeatherData>> fetchFavoriteCitiesWeatherData(
      List<CityGioOrdinates> cities) {
    return _apiProvider.fetchFavoritesWeatherData(cities);
  }
}
